;7_SEGMENT 실험 1 ~  a~dot 를 순서대로 켜는 실험 

SEVENSEG        EQU   0FFC0H       ; 7_SEGMENT 주소  
     
                ORG   8000H

START:          MOV   A,#11111111B ; 7_SEGMENT 끄기
                CLR   C            ; 캐리 비트 클리어

LOOP:           CALL  SEVENDIS     ; 7_SEGMENT 표시 루틴 호출                
                CALL  DELAY        ; 일정 시간 지연
                RLC   A              
                JC    LOOP         ; 다음 부분 이동
                JMP   START        ; 반복 동작 수행 
                                   ; 7_SEGMENT 표시 루틴
SEVENDIS:       MOV   DPTR,#SEVENSEG   
                MOVX  @DPTR,A
                RET
                                   ; 시간 지연 루틴                   
DELAY:          MOV   R0,#0FFH
DELAY1:         MOV   R1,#0FFH
DELAY2:         DJNZ  R1,DELAY2
                DJNZ  R0,DELAY1  
                RET  
END 