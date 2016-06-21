;6 7_SEGMENT ����5 ~  00 00 00 ~ FF FF FF ī���� ����

SEGL            EQU    0FFC3H
SEGM            EQU    0FFC2H
SEGR            EQU    0FFC1H

                ORG    8000H
                
START:          MOV    R0,#00H
                MOV    R1,#00H
                MOV    R2,#00H        ; �ʱ�ȭ 
                
LOOP:           CALL   DIS            ; ǥ�� 
                CALL   DELAY          ; ���� �ð� ����

                CJNE   R0,#0FFH,PATH1 ; ������ 7_SEGMENT ��
                MOV    R0,#00H        ; FF �� RO �ʱ�ȭ

                CJNE   R1,#0FFH,PATH2 ; �߰� 7_SEGMENT ��
                MOV    R1,#00H        ; FF �� R1 �ʱ�ȭ

                CJNE   R2,#0FFH,PATH3 ; ���� 7_SEGMENT ��
                MOV    R2,#00H        ; FF �� R2 �ʱ�ȭ

                JMP    START

PATH1:          INC    R0             ; R0 1�� ����
                JMP    LOOP

PATH2:          INC    R1             ; R1 1�� ����
                JMP    LOOP

PATH3:          INC    R2             ; R2 1�� ����
                JMP    LOOP
                  
DIS:            MOV    A,R2           ; ǥ�� ��ƾ 
                MOV    DPTR,#SEGL
                MOVX   @DPTR,A

                MOV    A,R1
                MOV    DPTR,#SEGM
                MOVX   @DPTR,A

                MOV    A,R0
                MOV    DPTR,#SEGR
                MOVX   @DPTR,A
                RET
                                
DELAY:          MOV    R6,#80H       ; �ð� ���� ��ƾ
DELAY1:         MOV    R7,#80H
DELAY2:         DJNZ   R7,DELAY2
                DJNZ   R6,DELAY1
                RET 
END