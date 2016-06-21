;삼중 루프 DELAY

          ORG      0000H
          MOV      R2,#0FFH ; 1주기
DELAY3:   MOV      R1,#0FFH ; 1주기
DELAY2:   MOV      R0,#0FFH ; 1주기
DELAY1:   DJNZ     R0,DELAY1; 2*R0 주기
          DJNZ     R1,DELAY2; (1+2*R0+2)*R1 주기 
          DJNZ     R2,DELAY3; (1+(1+2*R0+2)*R1+2)*R2 주기
          JMP      $