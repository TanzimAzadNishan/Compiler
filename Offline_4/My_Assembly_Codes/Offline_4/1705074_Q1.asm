.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG_INP1 DB 'ENTER MATRIX 1: $'
    MSG_INP2 DB 'ENTER MATRIX 2: $'
    MSG_OUT DB 'OUTPUT MATRIX: $'
    MSG_NL DB CR, LF, '$'
    ARR_A DW 0000H, 0000H
          DW 0000H, 0000H

    ARR_B DW 0000H, 0000H
          DW 0000H, 0000H
          
    ARR_RESULT DW 0000H, 0000H
          DW 0000H, 0000H          
          
    TEMP DW 0000H
    CNT_DIGIT DW 0000H
    DIVISOR DW 0000H                 
    

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    
;print user prompt to take input
    LEA DX, MSG_INP1
    MOV AH, 9
    INT 21H
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H


;------------------- INPUT MATRIX A -------------------------  
            
    MOV CX, 2
    MOV BX, 0
    XOR SI, SI
    
    
ITR_ROW_A:
    MOV TEMP, 2
    ADD BX, SI
    XOR SI, SI

    
ITR_COL_A:
    CMP TEMP, 0
    JE END_ROW_A 
        
    MOV AH, 1
    INT 21H
        
    MOV AH, 0
    SUB AL, 48D
    MOV ARR_A[BX][SI], AX
    
    MOV AH, 2
    MOV DL, 20H
    INT 21H
    
    ADD SI, 2
    DEC TEMP
    JMP ITR_COL_A    

END_ROW_A:
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H
    
    LOOP ITR_ROW_A
    
        

;------------- INPUT MATRIX B ------------------
    LEA DX, MSG_INP2
    MOV AH, 9
    INT 21H
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H

            
    MOV CX, 2
    MOV BX, 0
    XOR SI, SI
    
    
ITR_ROW_B:
    MOV TEMP, 2
    ADD BX, SI
    XOR SI, SI

    
ITR_COL_B:
    CMP TEMP, 0
    JE END_ROW_B 
        
    MOV AH, 1
    INT 21H
        
    MOV AH, 0
    SUB AL, 48D
    MOV ARR_B[BX][SI], AX
    
    MOV AH, 2
    MOV DL, 20H
    INT 21H
    
    ADD SI, 2
    DEC TEMP
    JMP ITR_COL_B    

END_ROW_B:
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H
    
    LOOP ITR_ROW_B
    

;--------------- INPUT SECTION ENDS -----------------------


    LEA DX, MSG_OUT
    MOV AH, 9
    INT 21H
    
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H    
    
;-------------------- OPERATION --------------------------

    MOV CX, 2
    MOV BX, 0
    XOR SI, SI
    
    
RES_ROW:
    MOV TEMP, 2
    ADD BX, SI
    XOR SI, SI

    
RES_COL:
    CMP TEMP, 0
    JE RES_WHILE 
        
    MOV AX, ARR_A[BX][SI]
    ADD AX, ARR_B[BX][SI]
    MOV ARR_RESULT[BX][SI], AX
    
    
    MOV DX, 0000H
    MOV AX, ARR_RESULT[BX][SI]
    MOV CNT_DIGIT, 0
    CALL PRINT_OPERAND
    
    
    MOV AH, 2
    MOV DL, 20H
    INT 21H
    
    
    ADD SI, 2
    DEC TEMP
    JMP RES_COL    

RES_WHILE:
    LEA DX, MSG_NL
    MOV AH, 9
    INT 21H
    
    LOOP RES_ROW
    
                       
DOS_EXIT:    
    ;DOS exit
    MOV AH, 4CH
    INT 21H 
    
MAIN ENDP    
    

;------------------- main procedure ends -----------------    
    


; procedure for printing operand
    
PRINT_OPERAND PROC
    
TAKE_REMAINDER:

    CMP CNT_DIGIT, 0
    JE DIVIDE
        
    CMP AX, 0
    JE DISPLAY

DIVIDE:    
    MOV DIVISOR, 10
    DIV DIVISOR
    
    PUSH DX
    INC CNT_DIGIT
    XOR DX, DX
    JMP TAKE_REMAINDER
    
DISPLAY:
    MOV AH, 2
    
    
POP_AND_PRINT:
    CMP CNT_DIGIT, 0
    JE STOP_PRINT
        
    POP DX
    ADD DX, 48D
    INT 21H
    DEC CNT_DIGIT
    JMP POP_AND_PRINT
            
STOP_PRINT:    
    RET              


PRINT_OPERAND ENDP 
  

END MAIN      