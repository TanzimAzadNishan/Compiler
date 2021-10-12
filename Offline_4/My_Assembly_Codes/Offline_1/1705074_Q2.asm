.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A UPPER CASE LETTER: $'
    MSG2 DB CR, LF, 'THE PREV LETTER OF IT: $'
    MSG3 DB CR, LF, "THE 1's COMPLEMENT OF IT: $"
    PREV_lOWER DB ?
    COMPLEMENT DB ?

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX      
    
    
; ---------------------- input section ----------------------------------    
    
;print user prompt to take input 
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;input a upper case character     
    MOV AH, 1
    INT 21H
    
    
    
; ---------------------- logic section -----------------------------------    
    
; calculate its previous lowercase letter and ones's complement    
    MOV PREV_lOWER, AL
    ADD PREV_lOWER, 1FH
    MOV COMPLEMENT, AL
    NOT COMPLEMENT    
    
    
    
; ----------------------- output section ----------------------------------
    
;display on the next line
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    
;display the previous lowercase letter  
    MOV AH, 2
    MOV DL, PREV_lOWER
    INT 21H        
    
    
;display on the next line
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  
    
;display the ones's complement  
    MOV AH, 2
    MOV DL, COMPLEMENT
    INT 21H
            
            
; ---------------------- program end section --------------------------------            
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN