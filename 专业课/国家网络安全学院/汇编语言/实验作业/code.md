###### 第一题

```assembly
stack segment stack
	dw 200 dup(0)
stack ends
data segment
	bin dw 6f80h,98b0h,-74abh,-0f88ah
	buf db 13 dup(0),13,10,'$'
	ten dw 10
data ends
assume cs:code,ds:data,ss:stack 
code segment
	
start:	mov ax,data
	 	mov ds,ax
	 	lea bx,bin
L:		
		mov ax,[bx]		;
		lea di,buf
		mov cx,0
		or ax,ax    ;符号位处理
		jns L1
		mov byte ptr[di],'-'
		inc di
		neg ax
L1:		mov dx,0
		div ten
		push dx
		inc cx
		cmp ax,0
		jnz L1
L2:		pop ax
		add al,30h
		mov [di],al
		inc di
		loop L2	
		lea dx,buf
		mov ah,9
		int 21h
L3:		dec di
		mov byte ptr [di],0
		cmp dx,di
		jne L3	
		add bx,2
		cmp bx,8
		jne L	
		mov ah,4ch
		int 21h	
code ends
end start
```

###### 第二题

```assembly
assume cs:code,ds:data
data segment
	input1 db "please input:",'$'
	num	db	" decimalism!",13,10,'$'
	large	db	" capital letter!",13,10,'$'	
	sma	db	" small letter!",13,10,'$'
data ends
code segment
start:	mov ax,data
		mov ds,ax
L:		lea dx,input1
		mov ah,9
		int 21h
		mov ah,1
		int	21h
		cmp al,'0'
		jb	exit
		cmp al,'9'
		JA L1
		lea dx,num
		mov ah,9
		int 21h
		jmp	L
L1:		cmp al,'A'
		jb exit
		cmp	al,'Z'
		JA	L2
		lea dx,large
		mov ah,9
		int 21h
		jmp L
L2:		cmp al,'a'
		jb exit
		cmp	al,'z'
		ja	l2
		lea dx,sma
		mov ah,9
		int 21h
		jmp L
exit:	mov ah,4ch
		int 21h
code ends
end start
```

###### 第三题

```assembly
inout macro x,y
	lea dx,x
	mov ah,y
	int 21h
endm
assume cs:code,ds:data
data segment
	
	p1	db	"please input string1:",'$'
	p2	db	"please input string2:",'$'
	c0	db	13,10,'$'
	c1	db	"NO MATCH",13,10,'$'
	c2	db	"MATCH",13,10,'$'
	str1 db	20,0,20 dup(0)
	str2 db 20,0,20 dup(0)
data ends
code segment
start:	
	mov ax,data
	mov ds,ax
	mov es,ax
	inout p1,9
	inout str1,10
	inout c0,9
	inout p2,9
	inout str2,10
	inout c0,9
	
	mov	cl,str1+1
	cmp cl,str2+1
	jne no
	mov ch,0
	lea di,str1+2
	lea si,str2+2
	repz cmpsb
	jne no
	inout c2,9
	jmp exit
no:	inout c1,9
exit:mov ah,4ch
	int 21h
code ends
end start
```

###### 第四题

```assembly
inout macro x,y
	lea dx,x
	mov ah,y
	int 21h
endm
assume ds:data,cs:code,ss:stack,es:data
stack segment
	dw  200 dup(0)
stack ends

data segment
	ary dw 100h,250ah,0ff88h,8660h,40h,9500h,6000h,1200h,8008h,0a200h,2800h,0ff60h,0f50h
	N	dw ($-ary)/2
	ave dw ?
	c0 	db 	13,10,'$'
	c1	db 	'All number:$' 
	c2	db	'the AVERGE:$'
	c3	db	'the number that bigger than the average:$'
	buf db 13 dup(0)
	count dw ?
	ten dw 10
data ends
code segment
start:	mov ax,data
		mov ds,ax
		mov es,ax
		inout c1,9
		inout c0,9
		mov ax,0
		mov dx,0
		mov cx,N
		lea bx,ary
L:		call two_ch_ten 
		add ax,[bx]
		adc dx,0
		push cx
		mov cx,0
		add cx,[bx]
		pop cx
		jns P
		add dx,0ffffh			
P:		add bx,2
loop L
	push ax
	push dx
	inout c0,9
	inout c2,9
	inout c0,9
	pop dx
	pop ax
L1:	or dx,dx
	pushf
	jns L2	
	xor dx,0ffffh
	xor ax,0ffffh
	add ax,1
	adc dx,0	
L2:	mov cx,N
	div cx
	popf
	jns L3
	neg ax	
L3: mov ave,ax
	lea bx,ave
	call two_ch_ten
	push ax
	push dx
	inout c0,9
	inout c3,9
	inout c0,9
	pop dx
	pop ax
	mov dx,0
	mov ax,ave
	lea bx,ary
L4: cmp [bx],ax
	jle	PP
	inc dx
PP:	add bx,2
	loop L4
	lea bx,count
	mov [bx],dx
	call two_ch_ten
	mov ah,4ch
	int 21h
;子程序名：two_ch_ten
;功能描述：将二进制数转换为十进制输出
;入口参数：ds:[bx]
;出口参数：输出比ave大的数
two_ch_ten	proc
	push ax
	push bx
	push cx
	push di
	push dx
	mov ax,[bx]
	lea di,buf
	mov cx,0
	or ax,ax
    jns t1
    mov byte ptr [di],'-'
    inc di
    neg ax
t1: mov dx,0
	div ten
	push dx
	inc cx
	cmp ax,0
	jne t1
t2:	pop ax
	add	al,30h
	mov [di],al
	inc di
	loop t2
	mov byte ptr [di],','
	mov byte ptr [di+1],'$'
	add di,2
	inout buf,9
t3:	dec di
	mov byte ptr[di],0
	cmp dx,di
	jne t3
	pop dx
	pop di
	pop cx
	pop bx
	pop ax
	ret
two_ch_ten	endp
code ends
end start
```

###### 第五题

```assembly
inout macro x,y
	lea dx,x
	mov ah,y
	int 21h
endm
assume ds:data,cs:code
data segment
	A 	dw  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
	B	dw  1,3,5,7,9,11,13,15,17,19,21,22,23,24,25,26,27,28,29,30
	D	dw	100 dup(' ')
	c1	db	'numbers in A:$'
	c2	db	'numbers in B:$'
	c3	db	'numbers in C:$'
	c0 	db	13,10,'$'
	buf db 13 dup(0)
	ten dw 10
data ends
code segment
start:	mov ax,data
		mov ds,ax
		mov es,ax
		lea si,D
		lea bx,A
		mov cx,15
L:		mov ax,[bx]
		lea di,B
		push cx
		mov cx,20
L1:		mov dx,[di]
 		cmp dx,ax
 		jne L2
 		mov [si],ax
 		add si,2
L2:		add di,2
		loop L1
		pop cx
		add bx,2
		loop L
L3:		inout c1,9
		lea bx,A
		mov cx,15
LA:		call two_ch_ten
		add bx,2
loop LA
		inout c0,9
		inout c2,9
		lea bx,B
		mov cx,15
LB:		call two_ch_ten
		add bx,2
loop LB
		inout c0,9
		inout c3,9
		lea bx,D
LC:		call two_ch_ten
		add bx,2
		sub si,2
		cmp si,offset D
		jne LC
		inout c0,9
		mov ah,4ch
		int 21h
;子程序名：two_ch_ten
;功能描述：将二进制数转换为十进制输出
;入口参数：ds:[bx]
;出口参数：输出比ave大的数
two_ch_ten	proc
	push ax
	push bx
	push cx
	push di
	push dx
	mov ax,[bx]
	lea di,buf
	mov cx,0
	or ax,ax
    jns t1
    mov byte ptr [di],'-'
    inc di
    neg ax
t1: mov dx,0
	div ten
	push dx
	inc cx
	cmp ax,0
	jne t1
t2:	pop ax
	add	al,30h
	mov [di],al
	inc di
	loop t2
	mov byte ptr [di],','
	mov byte ptr [di+1],'$'
	add di,2
	inout buf,9
t3:	dec di
	mov byte ptr[di],0
	cmp dx,di
	jne t3
	pop dx
	pop di
	pop cx
	pop bx
	pop ax
	ret
two_ch_ten	endp
code ends
end start
```

###### 第六题

```assembly
.386
inout macro x,y
	push ax
	push dx
	lea dx,x
	mov ah,y
	int 21h
	pop dx
	pop ax
endm
print macro x
	push ax
	push dx
	mov dl,x
	mov ah,2
	int 21h
	pop dx
	pop ax
endm
assume ds:data,cs:code,es:data
data segment use16
	str1 dd	-0A62B89F0H, -739066ABH,11112222H,88889999H
	c0 	db	13,10,'$'
	c1 	db 	'the unsignal decimalism number is:$'
	c2 	db 	'the signal decimalism number is:$'
	c3 	db 	'the unsignal decimalism number is:$'
	c4 	db 	'the signal decimalism number is:$'
	buf db 13 dup(0)
	base dd 10
	flag db 0
	H	db	'H'
	D	db	'D'
data ends
code segment use16	
start:	mov ax,data
		mov ds,ax
		mov es,ax
		lea bx,str1
		mov cx,4
PP:		mov base,10
		mov flag,0
		inout c1,9
		call two_ch_base
		print D
		inout c0,9
		inout c2,9
		mov flag,1
		call two_ch_base
		print D
		inout c0,9
		
		inout c3,9
		mov base,16
		mov flag,0
		call two_ch_base
		print H
		inout c0,9
		inout c4,9
		mov flag,1
		call two_ch_base
		print H
		inout c0,9
		inout c0,9
		add bx,4
		loop PP1
		jmp	exit
PP1:	jmp PP
exit:	mov ah,4ch
		int 21h
;子程序名：two_ch_ten
;功能描述：将二进制数转换为十进制输出
;入口参数：ds:[bx]
;出口参数：输出比ave大的数
two_ch_base	proc near
	push ax
	push cx
	push di
	push dx
	push si
	mov eax,[bx]
	mov ch,flag
	cmp ch,0
	mov si,0
	mov cx,0
	je t1
	or eax,eax
    jns t1
    mov buf[di],'-'
    inc di
    neg eax
t1: mov edx,0
	div base
	push dx
	inc cx
	cmp eax,0
	jne t1
t2:	pop ax
	add	al,30h
	cmp al,39h
	jna tt 
	add al,'A'-'0'-10
tt:	mov buf[di],al
	inc di
	loop t2

	mov buf[di],'$'
	inc di
	inout buf,9
t3:	mov buf[di],0
	dec di
	cmp di,0
	jne t3
	pop si
	pop dx
	pop di
	pop cx
	pop ax
	ret
two_ch_base	endp
code ends
end start
```

###### 第七题

```assembly
inout macro x,y
	lea dx,x
	mov ah,y
	int 21h
endm
assume ds:data,cs:code
data segment 
	c0	db 	13,10,'$'
	c1	db	'please input number(0-999):$'
	er	db 	'It is not a number!',13,10,'$'
	c2	db	'The statistics reslut is:',13,10,'$'
	m0	db	'0<=~<=99:   $'
	m1	db	'100<=~<=199:$'
	buf dw 	102 dup (0)
	str1 db  10,0,10 dup(0)
	ss1	dw	12 dup(0) 		
	sum dw 10 dup(0)
	ten dw 10
	base dw 10
	div1 dw 100
	count dw 0
data ends
code segment
start:	mov ax,data
		mov ds,ax
		mov es,ax

		call scanf
		call cal
		call output
		mov ah,4ch
		int 21h
;子程序名:scanf
;功能描述：用于将字符存入buf缓存区中
scanf proc
		lea bx,buf
s1:		inout c1,9
		inout str1,10
		inout c0,9 
		mov al,str1+1
		mov ah,0
		lea si,str1+2
		add si,ax
		mov ax,0
		lea di,str1+2
s2:		mov cl,[di]
		cmp cl,30h
		js sexit
		cmp cl,39h
		ja sexit
		sub cl,30h
		mul base
		mov ch,0
		add ax,cx
		inc di
		cmp si,di
		jnz s2
		mov [bx],ax
		inc count
		add bx,2
		jmp s1
sexit:	inout er,9
		ret
scanf endp
;子程序名:cal
;功能描述:计算各个区间所含数个数
cal proc
	mov cx,count
	lea bx,buf
cc:	mov ax,[bx]
	mov dx,0
	div div1
	mov si,ax
	add si,si
	inc sum[si]
	add bx,2
	loop cc
	ret
cal endp
;子程序名:output
;功能描述:输出各个区间所含数个数
output proc 
	inout c2,9
	inout m0,9
	mov cx,9
	lea bx,sum
	call bcd
	add bx,2
	inout c0,9
o1:	inout m1,9
	call bcd
	add bx,2
	inout c0,9
	inc m1
	inc m1+8
	loop o1
	ret
output endp
;子程序名：bcd
;功能描述：将二进制数转换为十进制输出
;入口参数：ds:[bx]
;出口参数：输出比ave大的数
BCD	proc
	push ax
	push bx
	push cx
	push di
	push dx
	mov ax,[bx]
	lea di,ss1
	mov cx,0
	or ax,ax
    jns t1
    mov byte ptr [di],'-'
    inc di
    neg ax
t1: mov dx,0
	div base
	push dx
	inc cx
	cmp ax,0
	jne t1
t2:	pop ax
	add	al,30h
	cmp al,'9'
	JS pp
	add al,7
pp:	
	mov [di],al
	inc di
	loop t2
	mov byte ptr [di],'$'
	add di,2
	inout ss1,9
t3:	dec di
	mov byte ptr[di],0
	cmp dx,di
	jne t3
	pop dx
	pop di
	pop cx
	pop bx
	pop ax
	ret
BCD	endp
code ends
end start
```

###### 第八题

```assembly
inout macro x,y
	lea dx,x
	mov ah,y
	int 21h
endm
assume ds:data,cs:code
data segment 
	c0	db 	13,10,'$'
	c1	db	'please input numbert(0-999):$'
	er	db 	'It is not a number!',13,10,'$'
	c2	db	'The statistics reslut is:',13,10,'$'
	m0	db	'0<=~<=99:$'
	m1	db	'100<=~<=199:$'
	buf dw 	102 dup (0)
	str1 db  10 dup(0)
	sum dw 10 dup(0)
	ten dw 10
	base dw 10
	div1 dw 100
	count dw 0
data ends
code segment
start:	mov ax,data
		mov ds,ax
		mov es,ax

		call scanf
		call cal
		call output
		mov ah,4ch
		int 21h
;子程序名:scanf
;功能描述：用于将字符存入buf缓存区中
scanf proc
		lea bx,buf
s1:		inout c1,9
		inout str1,10
		inout c0,9 
		mov al,str1+1
		mov ah,0
		lea si,str1+2
		add si,ax
		lea di,str1+2
s2:		mov cl,[di]
		cmp cl,30h
		js sexit
		cmp cl,39h
		jns sexit
		sub cl,30h
		mul base
		mov ch,0
		mov ax,cx
		inc di
		cmp si,di
		jnz s2
		mov [bx],ax
		inc count
		jmp s1
sexit:	inout er,9
		ret
scanf endp
;子程序名:cal
;功能描述:计算各个区间所含数个数
cal proc
	mov cx,count
	lea bx,buf
cc:	mov ax,[bx]
	mov dx,0
	div div1
	mov si,ax
	inc sum[si*2]
	loop cc
	ret
cal endp
;子程序名:output
;功能描述:输出各个区间所含数个数
output proc 
	inout c2,9
	inout m0,9
	mov cx,9
	lea bx,cnt
	inout c0,9
	call bcd
	add bx,2
	inout c0,9
o1:	inout m1,9
	call bcd
	inout c0,9
	add bx,2
	inc m1
	inc m1+8
	loop o1
	ret
output endp
;子程序名：bcd
;功能描述：将二进制数转换为十进制输出
;入口参数：ds:[bx]
;出口参数：输出比ave大的数
BCD	proc
	push ax
	push bx
	push cx
	push di
	push dx
	mov ax,[bx]
	lea di,pp
	mov cx,0
	or ax,ax
    jns t1
    mov byte ptr [di],'-'
    inc di
    neg ax
t1: mov dx,0
	div base
	push dx
	inc cx
	cmp ax,0
	jne t1
t2:	pop ax
	add	al,30h
	cmp al,'9'
	JS pp
	add al,7
pp:	
	mov [di],al
	inc di
	loop t2
	mov byte ptr [di],','
	mov byte ptr [di+1],'$'
	add di,2
	inout buf,9
t3:	dec di
	mov byte ptr[di],0
	cmp dx,di
	jne t3
	pop dx
	pop di
	pop cx
	pop bx
	pop ax
	ret
BCD	endp
code ends
end start
```

###### 第九题

```assembly
inout macro x,y
	lea dx,x
	mov ah,y
	int 21h
endm
assume cs:code,ds:data,ss:stack
stack segment
	db 256 dup(0)
stack ends
data segment
	c0	db	13,10,'$'
	c1	db 	'Please set password(number and letters):$'
	c2	db 	'Please input login password:$'
	c3 	db	'Login succeed!The true password is:$'
	c4	db	'Login failed!The true password is:$'
	;min	db	'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
	ser db	'2349875610QWERTYUIOPASDFGHJKLZXCVBNM'
	count = 28
	key	db	'9801267543KXVMCNOPHQRSZYIJADLEGWBUFT'
	mcode db count dup(0),13,10,'$'
	jcode db count dup(0),13,10,'$'
	buf   db count dup(0),13,10,'$'
	num1 dw 0
	num dw	0
data ends
code segment
start:	mov ax,stack
		mov ss,ax
		mov ax,data
		mov ds,ax
		mov es,ax
		mov bx,1
		call setting
		call login
		call check
		call save
		inout jcode,9
		mov ah,4ch
		int 21h
;过程名称:setting
;功能:设置密码
setting proc 
	 	inout c1,9
	 	mov si,0
input:	mov ah,7
		int 21h
		push ax
		mov dl,'*'
		mov ah,2
		int 21h
		pop ax
		cmp al,30h
		jb exit
		cmp al,39h
		jbe digit
		cmp al,'A'
		jb exit
		cmp al,'Z'
		jbe char
		jmp exit
char:	sub al,7
digit:	sub al,'0'
		lea bx,ser
		xlatb
		mov mcode[si],al
		inc si
		loop input
exit:	mov num,si
		inout c0,9
		inout mcode,9
		inout c0,9
		ret
setting endp
;过程名称:login
;功能:输入登入密码
login proc
	 	inout c2,9
	 	mov si,0
input:	mov ah,7
		int 21h
		push ax
		mov dl,'*'
		mov ah,2
		int 21h
		pop ax
		cmp al,30h
		jb exit1
		cmp al,39h
		jbe digit1
		cmp al,'A'
		jb exit1
		cmp al,'Z'
		jbe char1
		jmp exit1
char1:	sub al,7
digit1:	sub al,'0'
		lea bx,ser
		xlatb
		mov buf[si],al
		inc si
		loop input
exit1:	mov num1,si
		inout c0,9
		inout buf,9
		inout c0,9
		ret
login endp
;过程名称:check
;功能:判断输入密码和设定密码是否相同
check proc
	lea si,buf
	lea di,mcode
	mov ax,num
	cmp ax,num1
	jnz no
	mov cx,num
	cld
	repz cmpsw
	jnz no
	inout c3,9
    inout c0,9
   	jmp exit1
no:	inout c4,9
	inout c0,9
exit1:ret
check endp
;过程名称:save
;功能:有密文获得明文
save proc
	cld
	mov cx,num
	lea si,mcode
	lea di,jcode
	lea bx,key
J:	lodsb
	cmp al,39h
	jbe dig
	sub al,7
dig:sub al,'0'
	xlatb 
	stosb
	loop J
	ret
save endp
code ends
end start
```











