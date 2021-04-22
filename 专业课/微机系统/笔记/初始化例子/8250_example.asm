; 在 IBM PC 机上按照查询方式编写发送程序, 中断方式编写接收程序
; 该程序能连续将符号'*'从串口COM1发送出去并在CRT上显示
; 同时能把从串口COM1上收到的字符显示在CRT上
; 当线路出错时在CRT上显示'#'

STACK SEGMENT
    DB 50 DUP(0)
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE, SS:STACK

START:
    ; 关中断
    CLI
    ; 设置中断向量表
    MOV AX, 0
    MOV ES, AX
    ; 设置 12 号中断服务程序的地址
    MOV DI, 4 * 12
    MOV AX, OFFSET RINT
    ; DF 清零
    ; DF = 0, 串传输指令后 si/di 递增
    ; DF = 1, 串传输指令后 si/di 递减
    CLD
    ; 将 AX 中的内容，即 RINT 的偏移地址送入 ES:DI, DI = DI + 2
    STOSW
    MOV AX, CS
    ; 将 AX 中的内容，即 RINT 的段地址送入 ES:DI
    STOSW
    ; 写 8259A 的中断屏蔽字 OCW1，使其开放 COM1 的中断请求 IRQ4
    IN AL, 21H
    AND AL, 0EFH
    OUT 21H, AL
    ; 线路控制寄存器 LCR
    MOV DX, 3FBH
    MOV AL, 80H
    OUT DX, AL
    ; 除数锁存器低字节
    MOV DX, 3F8H
    MOV AL, 0CH
    OUT DX, AL
    ; 除数锁存器高字节
    ; 波特率为 1.8432 MHz / (12 * 16) = 9600
    MOV DX, 3F9H
    MOV AL, 0
    OUT DX, AL
    ; 线路控制寄存器 LCR
    MOV DX, 3FBH
    ; 0bh = 00001011b
    ; 奇校验，1 位停止位，8 位数据位
    MOV AL, 0BH
    OUT DX, AL
    ; Modem 控制器 MCR
    MOV DX, 3FCH
    ; 0bh = 00001011b
    ; 使 DTR、RTS、OUT2 有效
    ; OUT2 连接 8259A
    MOV AL, 0BH
    OUT DX, AL
    ; 设置中断允许寄存器
    ; 只允许接收中断
    MOV DX, 3F9H
    MOV AL, 01H
    OUT DX, AL
    ; 开中断
    STI

; 发送数据
; 发送数据采用查询 LSR 中 THR 的方式
TR:
    ; 线路状态寄存器 LSR
    MOV DX, 3FDH
    IN AL, DX
    ; 判断 THR 是否等于 0
    ; 如果等于 0 表明字符送至 TSR 的工作还没有完成
    TEST AL, 20H
    JZ TR
    ; 发送 '*'
    MOV AL, '*'
    ; 发送保持寄存器 THR
    MOV DX, 3F8H
    OUT DX, AL
    ; 显示输出，DL 放置输出字符
    ; mov al, '1'
    MOV AH, 02
    MOV DL, AL
    INT 21H
    JMP TR

; 中断服务程序
RINT PROC
    ; 开中断
    STI
    PUSH DX
    PUSH AX
    ; 线路状态寄存器 LSR
    MOV DX, 3FDH
    IN AL, DX
    ; 判断接受是否出错
    ; 1eh = 00011110b
    ; 检查: 中止、帧格式错、奇偶校验错、超越错
    TEST AL, 1EH
    JNZ RERR
    ; 接受 RBP 中的字符并显示
    MOV DX, 3F8H
    IN AL, DX
    ; 在屏幕上显示接受的字符
    ; mov al, '?'
    MOV DL, AL
    MOV AH, 02
    INT 21H

REND:
    ; 对 8259A 发 EOI 命令
    ; 20h = 00100000b
    MOV AL, 20H
    ; OCW2
    OUT 20H, AL
    POP AX
    POP DX
    IRET

; 接受出错处理程序
; 这里只是在屏幕上显示 '#'
RERR:
    ; FIXME
    ; 下面两行读取 RBR 的作用可能是为了避免超越错?
    MOV DX, 3F8H
    IN AL, DX
    ; 显示接受错标记
    MOV DL, '#'
    MOV AH, 2
    INT 21H
    JMP REND

RINT ENDP
CODE ENDS

END START