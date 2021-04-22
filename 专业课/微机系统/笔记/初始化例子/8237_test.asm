; 对 8237 的 CH0-CH3 中的所有寄存器做全零和全一写入/读出检测

; 禁止 DMA 工作 + 主清除命令
mov al, 04h
out DMA+08h, al
out DMA+0dh, al

; 检测思路如下:
;   由于 CH0-CH3 顺序排列于 DMA 端口的起始位置，故采用循环的方式进行检测
mov al, 0ffh
TEST_ALL:
; 设置 BX = FFFFh, 用作检测的基准值
mov bh, al
mov bl, al
; 需要检查的寄存器个数
mov cx, 8
; DMA 的基地址
mov dx, DMA
TEST_ONE:
; 先低后高写入 DMA
out dx, al
out dx, al
; 先低后高读出
; 这里由于高位和低位相等, 因此不需要 xchg 进行交换
in al, dx
mov ah, al
in al, dx
; 判断是否正确
cmp ax, bx
; 如果正确检查下一个寄存器
je TEST_NEXT
; 使 cpu 暂停
HLT

TEST_NEXT:
; 地址+1, 检查下一个寄存器
inc dx
loop TEST_ONE
; 测试全零
inc al
jz TEST_ALL