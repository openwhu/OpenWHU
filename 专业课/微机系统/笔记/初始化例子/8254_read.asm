; 8254 的端口地址为 40H-43H, 计数器2工作在方式 2
; 按二进制计数, 计数值为 1110H
; 现要在计数过程中读取该计数器的计数值, 请对其进行初始化变成

; 初始化 CNT2
mov al, 10110100b
out 43h, al
; 送至计数值
mov ax, 1110h
out 42h, al
mov al, ah
out 42h, al

; 计时一会再读出
mov bh, 20h
w:
dec bh
cmp bh, 0
jnz w

; 锁存
mov al, 10000000b
out 43h, al
; 读出计数值
in al, 42h
mov ah, al
in al, 42h