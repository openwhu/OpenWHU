; 该程序为 8237 实现 M->M 传送的程序
; 将 source 开始的 1000 个字节传送到 dst 开始的存储块中去
; 假定 DMAC 的端口地址为 10h~1fh

; 禁止 8237 工作
mov al, 04h
out 18h, al
; 主清除命令
out 1dh, al

; 写命令控制字
; 允许存储器到存储器的传送, DACK 高电平有效
mov al, 81h
out 18h, al

; 设置通道 CH0
; 写地址寄存器
; 先低后高
mov ax, source
out 10h, al
mov al, ah
out 10h, al
; 写字计数寄存器
; TODO
; 这里是 1000 还是 999 应该不重要
mov ax, 1000
out 11h, al
mov al, ah
out 11h, al
; 写工作方式寄存器
; 读, 非自动预置, 存储器地址+1, 成组传送
mov al, 10001000b
out 1bh, al

; 设置通道 CNT1
; 写地址寄存器
mov ax, dst
out 12h, al
mov al, ah
out 12h, al
; 写字计数寄存器
mov ax, 1000
out 13h, al
mov al, ah
out 13h, al
; 写工作方式寄存器
; 写, 非自动预置, 存储器地址+1, 成组传送
mov al, 10000101b
out 1bh, al

; 写屏蔽寄存器所有位
; 开放所有屏蔽
mov al, 00000000b
out 1fh, al

; 写请求寄存器
mov al, 00000100b
out 19h, al