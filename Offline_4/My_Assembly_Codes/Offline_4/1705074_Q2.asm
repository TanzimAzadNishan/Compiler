.MODEL SMALL

;.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG_INP DB 'ENTER YOUR INPUT: $'
    MSG_NL DB CR, LF, '$'
    N DW 0000H
    
    TEMP DW 0000H
    CNT DW 0000H
    
    
.CODE



; procedure for printing number
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



MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    
;print user prompt to take input
    LEA DX, MSG_INP
    MOV AH, 9
    INT 21H


;------------------- form operands and operator from input -------------------------  

FORM_N:

    CALL FORM_INTEGER
    
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H
    
    CMP N, 0
    JE DOS_EXIT
    
    MOV AH, 2
      
    MOV DL, 30H
    INT 21H
    
    
    CMP N, 2
    JL DOS_EXIT
    
    MOV DL, 2CH
    INT 21H
    
    MOV DL, 31H
    INT 21H
    
        
    
OPERATION:
    MOV CNT, 3    
    MOV AX, N
    PUSH AX
    CALL FIBONACCI
             
    
DOS_EXIT:    
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP    
    

;------------------- main procedure ends -----------------    
    

; This procedure takes non-negative 2 digit integer as input
    
FORM_INTEGER PROC
    MOV CX, 2
    MOV DX, 0
    
TAKE_INP:
    MOV AH, 1        
    INT 21H
    
    SUB AL, 48D
    MOV AH, 0
    MOV BX, AX
    
    CMP DX, 0
    JE ADD_INP
    
    MOV AX, 10
    MUL N
    MOV N, AX
    
ADD_INP:
    MOV DX, 1    
    ADD N, BX
    
    LOOP TAKE_INP
    
    RET
            
FORM_INTEGER ENDP



FIBONACCI PROC
      
    PUSH BP
    MOV BP, SP
    
    MOV CX, [BP+4]
    CMP CX, 1
    JE BASE_CASE_1
    
    CMP CX, 2
    JE BASE_CASE_2

    
RECURSION:

;------- COMPUTE FIB(N-1) ------------------
    MOV CX, [BP+4]
    DEC CX
    PUSH CX
    
    CALL FIBONACCI
    
    PUSH TEMP
    
    
;------- COMPUTE FIB(N-2) ------------------    
    
    MOV CX, [BP+4]
    SUB CX, 2
    PUSH CX
    
    CALL FIBONACCI
    
    
    POP BX
    ADD TEMP, BX
    
    JMP PRINT
    
BASE_CASE_1:
    MOV TEMP, 0
    JMP RETURN            
        
BASE_CASE_2:
    MOV TEMP, 1
    JMP RETURN 
        
PRINT:
    MOV CX, [BP+4]
    CMP CNT, CX
    JNE RETURN

    MOV AH, 2
    MOV DL, 2CH
    INT 21H
    
    INC CNT
    
    MOV AX, TEMP
    MOV DX, 0000H
    MOV CX, 0
    CALL PRINT_OPERAND
    
    
RETURN:
    POP BP
    RET 2         
          
    
FIBONACCI ENDP

  

END MAIN      