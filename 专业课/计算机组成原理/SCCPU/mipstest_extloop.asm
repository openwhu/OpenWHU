# mipstest_ext.asm
# 2017202110132@whu.edu.cn 17 March 2018 
#
# Test the MIPS processor in simulation
# add, sub, and, or, slt, addi, lw, sw, beq, j have been done in mipstest.asm
# we add sll, lui, slti, bne, jal, ori, addu, subu, jr, andi, srl and jalr instruction
# If successful, it should write the value 7 to address 256 and 260, and register $1 should be 0

#       Assembly            Description          Address   Machine
main:   addi $2, $0, 5      # initialize $2 = 5    0       20020005
        addi $3, $0, 12     # initialize $3 = 12   4       2003000c
        addi $7, $3, -9     # initialize $7 = 3    8       2067fff7 
        addi $1, $0, 76     # initialize $1 = 76   c       2001004c
call_a: jalr $31,$1         # jump to cal          10      0020f809
        or   $4, $7, $2     # $4 <= 3 or 5 = 7     14      00e22025
        and  $5, $3, $4     # $5 <= 12 and 7 = 4   18      00642824
        add  $5, $5, $4     # $5 = 4 + 7 = 11      1c      00a42820
        beq  $5, $7, end    # shouldn't be taken   20      10a70017
        slt  $4, $3, $4     # $4 = 12 < 7 = 0      24      0064202a
        beq  $4, $0, around # should be taken      28      10800001
        addi $5, $0, 0      # shouldn't happen     2c      20050000
around: slt  $4, $7, $2     # $4 = 3 < 5 = 1       30      00e2202a
        add  $7, $4, $5     # $7 = 1 + 11 = 12     34      00853820
        sub  $7, $7, $2     # $7 = 12 - 5 = 7      38      00e23822
        sw   $7, 244($3)    # [256] = 7            34      ac6700f4
        lw   $2, 256($0)    # $2 = [256] = 7       38      8c020100
        j    end            # should be taken      44      08000020
        addi $2, $0, 1      # shouldn't happen     48      20020001
cal:    sll  $7, $7, 1      # $7 << 1 = 6          4c      00073840
call_b: jal  cal2           # jump to cal2         50      0c000017
        addi $31,$0,20      # $31<= 20             54      201f0014
        jr   $31            # return to call_a     58      03e00008
cal2:   lui  $1, 0x55AA     # $1 <= 0x55AA0000     5c      3c0155aa
        slti $1, $1, 0x55AA # $1 <= 0              60      282155aa
        bne  $1, $0, end    # shouldn't be taken   64      14200006
        ori  $7, $7, 5      # $7 <= 6 or 5 = 7     68      34e70005
        andi $1, $7, 5      # $1 <= 7 and 5 = 5    6c      30e10005
        addu $1, $7, $1     # $1 = 7+5 = 12        70      00e10821
        subu $1, $1, $1     # $1 =12-12 = 0        74      00210823
        srl  $7, $7, 1      # $7 >> 1 = 3          78      00073842
        jr   $31            # return to call_b     7c      03e00008
end:    sw   $2, 260($0)    # write adr 260 = 7    80      ac020104
loop:   j    loop

# $0  = 0  # $1  = 0  # $2  = 7  # $3  = c
# $4  = 1  # $5  = b  # $7  = 7  # $31 = 14h
# [0x100] = 7  [0x104] = 7

