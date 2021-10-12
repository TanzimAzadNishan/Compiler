.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG_INP DB 'ENTER YOUR INPUT: $'
    MSG_NL DB CR, LF, '$'
    MSG_WO DB CR, LF, 'Wrong operator$'
    OPERAND1 DW 0000H
    OPERAND2 DW 0000H
    OPERATOR DB ?
    SIGN_TEMP DB 00H
    SIGN1 DB 00H
    SIGN2 DB 00H
    TEMP DW 0000H
    RESULT DW ?

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    
;print user prompt to take input
    LEA DX, MSG_INP
    MOV AH, 9
    INT 21H


;------------------- form operands and operator from input -------------------------  

FORM_OPERAND1:
    MOV AH, 1
    MOV DX, 0
    CALL TAKE_SMD_INT
    MOV OPERAND1, DX
    MOV AL, SIGN_TEMP
    MOV SIGN1, AL
    MOV SIGN_TEMP, 00H
    
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H
    
    
FORM_OPERATOR:
    MOV AH, 1
    INT 21H
    
    CMP AL, 71H
    JE DOS_EXIT
    
CHECK_OPERATOR:

    CMP AL, 2AH
    JE STORE_OPERATOR
    
    CMP AL, 2BH
    JE STORE_OPERATOR
    
    CMP AL, 2DH
    JE STORE_OPERATOR
    
    CMP AL, 2FH
    JE STORE_OPERATOR
    
    ; Input is not a operator
    LEA DX, MSG_WO
    MOV AH, 9
    INT 21H
    
    JMP DOS_EXIT 
     
    

STORE_OPERATOR:
    MOV OPERATOR, AL
    
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H        
    
    
FORM_OPERAND2:    
    MOV AH, 1
    MOV DX, 0
    CALL TAKE_SMD_INT
    MOV OPERAND2, DX
    MOV AL, SIGN_TEMP
    MOV SIGN2, AL
    MOV SIGN_TEMP, 00H
    
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H


;-------------- if the operand is negative, then takes it's 2's complement -------------------    

PREPARE_OP1:        
    MOV AX, OPERAND1
    MOV RESULT, AX
    CMP SIGN1, 2DH
    JNE PREPARE_OP2
    
    NEG AX
    MOV OPERAND1, AX
    MOV RESULT, AX


PREPARE_OP2:        
    MOV AX, OPERAND2
    CMP SIGN2, 2DH
    JNE ARITHMETIC
    NEG AX
    
    MOV OPERAND2, AX
    

;---------------------- operation section ------------------------------    

ARITHMETIC:
        
    CMP OPERATOR, 2BH
    JE ADDITION
    
    CMP OPERATOR, 2DH
    JE SUBTRACTION
    
    CMP OPERATOR, 2AH
    JE MULTIPLICATION
    
    CMP OPERATOR, 2FH
    JE DIVISION
    
        
ADDITION:    
    ADD RESULT, AX    
    JMP OUTPUT 
    
    
SUBTRACTION:
    SUB RESULT, AX    
    JMP OUTPUT
    
        
MULTIPLICATION:    
    MOV BX, AX
    MOV AX, RESULT
    
    IMUL BX
    MOV RESULT, AX
    
    JMP OUTPUT
    
    
DIVISION:
    MOV BX, AX
    MOV AX, RESULT

    MOV DX, 0000H
    CWD
    IDIV BX
    MOV RESULT, AX
    
    JMP OUTPUT
    

;---------------------  output section -----------------------
    
OUTPUT:
    MOV BX, OPERAND1
    CALL DISPLAY_OUTPUT
    
    
    MOV AH, 2
    MOV DL, 5BH
    INT 21H
    
    MOV DL, OPERATOR
    INT 21H
    
    MOV DL, 5DH
    INT 21H
    
    
    MOV BX, OPERAND2 
    CALL DISPLAY_OUTPUT
    
    MOV AH, 2
    MOV DL, 3DH
    INT 21H
    
    MOV BX, RESULT
    CALL DISPLAY_OUTPUT
    JMP DOS_EXIT
    
    
DOS_EXIT:    
    ;DOS exit
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP    
    

;------------------- main procedure ends -----------------    
    

; This procedure takes signed multi-digit integer as input
    
TAKE_SMD_INT PROC
    
TAKE_INP:
    MOV AH, 1    
    INT 21H
    
    CMP AL, 0DH
    JE STOP_INP
    
    CMP AL, 2DH
    JNE FORM_NUMBER
    CMP SIGN_TEMP, 2DH
    JNE STORE_SIGN
    

FORM_NUMBER:
    
    CMP AL, 30H
    JNGE TAKE_INP 
    CMP AL, 39H
    JNLE TAKE_INP
    
    SUB AL, 48D
    
    MOV AH, 0
    MOV TEMP, AX
    
    ;CMP OPERAND, 0
    CMP DX, 0
    JE ADD_INP
            
    ;MOV AX, OPERAND
    MOV AX, DX
    MOV BX, 10
    
    MUL BX
    MOV DX, AX
    
        
ADD_INP:    
    ADD DX, TEMP
    JMP TAKE_INP
    
    
    
STOP_INP:         
    RET

STORE_SIGN:
    MOV SIGN_TEMP, AL
    JMP TAKE_INP    
    
TAKE_SMD_INT ENDP



; procedure for displaying output

DISPLAY_OUTPUT PROC
    
OPEN_BRACKET:
    MOV AH, 2
    MOV DL, 5BH
    INT 21H
    
             
PRINT_RESULT:
    OR BX,BX
    JGE DISPLAY_RESULT
    
    NEG BX
    
    MOV AH, 2
    MOV DL, 2DH
    INT 21H
            
            
DISPLAY_RESULT:
    
    MOV DX, 0000H
    MOV AX, BX
    MOV CX, 0
    CALL PRINT_OPERAND
    
    
CLOSE_BRACKET:          
    MOV AH, 2
    MOV DL, 5DH
    INT 21H
    
    RET    
    

DISPLAY_OUTPUT ENDP



; procedure for printing operand
    
PRINT_OPERAND PROC
    
TAKE_REMAINDER:

    CMP CX, 0
    JE DIVIDE
        
    CMP AX, 0
    JE DISPLAY

DIVIDE:    
    MOV BX, 10
    DIV BX
    
    PUSH DX
    INC CX
    XOR DX, DX
    JMP TAKE_REMAINDER
    
DISPLAY:
    MOV AH, 2
    
    
POP_AND_PRINT:    
    POP DX
    ADD DX, 48D
    INT 21H
    LOOP POP_AND_PRINT
            
    RET              


PRINT_OPERAND ENDP 
  

END MAIN      