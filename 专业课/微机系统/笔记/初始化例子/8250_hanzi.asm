; 在 IBM PC/XT 系统中, 
; 要用 Ins 8250 以 300 baud 的速率发送汉字编码信息
; 请编写相应的初始化段


; 1 个汉字 2B
; 因此采用 8 位数据位, 1 位奇校验位, 1 位停止位和 1 位起始位
; 假设采用 COM2, 地址为 2F8H-2FFH

; DLAB = 1
mov dx, 2fbh
mov al, 80h
out dx, al
; 写入除数锁存器
; 300baud -> 写入 0180h
mov dx, 2f8
mov al, 80h
out dx, al
inc dx
mov al, 01h
out dx, al
; 写入线路状态寄存器
mov dx, 2fbh
mov al, 00001011b
out dx, al