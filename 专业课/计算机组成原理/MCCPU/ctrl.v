//`include "ctrl_encode_def.v"


module ctrl(clk, rst, Zero, Op, Funct,
            RegWrite, MemWrite, PCWrite, IRWrite,
            EXTOp, ALUOp, PCSource, ALUSrcA, ALUSrcB, 
            GPRSel, WDSel, IorD);
    
   input  clk, rst, Zero;
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   output reg       RegWrite; // control signal for register write
   output reg       MemWrite; // control signal for memory write
   output reg       PCWrite;  // control signal for PC write
   output reg       IRWrite;  // control signal for IR write
   output reg       EXTOp;    // control signal to signed extension
   output reg [1:0] ALUSrcA;  // ALU source for A, 0 - PC, 1 - ReadData1, 2 - shamt
   output reg [1:0] ALUSrcB;  // ALU source for B, 0 - ReadData2, 1 - 4, 2 - extended immediate, 3 - branch offset
   output reg [3:0] ALUOp;    // ALU opertion
   output reg [2:0] PCSource; // PC source, 0- ALU, 1-ALUOut, 2-JUMP address
   output reg [1:0] GPRSel;   // general purpose register selection
   output reg [1:0] WDSel;    // (register) write data selection
   output reg       IorD;     // 0-memory access for instruction, 1 - memory access for data
   
   // GPRSel_RD   2'b00
   // GPRSel_RT   2'b01
   // GPRSel_31   2'b10
  
   // WDSel_FromALU 2'b00
   // WDSel_FromMEM 2'b01
   // WDSel_FromPC  2'b10
  
   // ALU_NOP   3'b000
   // ALU_ADD   3'b001
   // ALU_SUB   3'b010
   // ALU_AND   3'b011
   // ALU_OR    3'b100
   // ALU_SLT   3'b101
   // ALU_SLTU  3'b110

   parameter  [2:0] sif  = 3'b000,                // IF  state
                    sid  = 3'b001,                // ID  state
                    sexe = 3'b010,                // EXE state
                    smem = 3'b011,                // MEM state
                    swb  = 3'b100;                // WB  state
  // r format
   wire rtype  = ~|Op;
   wire i_add  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // add
   wire i_sub  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sub
   wire i_and  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // and
   wire i_or   = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0]; // or
   wire i_slt  = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // slt
   wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sltu
   wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // addu
   wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // subu
   wire i_jr   = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // jr
   wire i_jalr = rtype&~Funct[5]&~Funct[4]& Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // jalr
   wire i_nor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; // nor
   wire i_sll  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // sll
   wire i_srl  = rtype&~Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // srl
   wire i_sllv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // sllv
   wire i_srlv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0]; // srlv
   

  // i format
   wire i_addi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // addi
   wire i_ori  = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0]; // ori
   wire i_lw   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lw
   wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw
   wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
   wire i_bne  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; // bne
   wire i_andi = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]&~Op[0]; // andi
   wire i_lui  = ~Op[5]&~Op[4]& Op[3]& Op[2]& Op[1]& Op[0]; // lui
   wire i_slti = ~Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]&~Op[0]; // slti

  // j format
   wire i_j    = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  // j
   wire i_jal  = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  // jal

  /*************************************************/
  /******               FSM                   ******/
   reg [2:0] nextstate;
   reg [2:0] state;
   
   always @(posedge clk or posedge rst) begin
     if ( rst )
       state <= sif;
     else
       state <= nextstate;
   end // end always

  /*************************************************/
  /******         Control Signal              ******/
   always @(*) begin
     RegWrite = 0;
     MemWrite = 0;
     PCWrite  = 0;
     IRWrite  = 0;
     EXTOp    = 1;           // signed extension
     ALUSrcA  = 2'b01;           // 1 - ReadData1
     ALUSrcB  = 2'b00;       // 0 - ReadData2
     ALUOp    = 4'b0001;      // ALU_ADD       3'b001
     GPRSel   = 2'b00;       // GPRSel_RD     2'b00
     WDSel    = 2'b00;       // WDSel_FromALU 2'b00
     PCSource = 3'b000;       // PC + 4 (ALU)
     IorD     = 0;           // 0-memory access for instruction

     case (state)
         sif: begin
           PCWrite = 1;
           IRWrite = 1;
           ALUSrcA = 2'b00;      // PC
           ALUSrcB = 2'b01;  // 4
           nextstate = sid;
         end
         
         sid: begin
           if (i_j) begin
             PCSource = 3'b010; // JUMP address
             PCWrite = 1;
             nextstate = sif;
           end else if (i_jal) begin
             PCSource = 3'b010; // JUMP address
             PCWrite = 1;
             RegWrite = 1;
             WDSel = 2'b10;    // WDSel_FromPC  2'b10 
             GPRSel = 2'b10;   // GPRSel_31     2'b10
             nextstate = sif;
		   end else if (i_jr) begin
			 PCSource = 3'b100; // JUMP RS
			 PCWrite = 1;
			 nextstate = sif;
		   end else if (i_jalr) begin
		     PCSource = 3'b100; // JUMP RS
			 PCWrite = 1;
			 RegWrite = 1;
			 WDSel = 2'b10;    // WDSel_FromPC  2'b10 
             GPRSel = 2'b00;   // GPRSel_RD     2'b00
			 nextstate = sif;
           end else begin
             ALUSrcA = 2'b00;       // PC
             ALUSrcB = 2'b11;   // branch offset
             nextstate = sexe;
           end
         end
         
         sexe: begin
           ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_slt | i_addu | i_andi | i_nor | i_sll | i_sllv | i_slti;
           ALUOp[1] = i_sub | i_beq | i_and | i_sltu | i_subu | i_bne | i_andi | i_nor | i_srl | i_sllv;
           ALUOp[2] = i_or | i_ori | i_slt | i_sltu | i_nor | i_srlv | i_slti;
		   ALUOp[3] = i_lui | i_sll | i_srl | i_sllv | i_srlv;
           if (i_beq || i_bne) begin
             PCSource = 3'b001; // ALUout, branch address
             PCWrite = i_beq & Zero | i_bne & ~Zero;
             nextstate = sif;
           end else if (i_lw || i_sw) begin
             ALUSrcB = 2'b10; // select offset
             nextstate = smem;
		   end else if (i_sll | i_srl) begin
			 ALUSrcA = 2'b10;
			 EXTOp = 0;
			 nextstate = swb;
		   end else if (i_sllv | i_srlv) begin
		    ALUSrcA = 2'b01;
			EXTOp = 0;
			nextstate = swb;
           end else begin
             if (i_addi | i_ori | i_andi | i_lui | i_slti)
               ALUSrcB = 2'b10; // select immediate
             if (i_ori | i_andi | i_lui | i_slti)
               EXTOp = 0; // zero extension
             nextstate = swb;
           end
         end

         smem: begin
           IorD = 1;  // memory address  = ALUout
           if (i_lw) begin
             nextstate = swb;
           end else begin  // i_sw
             MemWrite = 1;
             nextstate = sif;
           end
         end
         
         swb: begin
           if (i_lw)
             WDSel = 2'b01;     // WDSel_FromMEM 2'b01
           if (i_lw | i_addi | i_ori | i_andi | i_lui | i_slti) begin
             GPRSel = 2'b01;    // GPRSel_RT     2'b01
           end
           RegWrite = 1;
           nextstate = sif;
         end

         default: begin
           nextstate = sif;
         end
      
     endcase
   end // end always
   
endmodule
