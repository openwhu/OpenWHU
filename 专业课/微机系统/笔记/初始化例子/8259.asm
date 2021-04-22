; PC/XT 系统
; 写 ICW1
; 13h = 00010011b
; 单片使用
mov al, 13h
out 20h, al
; 写 ICW2
; 08h = 00001000b
; 中断类型码设置为 08h-0fh
mov al, 08h
out 21h, al
; 写 ICW4
; 09h = 00001001b
; FIXME
; 一般全嵌套，缓冲方式，从片？
mov al, 09h
out 21h, al
; 写 OCW1
; 屏蔽所有中断请求
mov al, 0ffh
out 21h ,al

; ==========================================================
; PC/AT 系统
; 写主、从 ICW1
; 11h = 00010001b
; 级联方式
mov al, 11h
out al, 20h
out al, 0a0h
; 写主、从 ICW2
; 主中断类型码设置为 08h=0fh
mov al, 08h
out 21h, al
; 从中断类型码设置为 70h-77h
mov al, 70h
out 0a1h, al
; 写主、从 ICW3
; 对应主 8259 的 IR2
mov al, 04h
out 21h, al
mov al, 02h
out 0a1h, al
; 写主、从 ICW4
; 11h = 00010001b
; 特殊全嵌套，非缓冲
mov al, 11h
out 21h, al
; 一般全嵌套，缓冲
mov al, 01h
out 0a1h, al