; ���ͷ��� ����2 ~ EXTERNAL INTERRUPT

          ORG      8000H

MAIN:     MOV      SP,#40H
          SETB     PX0    ; �ܺ� ���ͷ��� �켱���� SET        
          SETB     EX0    ; �ܺ� ���ͷ���0 �ο��̺�
          SETB     IT0    ; Edge Trigger MODE
          SETB     EA     ; ��ü ���ͷ��� �ο��̺�

LOOP:     MOV      A,#10101010B 
          MOV      P1,A
          CALL     DELAY  
          CPL      A
          MOV      P1,A
          CALL     DELAY 
          JMP      LOOP  

SERVICE:  MOV      A,#01111111B  ; ����⸦ �ʱ�ȭ.
LOOPS:    CALL     DELAY
          CALL     DELAY
          MOV      P1,A          ; �Ѱ��� LED�� ���� ��� �´�.
          RR       A             ; ���� LED �� �̵�  
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