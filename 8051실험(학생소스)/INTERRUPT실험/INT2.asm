; 인터럽터 실험2 ~ EXTERNAL INTERRUPT

          ORG      8000H

MAIN:     MOV      SP,#40H
          SETB     PX0    ; 외부 인터럽터 우선순위 SET        
          SETB     EX0    ; 외부 인터럽터0 인에이블
          SETB     IT0    ; Edge Trigger MODE
          SETB     EA     ; 전체 인터럽터 인에이블

LOOP:     MOV      A,#10101010B 
          MOV      P1,A
          CALL     DELAY  
          CPL      A
          MOV      P1,A
          CALL     DELAY 
          JMP      LOOP  

SERVICE:  MOV      A,#01111111B  ; 누산기를 초기화.
LOOPS:    CALL     DELAY
          CALL     DELAY
          MOV      P1,A          ; 한개의 LED에 불이 들어 온다.
          RR       A             ; 다음 LED 로 이동  
          CJNE     A,#01111111B,LOOPS
          RETI 
          
DELAY:    MOV      R0,#0FFH
DELAY1:   MOV      R1,#0FFH
DELAY2:   DJNZ     R1,DELAY2
          DJNZ     R0,DELAY1  
          RET 

          ORG      9F03H
          JMP      SERVICE 

END