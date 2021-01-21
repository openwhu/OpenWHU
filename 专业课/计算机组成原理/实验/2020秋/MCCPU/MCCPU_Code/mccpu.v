module mccpu( clk, rst, instr, readdata, PC, MemWrite, adr, writedata, reg_sel, reg_data);
         
   input        clk;        // clock
   input        rst;        // reset
   
   output [31:0]  instr;    // instruction
   output [31:0]  PC;       // PC address
   input  [31:0]  readdata; // data from data memory
   
   output        MemWrite;  // memory write
   output [31:0] adr;       // memory address
   output [31:0] writedata; // data to data memory
   
   input  [4:0]  reg_sel;   // register selection (for debug use)
   output [31:0] reg_data;  // selected register data (for debug use)
   
   wire        RegWrite;    // control signal to register write
   wire        PCWrite;     // control signal for PC write
   wire        IRWrite;     // control signal for IR write
   wire        EXTOp;       // control signal to signed extension
   wire [3:0]  ALUOp;       // ALU opertion
   wire [1:0]  PCSource;    // next PC operation
   wire        IorD;         // memory access for instruction or data

   wire [1:0]  WDSel;       // (register) write data selection
   wire [1:0]  GPRSel;      // general purpose register selection
   
   wire [1:0]  ALUSrcA;     // ALU source for A
   wire [1:0]  ALUSrcB;     // ALU source for B
   wire        Zero;        // ALU ouput zero


   wire [31:0] aluresult;    // alu result
   wire [31:0] aluout;       // alu out
   
   wire [4:0]  rs;          // rs
   wire [4:0]  rt;          // rt
   wire [4:0]  rd;          // rd
   wire [5:0]  Op;          // opcode
   wire [5:0]  Funct;       // funct
   wire [15:0] Imm16;       // 16-bit immediate
   wire [31:0] Imm32;       // 32-bit immediate
   wire [25:0] IMM;         // 26-bit immediate (address)
   wire [4:0]  A3;          // register address for write
   wire [31:0] WD;          // register write data
   wire [31:0] RD1;         // register data specified by rs
   wire [31:0] RD2;         // register data specified by rt 
   wire [31:0] A;           // register A
   wire [31:0] B;           // register B
   wire [31:0] ALUA;        // ALU A 
   wire [31:0] ALUB;        // ALU B
   wire [31:0] data;        // data
   wire [31:0] NPC;         // NPC
   wire [31:0] Shamt;       // Shamt
   
   assign Op = instr[31:26];  // instruction
   assign Funct = instr[5:0]; // funct
   assign rs = instr[25:21];  // rs
   assign rt = instr[20:16];  // rt
   assign rd = instr[15:11];  // rd
   assign Imm16 = instr[15:0];// 16-bit immediate
   assign IMM = instr[25:0];  // 26-bit immediate
   assign Shamt = {27'b0, instr[10:6]};
   
   // instantiation of control unit
   ctrl U_CTRL ( 
       .clk(clk), .rst(rst), .Zero(Zero), .Op(Op), .Funct(Funct),
       .RegWrite(RegWrite), .MemWrite(MemWrite),
       .PCWrite(PCWrite), .IRWrite(IRWrite),
       .EXTOp(EXTOp), .ALUOp(ALUOp), .PCSource(PCSource),
       .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), 
       .GPRSel(GPRSel), .WDSel(WDSel), .IorD(IorD));
   
   // instantiation of PC
   flopenr #(32) U_PC (
      .clk(clk), .rst(rst), .en(PCWrite), .d(NPC), .q(PC)
   );
   
   // mux for PC source
   mux4 #(32) U_MUX4_PC (
      .d0(aluresult), .d1(aluout), .d2({PC[31:28], IMM, 2'b00}), .d3(RD1), 
      .s(PCSource), .y(NPC)
   );
   
   mux2 #(32) U_MUX_ADR (
      .d0(PC), .d1(aluout), .s(IorD), .y(adr)
   ); 
   
   // instantiation of IR
   flopenr #(32) U_IR (
      .clk(clk), .rst(rst), .en(IRWrite), .d(readdata), .q(instr)
   );

   // instantiation of Data Register
   flopr  #(32) U_DataR(
      .clk(clk), .rst(rst), .d(readdata), .q(data)
   );

   // instantiation of register file
   RF U_RF (
      .clk(clk), .rst(rst), .RFWr(RegWrite), 
      .A1(rs), .A2(rt), .A3(A3), 
      .WD(WD), .RD1(RD1), .RD2(RD2),
      .reg_sel(reg_sel), .reg_data(reg_data) 
   );
   
   flopr  #(32) U_AR(clk, rst, RD1, A);//A register
   
   flopr  #(32) U_BR(clk, rst, RD2, B);//B register

   // mux for ALU A
   mux4 #(32) U_MUX_ALU_A (
      .d0(PC), .d1(A), .d2(Shamt), .d3(32'b0), .s(ALUSrcA), .y(ALUA)
   ); 
   
   // mux for signed extension or zero extension
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   // mux for ALU B
   mux4 #(32) U_MUX_ALU_B (
      .d0(B), .d1(4), .d2(Imm32), .d3({{14{Imm16[15]}}, Imm16, 2'b00}), 
      .s(ALUSrcB), .y(ALUB)
   ); 

   // instantiation of ALU
   alu U_ALU ( 
      .A(ALUA), .B(ALUB), .ALUOp(ALUOp), .C(aluresult), .Zero(Zero)
   );

   // instantiation of ALUout Register
   flopr  #(32) U_ALUR(
      .clk(clk), .rst(rst), .d(aluresult), .q(aluout)
   );

   // mux for register data to write
   mux4 #(5) U_MUX4_GPR_A3 (
      .d0(rd), .d1(rt), .d2(5'b11111), .d3(5'b0), .s(GPRSel), .y(A3)
   );
   
   // mux for register address to write
   mux4 #(32) U_MUX4_GPR_WD (
      .d0(aluout), .d1(data), .d2(PC), .d3(32'b0), .s(WDSel), .y(WD)
   );

   assign writedata = B;

endmodule