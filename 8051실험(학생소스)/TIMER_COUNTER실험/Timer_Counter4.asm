;타이머/카운터를 이용한 실험 ~ 타이머/카운터1 모드2 를 이용한 실험

SEGR        EQU      0FFC3H
SEGM        EQU      0FFC2H
SEGL        EQU      0FFC1H
 
            ORG      8000H
         
MAIN:       MOV      A,#00H          
            CALL     CLEAR          ; 초기화 

	    MOV      TMOD,#01100110B; GATE =0,COUNTER MODE,MODE 10
            MOV      IE,#10001000B  ; ENABLE ONLY TIMER 1 

            MOV      TH1,#0FFH           
            MOV      TL1,#0FFH      ; 타이머 레지스터 세팅

            SETB     TCON.TR1       ; 타이머 동작          

            JMP      $

SERVICE:    CALL     DIS            
            INC      A              

            CJNE     A,#0FFH,PATH1
            MOV      A,#00H

PATH1:      SETB     TCON.4
            RETI 

CLEAR:      MOV      DPTR,#SEGR
            MOVX     @DPTR,A
            MOV      DPTR,#SEGM
            MOVX     @DPTR,A       

DIS:        MOV      DPTR,#SEGL
            MOVX     @DPTR,A
            RET

            ORG      9F1BH          ; 타이머1 인터럽트 벡터  
            JMP      SERVICE

END