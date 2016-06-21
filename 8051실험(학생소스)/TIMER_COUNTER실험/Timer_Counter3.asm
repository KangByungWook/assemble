;타이머 카운터 실험3 ~ 타이머/카운터1 모드2 를 이용한 실험
 
            ORG      8000H

MAIN:       MOV      TMOD,#01100110B ;GATE =0,COUNTER MODE,MODE 10
            MOV      IE,#10001000B ;ENABLE ONLY TIMER 1 

            MOV      TH1,#0FFH           
            MOV      TL1,#0FFH             

            MOV      P1,#0FFH 
            MOV      A,#11111110B
            SETB     TCON.TR1                

            JMP      $

SERVICE:    MOV      P1,A
            CLR      C
            RLC      A
            JC       PATH1           ;다켜지 않았으면,PATH1으로 분기
            MOV      A,#11111111B ;모두 켜져있으면, 다음 동작에서는
                                     ; LED 를 모두 끈다.
PATH1:      SETB     TCON.4
            RETI 

            ORG      9F1BH           ; 타이머1 인터럽트 벡터
            JMP      SERVICE

END
