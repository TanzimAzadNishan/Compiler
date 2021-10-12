.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSGX DB 'ENTER A NUMBER FOR X: $'
    MSGY DB CR, LF, 'ENTER A NUMBER FOR Y: $'
    MSGZ1 DB CR, LF, 'THE VALUE OF Z = X - 2Y:       $'
    MSGZ2 DB CR, LF, 'THE VALUE OF Z = 25 - (X + Y): $'
    MSGZ3 DB CR, LF, 'THE VALUE OF Z = 2X - 3Y:      $'
    MSGZ4 DB CR, LF, 'THE VALUE OF Z = Y - X + 1:    $'
    X DB ?
    Y DB ?
    Z DB ?

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
                     
                     
;---------------------- input section --------------------------
                     
;print user prompt to take input
    LEA DX, MSGX
    MOV AH, 9
    INT 21H

;input a number for X     
    MOV AH, 1
    INT 21H
    MOV X, AL
    SUB X, 48D

;print user prompt to take input
    LEA DX, MSGY
    MOV AH, 9
    INT 21H
        
;input a number for Y     
    MOV AH, 1
    INT 21H
    MOV Y, AL
    SUB Y, 48D   
    
    
    
;---------------------- Operation section -----------------------

; Z = X - 2*Y
    MOV AL, X
    SUB AL, Y
    SUB AL, Y
    ADD AL, 30H
    MOV Z, AL
    
    
;display on the next line
    LEA DX, MSGZ1
    MOV AH, 9
    INT 21H  
    
;display the value of Z  
    MOV AH, 2
    MOV DL, Z
    INT 21H    
    
    
    
;---------------------- Operation section --------------------------
    
; Z = 25 - (X + Y)
    MOV AL, 25D
    SUB AL, X
    SUB AL, Y
    ADD AL, 30H
    MOV Z, AL 
    
    
;display on the next line
    LEA DX, MSGZ2
    MOV AH, 9
    INT 21H  
    
;display the value of Z  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
        
        
;---------------------- Operation section --------------------------    
    
; Z = 2*X - 3*Y
    MOV AL, X
    ADD AL, X
    SUB AL, Y
    SUB AL, Y
    SUB AL, Y
    ADD AL, 30H
    MOV Z, AL
    
;display on the next line
    LEA DX, MSGZ3
    MOV AH, 9
    INT 21H  
    
;display the value of Z  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    
    
        
;---------------------- Operation section --------------------------
    
; Z = Y - X + 1
    MOV AL, Y
    SUB AL, X
    ADD AL, 1
    ADD AL, 30H
    MOV Z, AL   
    
    
;display on the next line
    LEA DX, MSGZ4
    MOV AH, 9
    INT 21H  
    
;display the value of Z  
    MOV AH, 2
    MOV DL, Z
    INT 21H  
    
    
   
   
;---------------------- End section --------------------------    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN