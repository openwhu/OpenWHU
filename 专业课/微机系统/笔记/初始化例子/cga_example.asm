; 利用 int 10h 设置显示模式和
; CGA 直接程序设计编程模式 6 的 4 种写模式下的写像素程序
; 其中 CX = 列坐标、DX = 行坐标、AL = 颜色值


; FIXME
drmode equ 4c4h
; 显存段地址
dspmemseg equ 0b800h

setpix proc
    push bp
    push ax
    push bx
    push dx
    push cx

    xor ah, ah
    ; bp = al, 保存颜色值
    mov bp, ax
    ; 取显存段地址
    mov ax, dspmemseg
    ; 检查是否为奇数行
    test dl, 01h
    jz evline
    ; FIXME
    ; 奇数行加 200
    add ax, 200
evline:
    ; es = b800 + 200 * (Y % 2)
    mov es, ax
    ; y / 2
    shr dx, 1

    ; FIXME
    mov cl, 4
    shl ax, cl
    mov bx, ax
    shl ax, 1
    shl ax, 1
    add ax, bx
    pop bx
    push bx
    push bx

    ; FIXME
    mov cl, 3
    shr bx, cl
    ; bx = 80 * (y / 2) + x / 8
    add bx, ax
    ; FIXME

    pop cx
    and cl, 07h
    mov al, 80h
    ror al, cl
    ; dl 中为像素值的地址
    mov dl, al

    mov dh, es:[bx]
    and dh, dl
    or bp, bp
    jnz spnt0
    not dl
spnt0:
    mov ah, ds:[drmode0]
    cmp ah, 1
    jnz spnt1
    or dh, dl
    jmp spnt4
spnt1:
    cmp ah, 2
    jnz spnt2
    and dh, dl
    jmp spnt4
spnt2:
    cmp ah, 3
    jnz spnt3
    xor dh, dl
    jmp spnt4
spnt3:
    mov dh, dl
spnt4:
    and dh, dl
    jz spnt5
    or es:[bx], dh
    jmp spdone
spnt5:
    not al
    and es:[bx], al
spdone:
    pop cx
    pop dx
    pop bx
    pop ax
    pop bp
setpix endp
