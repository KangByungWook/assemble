;1초간의  시간 지연 루틴 만들기

          ORG      0000H

          MOV      R2,#08H   ; 1주기
DELAY3:   MOV      R1,#0FFH  ; 1주기
DELAY2:   MOV      R0,#0E0H  ; 1주기
DELAY1:   DJNZ     R0,DELAY1 ; 2*R0 주기
          DJNZ     R1,DELAY2 ; (1+2*R0+2)*R1 주기 
          DJNZ     R2,DELAY3 ; {1+(1+2*R0+2)*R1+2}*R2 주기 
                             ; 1+920064=920065주기
                             
          MOV      R4,#07H   ; 1주기    
ADJUST2:  MOV      R3,#6CH   ; 1주기    
ADJUST1:  DJNZ     R3,ADJUST1; 2*R3 주기    
          DJNZ     R4,ADJUST2; (1+2*R3+2)*R4 주기   
                             ; 1+1533=1534주기
                             ; 921599주기
          NOP                ; 921600주기 
          JMP      $
