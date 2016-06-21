; DC MOTOR 실험2 ~  DC 모터 등가속-> 등감속 실험
TEMP      EQU      20H 
MODE      EQU      21H
 
          ORG      8000H

          MOV      TEMP,#01H
          MOV      MODE,#01H

M_ON:     MOV      A,#00000110B
          CALL     MOTOR         ; 모터 정회전
                
START:    CALL     DINC          ; 정회전 시간

          MOV      A,MODE        
          JNB      A.0,DECR               
 
INCR:     SETB     MODE.0        ; 정회전 시간 증가 모드 
                                 ; MODE.0 = 1

          MOV      A,TEMP
          ADD      A,#01H 
          MOV      TEMP,A        ; 정회전 시간을 증가 시킴                              

          CJNE     A,#80H,STOP   ; 모터 정지 루틴으로 분기   

DECR:     CLR      MODE.0        ; 정회전 시간 감소 모드 
                                 ; MODE.0 = 0

          MOV      A,TEMP
          SUBB     A,#01H
          MOV      TEMP,A        ; 정회전 시간을 감소 시킴     

          CJNE     A,#00H,STOP   ; 모터 정지 루틴으로 분기 

          JMP      INCR

STOP:     MOV      A,#00000000B  ; 모터 회전 정지
          CALL     MOTOR
          CALL     DSTOP         ; 회전 정지 시간 
          JMP      M_ON               
 
DINC:     MOV      R7,TEMP
DINC1:    MOV      R6,#0FFH
DINC2:    DJNZ     R6,DINC2
          DJNZ     R7,DINC1
          RET

DSTOP:    MOV      R4,#0FFH 
DSTOP1:   MOV      R5,#0FFH
DSTOP2:   DJNZ     R5,DSTOP2
          DJNZ     R4,DSTOP1
          RET

;****************************************************
;*        서브 루틴 : MOTOR                         *
;*             입력 ; A                             *
;*             출력 : 없음                          *
;*             기능 : 입력에 따라 모터의 정,역회전  * 
;*                    정지 동작 수행                *
;****************************************************
MOTOR:    MOV      DPTR,#0FFEFH 
          MOVX     @DPTR,A
          RET

END