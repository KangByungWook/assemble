;DOT MATRIX 실험1 ~  DOT COLOR TEST 

COLGREEN     EQU    0FFC5H  
COLRED       EQU    0FFC6H   
ROW          EQU    0FFC7H   

             ORG    8000H

;****************************************************
;*       R0 : DOT ROW 값 저장                       *
;*       R1 : DOT COLUMN GREEN 값 저장              *
;*       R2 : DOT COLUMN RED 값 저장                *
;****************************************************

LOOP:        MOV    R1,#00H  ; DOT MATRIX LED 끄기
             MOV    R2,#00H
             MOV    R0,#00H
            
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY
                    
             MOV    R1,#0FFH ; GREEN COLOR 켜기
             MOV    R2,#00H
             MOV    R0,#0FFH
             
             CALL   DOTCOLG 
             CALL   DOTCOLR
             CALL   DELAY
             
             MOV    R1,#00H  ; RED COLOR 켜기
             MOV    R2,#0FFH
             MOV    R0,#0FFH
                    
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY

             MOV    R1,#0FFH ; GREEN|+RED COLR 켜기
             MOV    R2,#0FFH
             MOV    R0,#0FFH 
                    
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY
             JMP    LOOP
                  
DOTCOLG:     MOV    DPTR,#COLGREEN
             MOV    A,R1
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET

DOTCOLR:     MOV    DPTR,#COLRED
             MOV    A,R2
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET 

DELAY:       MOV    R7,#07H
DELAY1:      MOV    R6,#0FFH
DELAY2:      MOV    R5,#0FFH
DELAY3:      DJNZ   R5,DELAY3
             DJNZ   R6,DELAY2
             DJNZ   R7,DELAY1
             RET 
END                     
                