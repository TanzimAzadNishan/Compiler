.MODEL SMALL

.STACK 100H

.DATA

x3 DW ?
a4 DW ?
b4 DW ?
t0 DW ?
t1 DW ?


.CODE

println proc

push ax 
push bx 
push cx 
push dx 
push bp 
mov bp, sp
mov ax, [bp+12]
mov bx, ax
or bx, bx
jge Take_Remainder
neg bx
mov ah, 2
mov dl, 2DH
int 21H
mov dx, 0
mov cx, 0
mov ax, bx
Take_Remainder:

cmp cx, 0
je Divide

cmp ax, 0
je Display

Divide:
mov bx, 10
div bx
push dx
inc cx
xor dx, dx
jmp Take_Remainder

Display:
mov ah, 2

Pop_and_Print:
pop dx
add dx, 48D
int 21h
loop Pop_and_Print
mov dl, 0Ah
int 21h
mov dl, 0Dh
int 21h
pop bp 
pop dx 
pop cx 
pop bx 
pop ax 
ret 2
println endp

f proc

push ax 
push bx 
push cx 
push dx 
push bp 
mov bp, sp

;return 2*a;
mov ax, 2
mov bx, [bp+12]
mul bx
mov t0, ax
mov ax, t0
jmp ret_f

;a=9;
mov ax, 9
mov [bp+12], ax
ret_f:
mov t1, ax
pop bp 
pop dx 
pop cx 
pop bx 
pop ax 
ret 2

f endp

g proc

push ax 
push bx 
push cx 
push dx 
push bp 
mov bp, sp

;int x;

;x=f(a)+a+b;
push [bp+14]
call f
mov ax, t1
mov bx, [bp+14]
add ax, bx
mov t1, ax
mov ax, t1
mov bx, [bp+12]
add ax, bx
mov t1, ax
mov ax, t1
mov x3, ax

;return x;
mov ax, x3
jmp ret_g
ret_g:
mov t1, ax
pop bp 
pop dx 
pop cx 
pop bx 
pop ax 
ret 4

g endp

MAIN proc

;initialize DS
MOV AX, @DATA
MOV DS, AX

;int a,b;

;a=1;
mov ax, 3
mov a4, ax

;b=2;
mov ax, 2
mov b4, ax

;a=g(a,b);
push a4
push b4
call g
mov ax, t1
mov a4, ax

;println(a);
push a4
mov dx, 0
mov cx, 0
call println

;return 0;
mov ax, 0
jmp ret_main

ret_main:
MOV AH, 4CH
INT 21H
ret

MAIN endp


END MAIN