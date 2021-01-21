#############################################
# C program for sorting the student no.
#############################################
#   sortedstuno = stuno;
#   mask0 = 0x0f; 
#   for (int i= 0; i < 8; i++) {
#       a = sortedstuno & mask0;
#       a = a >> (4 * i);
#       mask1 = mask0 << 4;
#       bestj = i;
#       tmpMax = a; 
#     for (int j = i + 1; j < 8) {
#       b = sortedstuno & mask1;
#       b = b >> (4 * j);
#       if (tmpMax < b) {
#          tmpMax = b;
#          bestj = j;
#       }
#       mask1 = mask1 << 4;
#     }
#     if (a < tmpMax) {
#         mask1 = 0x0f;
#         bestj4 = bestj << 2;
#         mask1 = mask1 << bestj4
#         mask2 = mask0 | mask1;
#         mask2 = ~mask2;
#         sortedstuno = sortedstuno & mask2;
#         tmpMax = tmpMax << (4 * i);
#         sortedstuno = sortedstuno | tmpMax;
#         a = a << bestj4;
#         sortedstuno = sortedstuno | a;
#       }
#     mask0 = mask0 << 4;
#   }
#############################################
# the uasge of the registers
#############################################
# mem[0x100], student no.
# mem[0x104], sorted student no
# $1, partially sorted student number / the address of switch 
# $2, the outer loop variable i / the address of seg7
# $3, the inner loop variable j / the switch input 
# $4, mask0
# $5, mask1
# $6, mask2
# $7, a
# $8, b
# $9, 4 * i
# $10, 4 * j
# $11, N = 8
# $12, bestj
# $13, tmpMax
# $14, compare result
#############################################
# MIPS assembly language program for sorting the student no.
# The following instructions are used.
# add and nor or sll sllv srlv slt
# addi andi ori lui
# beq bne
# j jal jr
# lw sw
######################################################################################################################### instr.(H) ####### addr.(H)
      lui     $2, 0x5487          # high halfword the student no (last 8 digitals), use your own student no. instead!      # 0                0
      ori     $2, $2, 0x3530      # low halfword of the student no (last 8 digitals)                                       # 1                4
      sw      $2, 0x100($0)       # store the original stuno at data memory                                                # 2                8
      addi    $11, $0, 8          # the size of stuno, N = 8                                                               # 3                C
      lw      $1, 0x100($0)       # $1 = [0x100] = stuno                                                                   # 4                10
      add     $2, $0, $0          # the outer loop variable initilization, i = 0,                                          # 5                14
      addi    $4, $0, 0x0f        # mask0 = 0xf                                                                            # 6                18
loop1:
      and     $7, $1, $4          # a = sortedstuno & mask0, get the BCD to be processed                                   # 7                1C
      sll     $9, $2, 2           # (4 * i)                                                                                # 8                20
      srlv    $7, $7, $9          # a = a >> (4 * i), shift the BCD to the LSB 4 bits                                      # 9                24
      sll     $5, $4, 4           # mask1 = mask0 << 4                                                                     # A                28
      add     $12, $2, $0         # bestj = i, remmember the position of the largest BCD in this loop                      # B                2C
      add     $13, $7, $0         # tmpMax = a, remember the last BCD in this loop                                         # C                30
      addi    $3, $2, 1           # j = i + 1, the inner loop variable initilization, j = i + 1                            # D                34
loop2:
      beq     $3, $11, checkswap  #  to check if j == 8                                                                    # E                38
      and     $8, $1, $5          #  b = sortedstuno & mask1                                                               # F                3C
      sll     $10, $3, 2          #  (4 * j)                                                                               # 10               40
      srlv    $8, $8, $10         #  b = b >> (4 * j), shift the BCD to the LSB 4 bits                                     # 11               44
      slt     $14, $13, $8        #                                                                                        # 12               48
      beq     $14, $0, incrLoop2  # if (tmpMax >= b), increase j                                                           # 13               4C
      add     $13, $8, $0         #  tmpMax = b, remember the last BCD in this loop                                        # 14               50
      add     $12, $3, $0         #  bestj = j, remmember the position of the largest BCD in this loop                     # 15               54
incrLoop2:
      sll     $5, $5, 4           #  mask1 = mask1 << 4                                                                    # 16               58
      addi    $3, $3, 1           #  j = j + 1                                                                             # 17               5C
      j       loop2                                                                                                        # 18               60
checkswap:
      slt     $14, $2, $12        #  to check if the position of the largest BCD in the this loop has been changed         # 19               64
      beq     $14, $0, incrLoop1                                                                                           # 1A               68
      jal     swap                                                                                                         # 1B               6C
incrLoop1:
      sll     $4, $4, 4           #  mask0 = mask0 << 4                                                                    # 1C               70
      addi    $2, $2, 1           #  i = i + 1                                                                             # 1D               74
      bne     $2, $11, loop1      #  to check if i <> 8                                                                    # 1E               78

result:
      sw      $1, 0x104($0)       #  [0x104] = sortedstuno                                                                 # 1F               7C
      
      lui     $2, 0xffff          #  $2 = 0xffff0000                                                                       # 20               80
      j       result

swap:                             #  change the nibble at i with the nibble at bestj
      addi    $5, $0, 0x0f                                                                                                 # 2B               AC
      sll     $10, $12, 2         #  4 * bestj                                                                             # 2C               B0
      sllv    $5, $5, $10         #  mask1 = mask (4 * bestj)                                                              # 2D               B4
      or      $6, $4, $5          #  mask2 = mask0 | mask1                                                                 # 2E               B8
      nor     $6, $6, $0          #  mask2 = ~mask2                                                                        # 2F               BC
      and     $1, $1, $6          #  sortedstuno = sortedstuno & mask2                                                     # 30               C0
      sllv    $8, $13,$9          #  tmpmax = tmpmax << (4*i)                                                              # 31               C4
      or      $1, $1, $8          #  sortedstuno = sortedstuno | tmpmax                                                    # 32               C8
      sllv    $7, $7, $10         #  a = a << (4 * bestj)                                                                  # 33               CC
      or      $1, $1, $7          #  sortedstuno = sortedstuno | a                                                         # 34               D0
      jr      $31                                                                                                          # 35               D4