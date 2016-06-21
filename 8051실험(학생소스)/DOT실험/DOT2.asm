;DOT MATRIX 실험2 ~  각각의 행 전체 스캔 실험 

COLGREEN     EQU    0FFC5H  
COLRED       EQU    0FFC6H   
ROW          EQU    0FFC7H   

             ORG    8000H

;****************************************************
;*       R0 : DOT ROW 값 저장                       *
;*       R1 : DOT COLUMN GREEN 값 저장              *
;*       R2 : DOT COLUMN RED 값 저장                *
;****************************************************

             MOV    R1,#00H        ; DOT MATRIX LED 끄기
             MOV    R2,#00H
             MOV    R0,#00H
              
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY
               
INIT1:       MOV    R2,#00000000B
             MOV    R0,#00000000B    
             CALL   DOTCOLR        ; RED COLOR 끄기

             MOV    R1,#11111111B  ; 모든 열 ON
             MOV    R0,#00000001B  ; 첫번째 행 ON 
             CLR    C                

LOOP1:       CALL   DOTCOLG        ; GREEN COLOR 켜기
             CALL   DELAY
               
             MOV    A,R0
             RLC    A              ; 다음 행으로 이동 
             MOV    R0,A

             JC     INIT2          ; 색깔 바꾸기 
             JMP    LOOP1          ; 계속 반복하기     

INIT2:       MOV    R1,#00000000B
             MOV    R0,#00000000B
             CALL   DOTCOLG        ; GREEN COLOR 끄기

             MOV    R2,#11111111B  ; 모든 열 ON 
             MOV    R0,#00000001B  ; 첫번째 행 ON
             CLR    C
             
LOOP2:       CALL   DOTCOLR        ; RED COLOR 켜기
             CALL   DELAY

             MOV    A,R0
             RLC    A              ; 다음 행으로 이동
             MOV    R0,A

             JC     INIT1          ; 색깔 바꾸기
             JMP    LOOP2          ; 계속 반복하기 
                         
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

DELAY:       MOV    R7,#02H
DELAY1:      MOV    R6,#0FFH
DELAY2:      MOV    R5,#0FFH
DELAY3:      DJNZ   R5,DELAY3
             DJNZ   R6,DELAY2
             DJNZ   R7,DELAY1
             RET 
END
                     
                