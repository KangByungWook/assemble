;         LED ����3 ~ ������� ON/OFF

          ORG   8000H

          MOV   A,#11111110B ; ����⸦ �ʱ�ȭ.

LOOP:     MOV   P1,A         ; �Ѱ��� LED�� ���� ��� �´�.
          RL    A            ; ���� LED �� �̵�  
          CALL  DELAY
          JMP   LOOP
          
DELAY:    MOV   R0,#0FFH     ; ���� �ð� ���� 
DELAY1:   MOV   R1,#0FFH
DELAY2:   DJNZ  R1,DELAY2
          DJNZ  R0,DELAY1
          RET 
END                         