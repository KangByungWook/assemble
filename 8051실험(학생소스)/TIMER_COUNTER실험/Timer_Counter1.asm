;타이머 카운터 실험1 ~  타이머0 모드1 을 이용한 LED 제어 실험

            ORG      8000H

MAIN:       MOV      TMOD,#00000001B ;GATE =0,TIMER MODE,RUN MODE 01
            MOV      IE,#10000010B
            ;ENABLE ONLY TIMER 0 

            MOV      TH0,#00H           
            MOV      TL0,#00H             
            CLR      C
            SETB     TCON.TR0                

            JMP      $

SERVICE:    CLR      TCON.TR0
            JNC      LEDON         
            JMP      LEDOFF

LEDON:      SETB     C 
            MOV      P1,#00H  ; LED 켜기   
            
            MOV      TH0,#00H
            MOV      TL0,#00H
            SETB     TCON.TR0
            RETI 
           
LEDOFF:     CLR      C
            MOV      P1,#0FFH  ; LED 끄기
            
            MOV      TH0,#00H
            MOV      TL0,#00H
            SETB     TCON.TR0
            RETI 

            ORG      9F0BH
            JMP      SERVICE

END                  