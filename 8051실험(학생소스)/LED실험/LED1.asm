;      LED ����1 ~ ON/OFF
          ORG   8000H
LOOP:     MOV   P1,#00H     ; LED �ѱ�   
          CALL  DELAY       ; ���� �ð� ���� 
          MOV   P1,#0FFH    ; LED ����
          CALL  DELAY       ; ���� �ð� ����
          JMP   LOOP        ; �ݺ��� ���� �б�

DELAY:    MOV   R7,#0FFH  ; �ð� ���� ��ƾ 
DELAY1:   MOV   R6,#0FFH
DELAY2:   DJNZ  R6,DELAY2
          DJNZ  R7,DELAY1  
          RET
END