; 初始化程序
; 线路控制寄存器 3FBh
mov dx, 3fbh
; 80h = 10000000b
; 首位为 1 表示访问除数锁存器
mov al, 80h
out dx, al
; 高位除数锁存器 3F9h
mov dx, 3f9h
; 置 0
mov al, 0
out dx, al
; 低位除数锁存器 3F8h
mov dx, 3f8h
; 置 30，波特率为 1843200 / 48 / 16 = 2400
mov al, 30h
out dx, al
; 线路控制寄存器 3FBh
mov dx, 3fbh
; 1Ah = 00011010b
; 无附加位，偶校验，停止位 1 位，数据位长 7
mov al, 1ah
out dx, al
; Modem 控制寄存 3FCh
mov dx, 3fch
; 03h = 00000011b
; 设置 RTS、DTR 有效
; RTS 是请求联络信号, 如果对方的设备接收到信号后允许发送, 回答一个低电平信号 CTS
; DTR 联络信号, 表示数据终端设备就绪
mov al, 03h
out dx, al
; 中断允许寄存器 3F9h
mov dx, 3f9h
; 00h = 00000000b
; 屏蔽所有中断，用查询方式通信
mov al, 0
out dx, al

; ============================================================================

; 通信工作程序
; 线路状态寄存器 3FDh
KEEP-TRY:
mov dx, 3fdh
in al, dx
; 1eh = 00011110b
; test 执行逻辑与操作
; 此处作用为检查错误，包括：中止、帧格式错、奇偶错、超越错
test al, 1eh
; 转出错处理
jnz error-routine
; 检查LSR D0 位
; 检查接收数据就绪位
test al, 1
; 转接收程序
jnz receive
; 20h = 00100000b
; 检查 THR 是否为空
test al, 20h
; THR 没有结束，发送工作不为空
jz KEEP-TRY
; 注意 THR/RBR 与 DLL 的端口位置一样，均为 3F8h，需要通过 LCR 的 DLAB 位来区分
mov dx, 3f8h
; 向 THR 写入字符
mov al, cl
out dx, al
; 跳转到工作程序
jmp KEEP-TRY

RECEIVE:
; 接受数据缓冲器RBR的端口也是 3F8h
mov dx, 3f8h
in al, dx