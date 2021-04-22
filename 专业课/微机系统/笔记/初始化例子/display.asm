; 在屏幕的 10 行 10 列处写闪烁的蓝底黄字 "CHARS COLOUR"
; 在屏幕的 12 行 10 列处开始写闪烁的红底蓝字 "CHARS" 和红底绿蓝相间的字符 "COLOUR"


data segment
    ; 要显示的字符串
    string db 'CHARS COLOUR'
    strlen equ $ - string
    string1 db 'CHARS'
    ; c2h = 11000010b
    ; 闪烁, 背景颜色：红, 字符颜色: 绿
    string2 db 'C', 0c2h, 'O', 0c1h, 'L', 0c2h, 'O', 0c1h, 'U', 0c2h, 'R', 0c1h
    strlen2 equ $ - string2
data ends

code segment
    assume cs:code, ds:data
    start:
        mov ax, data
        mov ds, ax
        mov es, ax

        ; 设置 80 * 25 彩色文本模式
        mov ah, 0
        mov al, 3
        int 10h

        ; AL = 0, 清屏
        mov ax, 0600h
        mov bh, 07h
        mov cx, 0
        mov dx, 184fh
        int 10h

        ; AH = 13h, 写字符串
        lea bp, string
        mov cx, strlen
        mov dx, 0a0ah
        mov bh, 0
        ; 9eh = 10011110b
        ; 闪烁的蓝底黄字
        mov bl, 9eh
        mov ah, 13h
        int 10h

        ; 无回显的直接控制台输入
        mov ah, 07h
        int 21h
        
        ; 以方式一写字符串, 光标随之移动
        lea bp, string1
        mov cx, string2 - string1
        mov dx, 0c0ah
        mov bh, 0
        mov ah, 13h
        int 10h

        ; 读光标位置
        ; DH = 行号, DL = 页号, CH = 当前光标终止线, CL = 当前光标起始线
        mov ah, 3
        int 10h
        ; TODO
        ; 行号加 2？
        add dh, 2

        ; AL = 3 方式显示字符串, 字符, 属性, 字符……
        lea bp, string2
        ; 串长需要除以 2
        mov cx, strlen2 / 2
        mov al, 3
        mov ah, 13h
        int 10h

        ; 键入任意字符退出程序
        mov ah, 07h
        int 21h

        mov ax, 4c00h
        int 21h
code ends
    end start