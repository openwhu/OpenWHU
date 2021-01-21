# Test the MIPS processor in simulation
# add, sub, and, or, slt, addi, lw, sw, beq, j, jal
# If successful, it should write the value 7 to address 256, 260

#       Assembly                  Description           Instr   Address Machine
main:   addi $2, $0, 5          # initialize $2 = 5     00      0       20020005
        addi $3, $0, 12         # initialize $3 = 12    01      4       2003000c
        addi $7, $3, -9         # initialize $7 = 3     02      8       2067fff7
        or   $4, $7, $2         # $4 = (3 or 5) = 7     03      c       00e22025
        and  $5, $3, $4         # $5 = (12 and 7) = 4   04      10      00642824
        add  $5, $5, $4         # $5 = 4 + 7 = 11       05      14      00a42820
        beq  $5, $7, label2     # shouldn't be taken    06      18      10a7000a
        slt  $4, $3, $4         # $4 = (12 < 7) = 0     07      1c      0064202a
        beq  $4, $0, label1     # should be taken       08      20      10800001
        addi $5, $0, 0          # shouldn't happen      09      24      20050000
label1: slt  $4, $7, $2         # $4 = (3 < 5) = 1      0A      28      00e2202a
        add  $7, $4, $5         # $7 = 1 + 11 = 12      0B      2c      00853820
        sub  $7, $7, $2         # $7 = 12 - 5 = 7       0C      30      00e23822
        sw   $7, 244($3)        # [256] = 7             0D      34      ac6700f4
        lw   $2, 256($0)        # $2 = [256] = 7        0E      38      8c020100
        jal  label2             # should be taken       0F      3c      0c000011
        addi $2, $0, 1          # shouldn't happen      10      40      20020001
label2: sw   $2, 260($0)        # write adr 260 = 7     11      44      ac020104
loop:   j    loop               # dead loop             12      48      08000012

# $0  = 0  # $1  = 0  # $2  = 7  # $3  = c
# $4  = 1  # $5  = b  # $7  = 7  # $31 = 40
# [0x100] = 7  [0x104] = 7

