; 외부 인터럽트 실험3 ~ Single Step Operation

          ORG   8000H

MAIN:     MOV   SP,#40H
          SETB  PX0  ; 외부 인터럽트 우선 순위 SET
          SETB  EX0  ; 외부 인터럽트0 인에이블 
          SETB  IT0  ; Edge Trigger Mode
          SETB  EA   ; 전체 인터럽트 인에이블 
          JB    P3.2,$ ; Sigle Step Operation 대기

PORT1:    MOV   A,#11111110B
LOOP1:    MOV   P1,A
          CLR   C
          RLC   A
          CJNE  A,#00000000B,LOOP1
LOOP2:    MOV   P1,A
          SETB  C
          RRC   A
          CJNE  A,#11111111B,LOOP2
          MOV   P1,A
          JMP   PORT1

SERVICE:  JNB   P3.2,$
          JB    P3.2,$
          RETI

          ORG      9F03H
          JMP      SERVICE 

END    