;Ÿ�̸� ī���� ����3 ~ Ÿ�̸�/ī����1 ���2 �� �̿��� ����
 
            ORG      8000H

MAIN:       MOV      TMOD,#01100110B ;GATE =0,COUNTER MODE,MODE 10
            MOV      IE,#10001000B ;ENABLE ONLY TIMER 1 

            MOV      TH1,#0FFH           
            MOV      TL1,#0FFH             

            MOV      P1,#0FFH 
            MOV      A,#11111110B
            SETB     TCON.TR1                

            JMP      $

SERVICE:    MOV      P1,A
            CLR      C
            RLC      A
            JC       PATH1           ;������ �ʾ�����,PATH1���� �б�
            MOV      A,#11111111B ;��� ����������, ���� ���ۿ�����
                                     ; LED �� ��� ����.
PATH1:      SETB     TCON.4
            RETI 

            ORG      9F1BH           ; Ÿ�̸�1 ���ͷ�Ʈ ����
            JMP      SERVICE

END
