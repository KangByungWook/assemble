	  ORG    8000H 
LEDHOU    EQU    0FFC3H ; 시 표시 주소 
LEDMIN    EQU    0FFC2H ; 분 표시 주소
LEDSEC    EQU    0FFC1H ; 초 표시 주소

VSEC      EQU    30H    ; 시 저장 변수
VMIN      EQU    31H    ; 분 저장 변수
VHOUR     EQU    32H    ; 초 저장 변수

;*************************************************
;*  시간을 완벽하게 맞추기 위하여 각 패스에 대한 *
;*  딜레이 타임을 조사하고, 균형을 맞춤          *
;*************************************************

          MOV    VSEC,#0  ; 시,분,초 변수 초기화
          MOV    VMIN,#0
          MOV    VHOUR,#0
          CALL   DISPLAY  ; 00:00:00 부터 시계 동작 수행

RUN:      MOV    R2,#0008H 

DELAY3:   MOV    R1,#00FFH
DELAY2:   MOV    R0,#00E0H
DELAY1:   DJNZ   R0,DELAY1
          DJNZ   R1,DELAY2
          DJNZ   R2,DELAY3

;*************************************************
;*        DELAY 에서의 시간 지연 920064 주기     *
;*        1초는 921600 주기                      *
;*        921600 - 1 - 920064 - 56 = 1479        *
;*        1481 주기가 더 필요함                  *
;*************************************************
          MOV    R3,#147        ; 1 --> 1478= 37*40

REPEAT:   MOV    R1,#1          ; 1 
          LCALL  VALANCE        ; 2+ 2*1 + 3 = 7  
          DJNZ   R3,REPEAT      ; 2  
               
;*************************************************
;          1481 -1420 = 61                       *
;*************************************************
          MOV    R1,#1          ; 1
          LCALL  VALANCE        ; 2+2*1+3= 7

;*************************************************                
          CALL   UPDATE 
          SJMP   RUN            ; 56 CYCLE
;*************************************************

;CYCLE COUNT 1(FIRST LINE) + CONDITION 30 + DISPLAY 19 +  RET 2 
; = 52 CYCLE

UPDATE:   MOV    R0,#VSEC      
          CJNE   @R0,#59H,SEC   ; 초 단위 비교                  2;TOTAL 30
          MOV    @R0,#0         ; 초 저장 변수 초기화           1
          INC    R0             ; 분 단위 변수 지정             1
          MUL    AB             ; 실행 명령 주기를 맞추기 위해  4
          SJMP   MINCHECK       ; 분 단위 비교 루틴으로 분기    2:8

SEC:      MOV    R1,#7          ; 1                       
          LCALL  VALANCE        ; 2 , VALANCE: 2*7+3 = 17         :20
          SJMP   ADDONE         ; 증가 루틴으로 분기            2 :8
                         
MINCHECK: CJNE   @R0,#59H,MIN   ; 분 단위 비교                  2 ;TOTAL 20
          MOV    @R0,#0         ; 분 저장 변수 초기화           1
          INC    R0             ; 시 단위 변수 지정             1
          MUL    AB             ; 실행 명령 주기를 맞추기 위해  4
          SJMP   HOUCHECK       ; 시 단위 비교 루틴으로 분기    2 

MIN:      MOV    R1,#2          ; 1
          LCALL  VALANCE        ; 2 , VALANCE: 2*2+3 = 7
          SJMP   ADDONE         ; 증가 루틴으로 분기            2

HOUCHECK: CJNE   @R0,#23H,HOUR  ; 시 단위 비교                  2 ;TOTAL 10
          MOV    @R0 , #0       ; 시 저장 변수 초기화           1
          INC    R0             ; 실행 명령 주기를 맞추기 위해  1
          MUL    AB             ; 실행 명령 주기를 맞추기 위해  4
          JMP    RETPOINT       ; RETPOINT로 분기               2

HOUR:     JMP    ADDONE         ; 증가 루틴으로 분기              : 8 CYCLE   
                                      
RETPOINT: CALL   DISPLAY        ; 시계 동작 표시
          RET                   ; 상위 루틴으로 복귀

ADDONE:   MOV    A,@R0          ;                         1
           ; 해당하는 시,분,초 변수의 값을 읽어옴          
          ADD    A,#1           ; 변수의 값을 1 증가 시킴 1
          DA     A              ; 십진표시                1
          MOV    @R0,A          ; 해당하는 변수에 저장    1
          SJMP   RETPOINT       ; RETPOINT로 분기         2  == 6CYCLE
                          
;****************************************************
;      각 루틴간 시간 지연을 맞추기 위한 루틴       *
;              SPEND: R1*2+3                        *
;****************************************************
VALANCE:  DJNZ   R1,$           ; 2
          NOP                   ; 1 
          RET                   ; 2

;****************************************************
;*        서브 루틴: DISPLAY                        *
;*             입력: ACC                            * 
;*             출력: 6개의 7_SEGMENT                *
;*             기능: 시계 동작 표시                 *
;****************************************************
DISPLAY:  MOV   DPTR,#LEDSEC    ; 초 표시  
          MOV   A,VSEC            
          MOVX  @DPTR,A           

          MOV   DPTR,#LEDMIN    ; 분 표시 
          MOV   A, VMIN          
          MOVX  @DPTR,A          

          MOV   DPTR,#LEDHOU    ; 시 표시
          MOV   A,VHOUR        
          MOVX  @DPTR,A        
          RET                 

END