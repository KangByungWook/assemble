; 6���� 7_SEGMENT�� ���� �̱�

SEGL            EQU    0FFC3H
SEGM            EQU    0FFC2H
SEGR            EQU    0FFC1H

                ORG    8000H
                
LOOP:           MOV    A,#00H      ; �ѱ� 
                CALL   SEG
                CALL   DELAY
                call   delay
                
                MOV    A,#0FFH     ; ����
                CALL   SEG
                CALL   DELAY
                call   delay
               
                JMP    LOOP

SEG:            MOV    DPTR,#SEGL  ;���� 2�� ����
                MOVX   @DPTR,A      

                MOV    DPTR,#SEGM  ;�߰� 2�� ����
                MOVX   @DPTR,A     

                MOV    DPTR,#SEGR  ;������ 2�� ����
                MOVX   @DPTR,A     
                RET

DELAY:          MOV    R0,#0FFH
DELAY1:         MOV    R1,#0FFH
DELAY2:         DJNZ   R1,DELAY2
                DJNZ   R0,DELAY1
                RET 

END
            
 
                                        
