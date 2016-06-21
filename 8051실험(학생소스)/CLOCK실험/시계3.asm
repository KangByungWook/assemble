;*************************************************************
;* 시간을 정확히 맞추기 위해 최대한 소스 라인을 줄임.        *
;*************************************************************

    	  ORG     0000H 
LEDHOU    EQU     0FFC3H  ; 시 표시 7_SEGMENT 주소
LEDMIN    EQU     0FFC2H  ; 분 표시 7_SEGMENT 주소
LEDSEC    EQU     0FFC1H  ; 초 표시 7_SEGMENT 주소

VSEC      EQU     30H     ; 초(SEC) 변화값 저장 
VMIN      EQU     31H     ; 분(MIN) 변화값 저장
VHOUR     EQU     32H     ; 시(HOU) 변화값 저장 
        
          MOV     VSEC,#0 ; 시,분,초 변수 초기화
          MOV     VMIN,#0
          MOV     VHOUR,#0
          CALL    DISPLAY ; 00:00:00 부터 시계 동작 수행

RUN:      CALL    UPDATE  ; 다른 루틴에 사용하기 위하여 지연 파트와 분리 
          SJMP    RUN            

UPDATE:   MOV     R0,#VSEC; 균형을 맞추기 위하여 
                          ; R0를 사용하여 간접 주소 지정을 하고
                          ; 다른 패스간의 차이를 최소화 함.

          CJNE    @R0,#59H,SEC ; 초 단위 비교                2
          MOV     @R0,#0       ; 초 저장 변수 초기화         1
          INC     R0           ; 분 단위 변수 지정           1   
          SJMP    MINCHECK     ; 분 단위 비교 루틴으로 분기  2   

SEC:      SJMP    ADDONE       ; 증가 루틴으로 분기          2 
                         
MINCHECK: CJNE    @R0,#59H,MIN ; 분 단위 비교                2
          MOV     @R0 , #0     ; 분 단위 저장 변수 초기화    1
          INC     R0           ; 시 단위 변수 지정           1
          JMP     HOUCHECK     ; 시 단위 비교 루틴으로 분기  2 

MIN:      JMP     ADDONE       ; 증가 루틴으로 분기          2

HOUCHECK: CJNE    @R0,#23H,HOUR; 시 단위 비교                2
          MOV     @R0 , #0     ; 시 단위 저장 변수 초기화    1
          ;INC    R0           ; 필요 업는 명령어         
          JMP     RETPOINT     ; RETPOINT로 분기             2

HOUR:     JMP     ADDONE       ; 증가 루틴으로 분기


RETPOINT: CALL    DISPLAY      ; 시간 표시 루틴 호출
          RET                  ; 상위 루틴 복귀 

ADDONE:   MOV     A,@R0      
          ; 해당하는 시,분,초 변수의 값을 읽어옴             1
          ADD     A,#1         ; 변수의 값을 1 증가 시킴     1
          DA      A            ; 십진표시                    1
          MOV     @R0,A        ; 해당하는 변수에 저장        1
          SJMP    RETPOINT     ; RETPOINT로 분기             2  
                          

;****************************************************
;*        서브 루틴: DISPLAY                        *
;*             입력: ACC                            * 
;*             출력: 6개의 7_SEGMENT                *
;*             기능: 시계 동작 표시                 *
;****************************************************
DISPLAY:  MOV     DPTR,#LEDSEC ; 초 표시
          MOV     A, VSEC           
          MOVX    @DPTR,A           

          MOV     DPTR,#LEDMIN ; 분 표시
          MOV     A,VMIN            
          MOVX    @DPTR,A           

          MOV     DPTR,#LEDHOU ; 시 표시 
          MOV     A,VHOUR           
          MOVX    @DPTR,A           
          RET                       
          
END
