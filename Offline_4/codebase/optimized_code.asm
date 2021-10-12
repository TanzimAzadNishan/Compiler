.MODEL SMALL

.STACK 100H

.DATA

a2 DW ?
b2 DW ?
c2 DW 3 DUP (?)
t0 DW ?


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

MAIN proc 

;initialize DS 
MOV AX, @DATA 
MOV DS, AX 

;int a,b,c[3]; 

;a=1*(2+3)%3; 
mov ax, 2 
mov bx, 3 
add ax, bx 
mov t0, ax 
mov ax, 1 
mov bx, t0 
mul bx 
mov t0, ax 
mov bx, 3 
xor dx, dx 
div bx 
mov t0, dx 
mov ax, t0 
mov a2, ax 

;b=1<5; 
mov ax, 1 
mov bx, 5 
cmp ax, bx 
jl L0 
mov t0, 0 
jmp L1 
L0: 
mov t0, 1 
L1: 

mov ax, t0 
mov b2, ax 

;c[0]=2; 
mov ax, 2 
mov bx, 0 
add bx, bx 
mov c2[bx], ax 

;if 
mov ax, a2 
mov bx, b2 
cmp ax, 0 
je L2 
cmp bx, 0 
je L2 
mov t0, 1 
jmp L3 
L2: 
mov t0, 0 
L3: 

mov ax, t0 
cmp ax, 1 
jne L4 
mov bx, 0 
add bx, bx 
mov ax, c2[bx] 
add c2, 1 
mov t0, ax 
jmp L5 
L4: 
mov bx, 0 
add bx, bx 
mov ax, c2[bx] 
mov bx, 1 
add bx, bx 
mov c2[bx], ax 
L5: 


;println(a); 
push a2 
mov dx, 0 
mov cx, 0 
call println 

;println(b); 
push b2 
mov dx, 0 
mov cx, 0 
call println 

ret_main: 
MOV AH, 4CH 
INT 21H 
ret 

MAIN endp 


END MAIN
