; DA 실험 1 ~ 사각형파 만들기

                ORG   8000H
         
LOOP:           MOV   A,#00H  ; 00000000 ~ 0[V] 변환                                            
                CALL  DACONVERT
                CALL  DELAY
                MOV   A,#0FFH ; 11111111 ~ 5[V] 변환
                CALL  DACONVERT
                CALL  DELAY
                JMP   LOOP

DACONVERT:      MOV   DPTR,#0FFD1H
                MOVX  @DPTR,A  ; D/A 변환 쓰기
                RET

DELAY:          MOV   R7,#10H
DELAY1:         MOV   R6,#0FFH
DELAY2:         DJNZ  R6,DELAY2
                DJNZ  R7,DELAY1
                RET           
END
         