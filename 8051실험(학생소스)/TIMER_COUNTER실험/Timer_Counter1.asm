;Ÿ�̸� ī���� ����1 ~  Ÿ�̸�0 ���1 �� �̿��� LED ���� ����

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
            MOV      P1,#00H  ; LED �ѱ�   
            
            MOV      TH0,#00H
            MOV      TL0,#00H
            SETB     TCON.TR0
            RETI 
           
LEDOFF:     CLR      C
            MOV      P1,#0FFH  ; LED ����
            
            MOV      TH0,#00H
            MOV      TL0,#00H
            SETB     TCON.TR0
            RETI 

            ORG      9F0BH
            JMP      SERVICE

END                  