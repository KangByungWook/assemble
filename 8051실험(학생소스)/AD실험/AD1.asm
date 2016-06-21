; A/D 실험 1 ~
;     Function generator 를 이용 하여 analog 신호를 입력하자
;     A/D CONVERTER 출력을 맨 오른쪽 2개의 7_SEGMENT로 표시

SEGR      EQU     0FFC1H
ADC       EQU     0FFD0H

          ORG     8000H 

ADCON:    MOV     DPTR,#ADC
          MOVX    A,@DPTR     ;아날로그 신호 읽기

          MOV     DPTR,#SEGR
          MOVX    @DPTR,A     ;변환된 값 표시
                        
          CALL    DELAY
          JMP     ADCON                   

DELAY:    MOV     R7,#0FFH
DELAY1:   MOV     R6,#0FFH
DELAY2:   DJNZ    R6,DELAY2
          DJNZ    R7,DELAY1
          RET                 
END
