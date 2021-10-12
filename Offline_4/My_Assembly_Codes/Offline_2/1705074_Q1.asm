.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER FIRST NUMBER: $'
    MSG2 DB CR, LF, 'ENTER SECOND NUMBER: $'
    MSG3 DB CR, LF, 'ENTER THIRD NUMBER: $'
    X DB ?
    Y DB ?
    Z DB ?
    SECOND_HIGHEST DB ?
    MSG_OUT DB CR, LF, 'The second highest is: $'
    MSG_EQL DB CR, LF, 'All the numbers are equal $'

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX  
    
    
    
;------------------------------ input section -----------------------------    
    
;print user prompt to take input of first number
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;input a number for X     
    MOV AH, 1
    INT 21H
    MOV X, AL
    ;SUB X, 48D
    
;print user prompt to take input of second number
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

;input a number for Y     
    MOV AH, 1
    INT 21H
    MOV Y, AL
    ;SUB Y, 48D 
    
;print user prompt to take input of third number
    LEA DX, MSG3
    MOV AH, 9
    INT 21H

;input a number for Z     
    MOV AH, 1
    INT 21H
    MOV Z, AL
    ;SUB Z, 48D
    
    
;------------------------------ logic section -----------------------------

    MOV AL, X
    CMP AL, Y
    JE XEQY
    
    ; this is reached. So, X <> Y 
    
    MOV AL, Y
    CMP AL, Z
    JE XNEQY_YEQZ
    
    ; this is reached. So, X <> Y and Y <> Z
    
    MOV AL, X
    CMP AL, Y
    JA XGRY
    
    ; this is reached. So, X < Y
    
    CMP AL, Z
    JA RESULT_X
    
    ; this is reached. So, X < Y and X < Z
    
    JMP XLSY_XLSZ
    
 
XEQY:
    ; this is reached. So, X = Y
    
    MOV AL, Y
    CMP AL, Z
    JE DISPLAY_EQL
    
    ; this is reached. So, X = Y and Y <> Z 
    
    JA RESULT_Z
    
    ; this is reached. So, X = Y and Y < Z
    
    JMP RESULT_Y   
    
    
XNEQY_YEQZ:
    ; this is reached. So, X <> Y and Y = Z
    
    MOV AL, X
    CMP AL, Y
    JA RESULT_Y
    
    ; this is reached. So, X < Y and Y = Z
         
    JMP RESULT_X     
 
    
XGRY:
    ; this is reached. So, X > Y
    
    CMP AL, Z
    JA XGRY_XGRZ
    
    ; this is reached. So, X > Y and X < Z
    
    JMP RESULT_X
    
    
XGRY_XGRZ:
    ; this is reached. So, X > Y and X > Z
    
    MOV AL, Y
    CMP AL, Z
    JA RESULT_Y
    
    ; this is reached. So, X > Y, X > Z and Y < Z
    
    JMP RESULT_Z    
    
    
XLSY_XLSZ:
    ; this is reached. So, X < Y and X < Z
    
    MOV AL, Y
    CMP AL, Z
    JA RESULT_Z
    
    ; this is reached. So, X < Y, X < Z and Y < Z
    
    JMP RESULT_Y 


DISPLAY_EQL:
    ; this is reached. So, X = Y and Y = Z
    
    LEA DX, MSG_EQL
    MOV AH, 9
    INT 21H
    JMP DOS_EXIT
         

RESULT_X:
    MOV DL, X
    JMP DISPLAY

RESULT_Y:
    MOV DL, Y
    JMP DISPLAY

RESULT_Z:
    MOV DL, Z
    JMP DISPLAY
    
        
DISPLAY:
    MOV SECOND_HIGHEST, DL
    LEA DX, MSG_OUT
    MOV AH, 9
    INT 21H
            
    MOV DL, SECOND_HIGHEST        
    MOV AH, 2
    INT 21H           
           
       
    
;------------------------------ End section -----------------------------    
    
;DOS exit
DOS_EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
    
       