;1�ʰ���  �ð� ���� ��ƾ �����

          ORG      0000H

          MOV      R2,#08H   ; 1�ֱ�
DELAY3:   MOV      R1,#0FFH  ; 1�ֱ�
DELAY2:   MOV      R0,#0E0H  ; 1�ֱ�
DELAY1:   DJNZ     R0,DELAY1 ; 2*R0 �ֱ�
          DJNZ     R1,DELAY2 ; (1+2*R0+2)*R1 �ֱ� 
          DJNZ     R2,DELAY3 ; {1+(1+2*R0+2)*R1+2}*R2 �ֱ� 
                             ; 1+920064=920065�ֱ�
                             
          MOV      R4,#07H   ; 1�ֱ�    
ADJUST2:  MOV      R3,#6CH   ; 1�ֱ�    
ADJUST1:  DJNZ     R3,ADJUST1; 2*R3 �ֱ�    
          DJNZ     R4,ADJUST2; (1+2*R3+2)*R4 �ֱ�   
                             ; 1+1533=1534�ֱ�
                             ; 921599�ֱ�
          NOP                ; 921600�ֱ� 
          JMP      $
