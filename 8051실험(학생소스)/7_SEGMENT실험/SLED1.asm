;6 7_SEGMENT ����1 ~  80 51 00 ǥ�� �ϱ�

SEGL            EQU    0FFC3H
SEGM            EQU    0FFC2H
SEGR            EQU    0FFC1H

                ORG    8000H

                MOV    DPTR,#SEGL  ; ���� 2�� ����
                MOV    A,#80H
                MOVX   @DPTR,A     ; 80 ǥ��

                MOV    DPTR,#SEGM  ; �߰� 2�� ����
                MOV    A,#51H
                MOVX   @DPTR,A     ; 51 ǥ��

                MOV    DPTR,#SEGR  ; ������ 2�� ����
                MOV    A,#00H
                MOVX   @DPTR,A     ; 00 ǥ��

                JMP    $
END
            
 
                                        
