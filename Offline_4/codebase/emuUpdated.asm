.MODEL SMALL

.STACK 100H

.DATA

function_ra DW ?
a1 DW ?
b4 DW ?
t0 DW ?
t1 DW ?
t2 DW ?


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

function proc 

pop function_ra 

push ax 
push bx 
push cx 
push dx 
push bp 
mov bp, sp 
push t2 

;if 
mov ax, [bp+10] 
mov bx, 1 
cmp ax, bx 
je L0 
mov t0, 0 
jmp L1 
L0: 
mov t0, 1 
L1: 

mov ax, [bp+10] 
mov bx, 0 
cmp ax, bx 
je L2 
mov t1, 0 
jmp L3 
L2: 
mov t1, 1 
L3: 

mov ax, t0 
mov bx, t1 
cmp ax, 0 
jne L4 
cmp bx, 0 
jne L4 
mov t0, 0 
jmp L5 
L4: 
mov t0, 1 
L5: 

mov ax, t0 
cmp ax, 0 
je L6 

;return 1; 
mov ax, 1 
jmp ret_function 
L6: 


;return function(a-2)+function(a-1); 
mov ax, [bp+10] 
mov bx, 2 
sub ax, bx 
mov t0, ax 
mov cx, function_ra 
mov t2, cx 
push t0 
call function 
mov cx, t2 
mov function_ra, cx 
mov ax, [bp+10] 
mov bx, 1 
sub ax, bx 
mov t0, ax 
mov cx, function_ra 
mov t2, cx 
push t0 
call function 
mov cx, t2 
mov function_ra, cx 
pop di 
mov ax, di 
pop di 
mov bx, di 
add ax, bx 
mov t0, ax 
jmp ret_function 
ret_function: 
mov si, ax 
pop t2 
pop bp 
pop dx 
pop cx 
pop bx 
pop ax 

pop ax 

push si 
push function_ra 
ret 

function endp 

MAIN proc 

;initialize DS 
MOV AX, @DATA 
MOV DS, AX 

;a=1; 
mov ax, 1 
mov a1, ax 

;int b; 

;b=6; 
mov ax, 6 
mov b4, ax 

;a=a+function(b); 
push b4 
call function 
mov ax, a1 
pop di 
mov bx, di 
add ax, bx 
mov t0, ax 
mov a1, ax 

;println(a); 
push a1 
mov dx, 0 
mov cx, 0 
call println 

ret_main: 
MOV AH, 4CH 
INT 21H 
ret 

MAIN endp 


END MAIN