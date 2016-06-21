; 6개의 7_SEGMENT에 깜빡 이기

SEGL            EQU    0FFC3H
SEGM            EQU    0FFC2H
SEGR            EQU    0FFC1H

                ORG    8000H
                
LOOP:           MOV    A,#00H      ; 켜기 
                CALL   SEG
                CALL   DELAY
                call   delay
                
                MOV    A,#0FFH     ; 끄기
                CALL   SEG
                CALL   DELAY
                call   delay
               
                JMP    LOOP

SEG:            MOV    DPTR,#SEGL  ;왼쪽 2개 선택
                MOVX   @DPTR,A      

                MOV    DPTR,#SEGM  ;중간 2개 선택
                MOVX   @DPTR,A     

                MOV    DPTR,#SEGR  ;오른쪽 2개 선택
                MOVX   @DPTR,A     
                RET

DELAY:          MOV    R0,#0FFH
DELAY1:         MOV    R1,#0FFH
DELAY2:         DJNZ   R1,DELAY2
                DJNZ   R0,DELAY1
                RET 

END
            
 
                                        
