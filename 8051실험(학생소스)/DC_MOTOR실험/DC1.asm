; DC MOTOR ����1 ~  ��ȸ�� - ���� - ��ȸ�� 

          ORG      8000H

LOOP:     MOV      A,#00000110B ; ���� ��ȸ��
          CALL     MOTOR        

          CALL     DELAY        ; ���� �ð� ���� 

          MOV      A,#00000000B ; ���� ȸ�� ����                            
          CALL     MOTOR         
         
          CALL     DELAY
          CALL     DELAY        ; ���� �ð� ���� 
        
          MOV      A,#00000101B ; ���� ��ȸ�� 
          CALL     MOTOR         

          CALL     DELAY        ; ���� �ð� ���� 

          MOV      A,#00000000B ; ���� ȸ�� ����                                                 
          CALL     MOTOR                   

          CALL     DELAY
          CALL     DELAY        ; ���� �ð� ����               

          JMP      LOOP         ; �ݺ��� ���� �б�

;****************************************************
;*        ���� ��ƾ : MOTOR                         *
;*             �Է� ; A                             *
;*             ��� : ����                          *
;*             ��� : �Է¿� ���� ������ ��,��ȸ��  * 
;*                    ���� ���� ����                *
;****************************************************
MOTOR:    MOV      DPTR,#0FFEFH 
          MOVX     @DPTR,A
          RET
           
DELAY:    MOV      R7,#05H      ; �ð� ���� ��ƾ
DELAY1:   MOV      R6,#0FFH
DELAY2:   MOV      R5,#0FFH
DELAY3:   DJNZ     R5,DELAY3
          DJNZ     R6,DELAY2
          DJNZ     R7,DELAY1
          RET
END