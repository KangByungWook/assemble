;      LED 실험1 ~ ON/OFF
          ORG   8000H
LOOP:     MOV   P1,#00H     ; LED 켜기   
          CALL  DELAY       ; 일정 시간 지연 
          MOV   P1,#0FFH    ; LED 끄기
          CALL  DELAY       ; 일정 시간 지연
          JMP   LOOP        ; 반복을 위한 분기

DELAY:    MOV   R7,#0FFH  ; 시간 지연 루틴 
DELAY1:   MOV   R6,#0FFH
DELAY2:   DJNZ  R6,DELAY2
          DJNZ  R7,DELAY1  
          RET
END