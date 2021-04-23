; 利用 8237 的通道 2, 由磁盘输入 32 KB 的一个数据块
; 传送至 68000H 开始的区域
; 采用地址增变化、成组方式、传送不完自动预置、磁盘DREQ和DACK高电平有效

; 注意: 由于地址超过 16 位, 需要用到页面寄存器

; DMA 首地址
dma equ 0000h
; 禁止 8237 工作
mov al, 04h
out dma+08h, al
; 主清除命令
out dma+0dh, al

; 写通道二
; 写地址寄存器
mov dx, dma+04h
mov al, 00h
out dx, al
mov al, 80h
out dx, al
; 写入页面寄存器
; P231(CN2) 对应的页面寄存器是 81h
; 写入高 8/4 位
mov al, 06h
out 81h, al
; 写入字计数寄存器
mov dx, dma+05h
; 32 KB = 8000h
; FIXME
; 这里是否要比传输的字节数少 1
mov al, ffh
out dx, al
mov al, 7fh
out dx, al

; 写入方式寄存器
mov dx, dma+0bh
mov al, 10011010b
out dx, al

; 写屏蔽寄存器单个位
mov dx, dma+0ah
mov al, 00000010b
out dx, al

; 写命令控制字
mov dx, dma+08h
mov al, 10000000b
out dx, al