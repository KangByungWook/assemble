;이중 루프 DELAY

          ORG      0000H
          MOV      R1,#0FFH ; 1주기
DELAY1:   MOV      R0,#0FFH ; 1주기
DELAY2:   DJNZ     R0,DELAY2; 2*R0 주기
          DJNZ     R1,DELAY1; (1+2*R0+2)*R1 주기 
          JMP      $