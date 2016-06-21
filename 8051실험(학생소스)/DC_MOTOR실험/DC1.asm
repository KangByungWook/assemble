; DC MOTOR 실험1 ~  정회전 - 정지 - 역회전 

          ORG      8000H

LOOP:     MOV      A,#00000110B ; 모터 정회전
          CALL     MOTOR        

          CALL     DELAY        ; 일정 시간 지연 

          MOV      A,#00000000B ; 모터 회전 정지                            
          CALL     MOTOR         
         
          CALL     DELAY
          CALL     DELAY        ; 일정 시간 지연 
        
          MOV      A,#00000101B ; 모터 역회전 
          CALL     MOTOR         

          CALL     DELAY        ; 일정 시간 지연 

          MOV      A,#00000000B ; 모터 회전 정지                                                 
          CALL     MOTOR                   

          CALL     DELAY
          CALL     DELAY        ; 일정 시간 지연               

          JMP      LOOP         ; 반복을 위한 분기

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
           
DELAY:    MOV      R7,#05H      ; 시간 지연 루틴
DELAY1:   MOV      R6,#0FFH
DELAY2:   MOV      R5,#0FFH
DELAY3:   DJNZ     R5,DELAY3
          DJNZ     R6,DELAY2
          DJNZ     R7,DELAY1
          RET
END