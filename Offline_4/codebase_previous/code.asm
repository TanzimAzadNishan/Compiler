.MODEL SMALL

.STACK 100H

.DATA

x6 DW ?
a7 DW ?
b7 DW ?
t0 DW ?
t1 DW ?
t2 DW ?
t3 DW ?
t4 DW ?
t5 DW ?
t6 DW ?


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

;if
mov ax, [bp+12]
mov bx, 1
cmp ax, bx
je L0
mov t0, 0
jmp L1
L0:
mov t0, 1
L1:

mov ax, t0
cmp ax, 0
je L2

;return 0;
mov ax, 0
jmp ret_f
L2:


;if
mov ax, [bp+12]
mov bx, 2
cmp ax, bx
je L3
mov t1, 0
jmp L4
L3:
mov t1, 1
L4:

mov ax, t1
cmp ax, 0
je L5

;return 1;
mov ax, 1
jmp ret_f
L5:


;if
mov ax, [bp+12]
mov bx, 3
cmp ax, bx
je L6
mov t2, 0
jmp L7
L6:
mov t2, 1
L7:

mov ax, t2
cmp ax, 0
je L8

;return 1;
mov ax, 1
jmp ret_f
L8:


;return f(n-1)+f(n-2)+f(n-3);
mov ax, [bp+12]
mov bx, 1
sub ax, bx
mov t3, ax
push t3
call f
mov ax, [bp+12]
mov bx, 2
sub ax, bx
mov t5, ax
mov si, t4
push si
push t5
call f
pop di
mov ax, di
mov bx, si
add ax, bx
mov t4, ax
mov ax, [bp+12]
mov bx, 3
sub ax, bx
mov t6, ax
mov si, t4
push si
push t6
call f
pop di
mov ax, di
mov bx, si
add ax, bx
mov t4, ax
mov ax, t4
jmp ret_f
ret_f:
mov si, ax
mov t4, ax
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
mov ax, t4
mov bx, [bp+14]
add ax, bx
mov t4, ax
mov ax, t4
mov bx, [bp+12]
add ax, bx
mov t4, ax
mov ax, t4
mov x6, ax

;return x;
mov ax, x6
jmp ret_g
ret_g:
mov t4, ax
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

;a=4;
mov ax, 4
mov a7, ax

;b=2;
mov ax, 2
mov b7, ax

;a=g(a,b);
push a7
push b7
call g
mov ax, t4
mov a7, ax

;println(a);
push a7
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
