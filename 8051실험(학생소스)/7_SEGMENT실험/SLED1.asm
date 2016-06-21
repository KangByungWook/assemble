;6 7_SEGMENT 실험1 ~  80 51 00 표시 하기

SEGL            EQU    0FFC3H
SEGM            EQU    0FFC2H
SEGR            EQU    0FFC1H

                ORG    8000H

                MOV    DPTR,#SEGL  ; 왼쪽 2개 선택
                MOV    A,#80H
                MOVX   @DPTR,A     ; 80 표시

                MOV    DPTR,#SEGM  ; 중간 2개 선택
                MOV    A,#51H
                MOVX   @DPTR,A     ; 51 표시

                MOV    DPTR,#SEGR  ; 오른쪽 2개 선택
                MOV    A,#00H
                MOVX   @DPTR,A     ; 00 표시

                JMP    $
END
            
 
                                        
