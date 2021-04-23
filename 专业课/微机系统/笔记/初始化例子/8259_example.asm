; 利用 PC/AT 机器中的 8259A 的 IRQ9 中断写出采用中断传送数据的程序框架

data segment
    ; ...
data ends

stack segment para stack'stack'
    db 256 dup(?)
stack ends

code segment
    assume cs:code, ds:data, ss:stack
start proc far
    ; FIXME
    ; 保存 PSP 首地址, 以便于返回 DOS
    push ds
    xor ax, ax
    push ax

    mov ax, data
    mov ds, ax

    ; 初始化中断向量表中的 IRQ9
    cli
    mov ax, 0
    mov es, ax
    ; IRQ9 的中断类型码为 71h
    mov di, 1c4h
    
    ; 中断服务程序地址写入中断向量表
    mov ax, offset intp
    ; DF = 0, 向高地址增加
    cld
    stosw
    mov ax, seg intp
    stosw

    ; 读取主 8259 的 IMM
    in al, 21h
    ; 开放 IRQ2, 连接从 8259
    and al, 11111011b
    out 21h, al
    ; 读取从 8259 的 IMM
    in al, 0a1h
    ; 开放 IRQ9 中断
    and al, 11111101b
    out 0a1h, al
    ; ...
    sti
    ; 返回 DOS
    ret
start endp

; 中断服务程序
intp proc far
    sti
    ; 保存中断前现场
    ; FIXME
    ; 为什么这里不用 pushad
    
    ; 中断主程序
    ; ...

    ; 从 8259 发送 EOI 命令
    mov al, 20h
    out 0a0h, al
    ; 写 OCW3, 要求读 ISR
    mov al, 00001011b
    out 0a0h, al
    ; 读入从 ISR
    in al, 0a0h
    ; 从 8259 还有中断要处理
    jnz exit1
    ; 从 8259 没有中断要处理, 向主 8259 发送 EOI
    mov al, 20h
    out 20h, al
exit1:
    ; 恢复前现场
    ; 为什么不用 popad

    ; 中断返回
    iret
intp endp
code ends
    end start