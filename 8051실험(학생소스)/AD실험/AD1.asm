; A/D ���� 1 ~
;     Function generator �� �̿� �Ͽ� analog ��ȣ�� �Է�����
;     A/D CONVERTER ����� �� ������ 2���� 7_SEGMENT�� ǥ��

SEGR      EQU     0FFC1H
ADC       EQU     0FFD0H

          ORG     8000H 

ADCON:    MOV     DPTR,#ADC
          MOVX    A,@DPTR     ;�Ƴ��α� ��ȣ �б�

          MOV     DPTR,#SEGR
          MOVX    @DPTR,A     ;��ȯ�� �� ǥ��
                        
          CALL    DELAY
          JMP     ADCON                   

DELAY:    MOV     R7,#0FFH
DELAY1:   MOV     R6,#0FFH
DELAY2:   DJNZ    R6,DELAY2
          DJNZ    R7,DELAY1
          RET                 
END
