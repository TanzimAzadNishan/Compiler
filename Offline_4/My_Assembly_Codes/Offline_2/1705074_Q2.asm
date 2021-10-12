.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER YOUR PASSWORD: $'
    MSG_INVALID DB CR, LF, 'Invalid password $'
    MSG_VALID DB CR, LF, 'Valid password $'
    UPPER_CASE DB 00H
    LOWER_CASE DB 00H
    DIGIT DB 00H

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    
;print user prompt to take input
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

; input characters

    MOV AH, 1
    
TAKE_INP:    
    INT 21H
    CMP AL, 21H
    JB CHECK_DIGIT
    CMP AL, 7EH
    JA CHECK_DIGIT
 
    JMP DIGIT_SECTION
   
     

DIGIT_SECTION:
    ; inp is not out of range
    
    CMP AL, 30H
    JB TAKE_INP
    
    ; inp >= 30H
     
    CMP AL, 39H
    JA UPPER_CASE_SECTION
    
    ; inp >= 30H and <= 39H. So, a digit encountered
    
    MOV DIGIT, 01H
    JMP TAKE_INP
         
    
    
UPPER_CASE_SECTION:
    ; inp > 39H
    
    CMP AL, 41H
    JB TAKE_INP
    
    ; inp >= 41H
    
    CMP AL, 5AH
    JA LOWER_CASE_SECTION
    
    ; inp >= 41H and <= 5AH. So, a upper case char encountered
    
    MOV UPPER_CASE, 01H
    JMP TAKE_INP
    
    
LOWER_CASE_SECTION:
    ; inp > 5AH
    
    CMP AL, 61H
    JB TAKE_INP
    
    ; inp >= 61H
    
    CMP AL, 7AH
    JA TAKE_INP
    
    ; inp >= 61H and <= 7AH. So, a lower case char encountered
    
    MOV LOWER_CASE, 01H
    JMP TAKE_INP 
 

CHECK_DIGIT:
    CMP DIGIT, 01H
    JE CHECK_UPPER_CASE
    LEA DX, MSG_INVALID
    JMP DISPLAY
    
    
CHECK_UPPER_CASE:
    CMP UPPER_CASE, 01H
    JE CHECK_LOWER_CASE
    LEA DX, MSG_INVALID
    JMP DISPLAY
    
CHECK_LOWER_CASE:
    CMP LOWER_CASE, 01H
    JE  LOAD_VALID_MSG
    LEA DX, MSG_INVALID
    JMP DISPLAY                

     
LOAD_VALID_MSG:
    LEA DX, MSG_VALID
    JMP DISPLAY    
         
     
DISPLAY:
    MOV AH, 9
    INT 21H
    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN