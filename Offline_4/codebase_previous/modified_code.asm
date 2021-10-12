;1*2
mov ax, 1
mov bx, 2
mul bx

;a[1*2]
mov t0, ax
mov bx, t0
add bx, bx
mov ax, a[bx]

;i*a[1*2]
mov t1, ax
mov ax, i
mov bx, t1
mul bx

a[1]=i*a[1*2];
mov t2, ax
mov bx, 1
add bx, bx
mov ax, t2
mov  a[bx], ax

;if(i<2)
mov ax, i
cmp ax, 2
jl L0

mov t3, 0
jmp L1
L0:
mov t3, 1
L1:
mov ax, t3
cmp ax, 0
je L2

a[2]=5;
mov bx, 2
add bx, bx
mov ax, 5
mov  a[bx], ax

L2:
