;6 7_SEGMENT 실험5 ~  00 00 00 ~ FF FF FF 카운터 동작

SEGL            EQU    0FFC3H
SEGM            EQU    0FFC2H
SEGR            EQU    0FFC1H

                ORG    8000H
                
START:          MOV    R0,#00H
                MOV    R1,#00H
                MOV    R2,#00H        ; 초기화 
                
LOOP:           CALL   DIS            ; 표시 
                CALL   DELAY          ; 일정 시간 지연

                CJNE   R0,#0FFH,PATH1 ; 오른쪽 7_SEGMENT 비교
                MOV    R0,#00H        ; FF 면 RO 초기화

                CJNE   R1,#0FFH,PATH2 ; 중간 7_SEGMENT 비교
                MOV    R1,#00H        ; FF 면 R1 초기화

                CJNE   R2,#0FFH,PATH3 ; 왼쪽 7_SEGMENT 비교
                MOV    R2,#00H        ; FF 면 R2 초기화

                JMP    START

PATH1:          INC    R0             ; R0 1씩 증가
                JMP    LOOP

PATH2:          INC    R1             ; R1 1씩 증가
                JMP    LOOP

PATH3:          INC    R2             ; R2 1씩 증가
                JMP    LOOP
                  
DIS:            MOV    A,R2           ; 표시 루틴 
                MOV    DPTR,#SEGL
                MOVX   @DPTR,A

                MOV    A,R1
                MOV    DPTR,#SEGM
                MOVX   @DPTR,A

                MOV    A,R0
                MOV    DPTR,#SEGR
                MOVX   @DPTR,A
                RET
                                
DELAY:          MOV    R6,#80H       ; 시간 지연 루틴
DELAY1:         MOV    R7,#80H
DELAY2:         DJNZ   R7,DELAY2
                DJNZ   R6,DELAY1
                RET 
END