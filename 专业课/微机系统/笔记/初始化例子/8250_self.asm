; 在 PC/XT 上做一个自发自收的异步串行通信实验
; 要求通信波特率为 4800baud
; 每帧由 1 位起始位, 6 位数据位, 1 位偶校验位, 2 个停止位组成
; 实验开始需要先检查串口 1 异步适配板的存在性, 并填入板的基地址到基址区


; 通过 IIR 高 5 位检查 8250 是否存在
mov dx, 3fah
in al, dx
; 高五位是否为 0
test al, 0f8h
jnz error

; 8250 一共 8 个端口地址, 因此地址后 3 位清零即为基地址
and dx, 0fff8h
mov ax, 0040h
mov es, ax
; 填入基地址
mov es:rs-232-base, dx

; DLAB = 1
mov al, 80h
mov dx, 3fbh
out dx, al
; 写除数寄存器
; 4800baud -> 0018h
mov dx, 3f8h
mov al, 18h
out dx, al
mov dx, 3f9h
mov al, 00h
out dx, al

; 写 LCR
mov dx, 3fbh
mov al, 00011101b
out dx, al
; 写 MCR
mov dx, 3fch
; 自发自收 => D4 = 1
mov al, 00010011b
out dx, al
; 写 IER
mov dx, 3f9h
; 屏蔽所有中断
mov al, 00h
out dx, al