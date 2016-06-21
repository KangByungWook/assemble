;         LED 실험3 ~ 순서대로 ON/OFF

          ORG   8000H

          MOV   A,#11111110B ; 누산기를 초기화.

LOOP:     MOV   P1,A         ; 한개의 LED에 불이 들어 온다.
          RL    A            ; 다음 LED 로 이동  
          CALL  DELAY
          JMP   LOOP
          
DELAY:    MOV   R0,#0FFH     ; 일정 시간 지연 
DELAY1:   MOV   R1,#0FFH
DELAY2:   DJNZ  R1,DELAY2
          DJNZ  R0,DELAY1
          RET 
END                         