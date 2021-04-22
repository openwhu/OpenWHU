; 下面的程序将彩色显示器设置为 80 * 25 彩色字符方式
; 边框为绿色, 选择第一色组, 背景亮度为 0

data segment
    ; 显示器参数表
    ; 第一行为 40 * 25 字符模式参数
    ; 第二行为 80 * 25 字符模式参数
    ; 第三行为图形模式参数
    ; 第四行为单色显示器参数
    ; TODO
    ; 本来都是 byte 类型, 没有必要用 label 吧
    ; 此参数对应 P284
    VIDEO_PARAMS label byte
        db 38h, 28h, 2dh, 0ah, 1fh, 6, 19h, 1ch, 2, 7, 6, 7, 0, 0, 0, 0
        db 71h, 50h, 5ah, 0ah, 1fh, 6, 19h, 1ch, 2, 7, 6, 7, 0, 0, 0, 0
        db 38h, 28h, 2dh, 0ah, 7fh, 6, 64h, 70h, 2, 1, 6, 7, 0, 0, 0, 0
        db 61h, 50h, 52h, 0fh, 19h, 6, 19h, 1ch, 2, 13, 11, 12, 0, 0, 0, 0
data ends

; https://blog.51cto.com/bbchylml1988/307446
; 段的起始边界值为 10h 的倍数
; 将多个同名(此例中为'stack')堆栈段连接在一起, sp 指向第一个堆栈段的开始
stack segment para stack'stack'
    db 256 dup(?)
stack ends

code segment
    ; 跨段
    start proc far
        assume cs:code, ss:stack, ds:data
        push ds
        mov ax, data
        mov ds, ax

        mov ax, 0
        mov es, ax
        mov di, 4 * 1dh
        cld
        ; 将 VIDEO_PARAM 的地址存到 es:di 中
        mov ax, offset VIDEO_PARAMS
        ; 将 ax 存储到 es:di 中, di 自增
        stosw
        mov ax, seg VIDEO_PARAMS
        stosw

        mov al, 0
        ; 模式控制寄存器 3d8h
        mov dx, 3d8h
        out dx, al

        ; FIXME
        ; 在哪里有这个寄存器？
        ; 索引寄存器 3d4 h
        mov dx, 3d4h
        mov ah, 0
        mov cx, 16
        mov si, offset VIDEO_PARAMS
        ; 第二行 80 * 25 模式参数
        add si, 16
    M10:
        ; 此步骤可参照 P284 来看
        mov al, ah
        ; 参数编号送入索引寄存器
        out dx, al
        ; 编号加 1
        inc ah
        ; 把 ds:si 中的值装入 al
        lodsb
        ; 送参数到 CRTC 6845
        out dx, al
        dec dx
        loop M10
        
        ; 设置模式为 80 * 25 彩色字符
        mov al, 29h
        mov dx, 3d8h
        out dx, al

        mov al, 00000010b
        ; 彩色选择寄存器
        mov dx, 3d9h
        ; 不闪烁, 背景色 0, 前景色 0010b
        out dx, al

        ret
    start endp
code ends
    end start