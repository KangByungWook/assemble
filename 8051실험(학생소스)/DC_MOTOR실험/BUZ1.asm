BUZZER    EQU   0FFEFH

          ORG   8000H 

LOOP:     MOV   A,#10000000B
          CALL  BUZ
          CALL  DELAY

          MOV   A,#00000000B
          CALL  BUZ
          CALL  DELAY
          CALL  DELAY
           
          JMP   LOOP        

BUZ:      MOV   DPTR,#BUZZER 
          MOVX  @DPTR,A
          RET

DELAY:    MOV   R7,#0FFH
DELAY1:   MOV   R6,#0FFH
DELAY2:   DJNZ  R6,DELAY2
          DJNZ  R7,DELAY1
          RET 
END