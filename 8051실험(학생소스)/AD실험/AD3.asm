; A/D 실험3 ~ 거리 측정 실험

DAC       EQU      0FFD1H
ADC       EQU      0FFD0H

          ORG      8000H 
                                      
LOOP:     MOV      DPTR,#0FFFFH
          MOV      A,#01H
          MOVX     @DPTR,A    ; 발광소자 동작.
                   
          MOV      DPTR,#ADC
          MOVX     A,@DPTR    ; A/D 입력을 읽기

          MOV      R0,A

          CALL     PORT       ; 포트1의 LED로 결과 표시
          CALL     DELAY
          JMP      LOOP

PORT:     CLR      C
CHECK1:   MOV      A,R0
          CJNE     A,#00H,CHECK2   
          MOV      P1,#11111111B
          RET 

CHECK2:   CJNE     A,#00010000B,CHECK3
          MOV      P1,#11111110B
          RET

CHECK3:   JNC      CHECK4
          CLR      C 
          MOV      P1,#11111110B
          RET

CHECK4:   CJNE     A,#00100000B,CHECK5
          MOV      P1,#11111100B
          RET

CHECK5:   JNC      CHECK6
          CLR      C
          MOV      P1,#11111100B
          RET

CHECK6:   CJNE     A,#00110000B,CHECK7
          MOV      P1,#11111000B
          RET

CHECK7:   JNC      CHECK8
          CLR      C
          MOV      P1,#11111000B
          RET

CHECK8:   CJNE     A,#01000000B,CHECK9
          MOV      P1,#11110000B
          RET

CHECK9:   JNC      CHECK10
          CLR      C
          MOV      P1,#11110000B
          RET

CHECK10:  CJNE     A,#01010000B,CHECK11
          MOV      P1,#11100000B
          RET

CHECK11:  JNC      CHECK12
          CLR      C
          MOV      P1,#11100000B
          RET

CHECK12:  CJNE     A,#01100000B,CHECK13
          MOV      P1,#11000000B
          RET

CHECK13:  JNC      CHECK14
          CLR      C
          MOV      P1,#11000000B
          RET

CHECK14:  CJNE     A,#01110000B,CHECK15
          MOV      P1,#10000000B
          RET

CHECK15:  JNC      CHECK16
          CLR      C
          MOV      P1,#10000000B
          RET

CHECK16:  CJNE     A,#111111111B,CHECK17
          MOV      P1,#00000000B
          RET

CHECK17:  MOV      P1,#10000000B
          RET

DELAY:    MOV      R6,#0FFH 
DELAY1:   MOV      R7,#0FFH
DELAY2:   DJNZ     R7,DELAY2
          DJNZ     R6,DELAY1
          RET
END                       
                   
                 