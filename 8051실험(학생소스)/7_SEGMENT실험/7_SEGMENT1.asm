;7_SEGMENT ���� 1 ~  a~dot �� ������� �Ѵ� ���� 

SEVENSEG        EQU   0FFC0H       ; 7_SEGMENT �ּ�  
     
                ORG   8000H

START:          MOV   A,#11111111B ; 7_SEGMENT ����
                CLR   C            ; ĳ�� ��Ʈ Ŭ����

LOOP:           CALL  SEVENDIS     ; 7_SEGMENT ǥ�� ��ƾ ȣ��                
                CALL  DELAY        ; ���� �ð� ����
                RLC   A              
                JC    LOOP         ; ���� �κ� �̵�
                JMP   START        ; �ݺ� ���� ���� 
                                   ; 7_SEGMENT ǥ�� ��ƾ
SEVENDIS:       MOV   DPTR,#SEVENSEG   
                MOVX  @DPTR,A
                RET
                                   ; �ð� ���� ��ƾ                   
DELAY:          MOV   R0,#0FFH
DELAY1:         MOV   R1,#0FFH
DELAY2:         DJNZ  R1,DELAY2
                DJNZ  R0,DELAY1  
                RET  
END 