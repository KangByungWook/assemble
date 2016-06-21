; DC MOTOR ����2 ~  DC ���� ���-> ��� ����
TEMP      EQU      20H 
MODE      EQU      21H
 
          ORG      8000H

          MOV      TEMP,#01H
          MOV      MODE,#01H

M_ON:     MOV      A,#00000110B
          CALL     MOTOR         ; ���� ��ȸ��
                
START:    CALL     DINC          ; ��ȸ�� �ð�

          MOV      A,MODE        
          JNB      A.0,DECR               
 
INCR:     SETB     MODE.0        ; ��ȸ�� �ð� ���� ��� 
                                 ; MODE.0 = 1

          MOV      A,TEMP
          ADD      A,#01H 
          MOV      TEMP,A        ; ��ȸ�� �ð��� ���� ��Ŵ                              

          CJNE     A,#80H,STOP   ; ���� ���� ��ƾ���� �б�   

DECR:     CLR      MODE.0        ; ��ȸ�� �ð� ���� ��� 
                                 ; MODE.0 = 0

          MOV      A,TEMP
          SUBB     A,#01H
          MOV      TEMP,A        ; ��ȸ�� �ð��� ���� ��Ŵ     

          CJNE     A,#00H,STOP   ; ���� ���� ��ƾ���� �б� 

          JMP      INCR

STOP:     MOV      A,#00000000B  ; ���� ȸ�� ����
          CALL     MOTOR
          CALL     DSTOP         ; ȸ�� ���� �ð� 
          JMP      M_ON               
 
DINC:     MOV      R7,TEMP
DINC1:    MOV      R6,#0FFH
DINC2:    DJNZ     R6,DINC2
          DJNZ     R7,DINC1
          RET

DSTOP:    MOV      R4,#0FFH 
DSTOP1:   MOV      R5,#0FFH
DSTOP2:   DJNZ     R5,DSTOP2
          DJNZ     R4,DSTOP1
          RET

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

END