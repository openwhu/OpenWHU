# Test the MIPS processor in FPGA SOC
# add, sub, and, or, slt, addi, lw, sw, beq, j, jal
# If successful, it should write the value 0x7 to address 0x256, 0x260

#        Assembly                  Description              Instr    Address        Machine
main:    addi $2, $0, 0x5        # initialize $2 = 0x5       0x00      0x0       0x20020005
         addi $3, $0, 12         # initialize $3 = 12        0x01      0x4       0x2003000c
         addi $7, $3, -0x9       # initialize $7 = 0x3       0x02      0x8       0x2067fff7
         or   $4, $7, $2         # $4 = (0x3 or 0x5) = 0x7   0x03      0xc       0x00e22025
         and  $5, $3, $4         # $5 = (0x12 and 0x7) = 0x4 0x04      0x10      0x00642824
         add  $5, $5, $4         # $5 = 0x4 + 0x7 = 0x11     0x05      0x14      0x00a42820
         beq  $5, $7, label2     # shouldn't 0xbe taken      0x06      0x18      0x10a7000a
         slt  $4, $3, $4         # $4 = (0x12 < 0x7) = 0x0   0x07      0x1c      0x0064202a
         beq  $4, $0, label1     # should 0xbe taken         0x08      0x20      0x10800001
         addi $5, $0, 0x0        # shouldn't happen          0x09      0x24      0x20050000
label1:  slt  $4, $7, $2         # $4 = (0x3 < 0x5) = 0x1    0x0A      0x28      0x00e2202a
         add  $7, $4, $5         # $7 = 0x1 + 0x11 = 0x12    0x0B      0x2c      0x00853820
         sub  $7, $7, $2         # $7 = 0x12 - 0x5 = 0x7     0x0C      0x30      0x00e23822
         sw   $7, 244($3)        # [256] = 0x7               0x0D      0x34      0xac6700f4
         lw   $2, 256($0)        # $2 = [256] = 0x7          0x0E      0x38      0x8c020100
         jal  label2             # should be taken           0x0F      0x3c      0x0c000011
         addi $2, $0, 0x1        # shouldn't happen          0x10      0x40      0x20020001
label2:  sw   $2, 260($0)        # write adr 260 = 0x7       0x11      0x44      0xac020104
         addi $10, $0, -0x1      # $10 = 0xFFFFFFFF          0x12      0x48      0x200affff
         add  $10, $10, $10      # $10 = 0xFFFFFFFE          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFFFC          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFFF8          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFFF0          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFFE0          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFFC0          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFF80          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFF00          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFE00          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFFC00          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFF800          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFF000          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFE000          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFFC000          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFF8000          0x16      0x58      0x014a5020
         add  $10, $10, $10      # $10 = 0xFFFF0000          0x16      0x58      0x014a5020
         addi $12, $10, 0x4      # $12 = 0xFFFF0004          0x18      0x50      0x214c0004
         addi $14, $10, 0xC      # $14 = 0xFFFF000C          0x19      0x60      0x214e000c
display: lw   $13, 0x0($12)      # $13 = status of SWs       0x20      0x54      0x8d8d0000
         sw   $13, 0x0($14)      # $13 to seg7               0x21      0x64      0xadcd0000
         j    display            # loop display              0x22      0x68      0x08000025

# $0  = 0x0  # $1  = 0x0  # $2  = 0x7  # $3  = 0xc
# $4  = 0x1  # $5  = 0xb  # $7  = 0x7  # $31 = 40
# $10 = 0xFFFF0000, #0x13 = status of SWs
# $12 = 0xFFFF0004, #0x14 = 0xFFFF000C
# [0x100] = 0x7  [0x104] = 0x7
