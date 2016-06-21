;���ͷ��� ����1 ~ ���ͷ��͸� �̿��� LED����1

          ORG      8000H

MAIN:     MOV      SP,#40H
          SETB     PX0    ; �ܺ� ���ͷ��� �켱���� SET        
          SETB     EX0    ; �ܺ� ���ͷ���0 �ο��̺�
          SETB     IT0    ; Edge Trigger MODE
          SETB     EA     ; ��ü ���ͷ��� �ο��̺�
 
LOOP:     MOV      P1,#0FFH  ; LED ����   
          CALL     DELAY 
          MOV      P1,#00H   ; LED �ѱ�
          CALL     DELAY
          JMP      LOOP 

SERVICE:  MOV      A,#11111110B ; ����⸦ �ʱ�ȭ.
LOOPS:    CALL     DELAY
          CALL     DELAY
          MOV      P1, A          ; �Ѱ��� LED�� ���� ��� �´�.
          RL       A              ; ���� LED �� �̵�  
          CJNE     A,#11111110B,LOOPS
          RETI 
          
DELAY:    MOV      R0,#0FFH
DELAY1:   MOV      R1,#0FFH
DELAY2:   DJNZ     R1,DELAY2
          DJNZ     R0,DELAY1  
          RET 

          ORG      9F03H
          JMP      SERVICE 

END