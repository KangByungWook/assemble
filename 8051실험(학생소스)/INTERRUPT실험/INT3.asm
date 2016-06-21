; �ܺ� ���ͷ�Ʈ ����3 ~ Single Step Operation

          ORG   8000H

MAIN:     MOV   SP,#40H
          SETB  PX0  ; �ܺ� ���ͷ�Ʈ �켱 ���� SET
          SETB  EX0  ; �ܺ� ���ͷ�Ʈ0 �ο��̺� 
          SETB  IT0  ; Edge Trigger Mode
          SETB  EA   ; ��ü ���ͷ�Ʈ �ο��̺� 
          JB    P3.2,$ ; Sigle Step Operation ���

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