;���� ���� DELAY

          ORG      0000H
          MOV      R1,#0FFH ; 1�ֱ�
DELAY1:   MOV      R0,#0FFH ; 1�ֱ�
DELAY2:   DJNZ     R0,DELAY2; 2*R0 �ֱ�
          DJNZ     R1,DELAY1; (1+2*R0+2)*R1 �ֱ� 
          JMP      $