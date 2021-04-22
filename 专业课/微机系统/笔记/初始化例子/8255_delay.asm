; PC AT 系统中, 8255 的 PB4 每 15.08us 触发依次

; 入口参数 CX
; 延时时间为 CX * 15.08us
waitf proc near
    push ax
waitf1:
    ; 读取 PB4
    in al, 61h
    and al, 10h
    ; 比较 al 和 ah, ah 暂存 al 上一次的状态
    cmp al, ah
    je waitf1
    mov ah, al
    loop waitf1

    pop ax
    ret

waitf endp