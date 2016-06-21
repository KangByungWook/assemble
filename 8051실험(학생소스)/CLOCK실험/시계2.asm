;***********************************************************
;*       다른 모뮬에 붙이기 위해                           *
;*       시간 업데이트 부분 만을 분리                      *
;***********************************************************
;PROGRAMMED BY KIM HYUNG SOO

	  ORG     8000H         

LEDHOU    EQU     0FFC3H    ; 시 표시 주소
LEDMIN    EQU     0FFC2H    ; 분 표시 주소
LEDSEC    EQU     0FFC1H    ; 초 표시 주소

INIT:     MOV     R5,#0
          MOV     R6,#0
          MOV     R7,#0

CLOCK:    CALL    UPDATE
          SJMP    CLOCK
                
;***********************************************************
;        시간 표시 변화 루틴                               *
;***********************************************************
UPDATE:   CALL    DISPLAY        ; 업데이트된 시간 표시

          CJNE    R5,#59H,SEC    ; 초 단위 비교
          MOV     R5,#0          ; 초 변수 R5 초기화
           
          CJNE    R6,#59H,MIN    ; 분 단위 비교
          MOV     R6,#0          ; 분 변수 R6 초기화

          CJNE    R7,#23H,HOUR   ; 시 단위 비교
          MOV     R7,#0          ; 시 변수 R7 초기화

RETPOINT: RET                     ; 상위 루틴 복귀
                          
;**********************************************************
;        시,분,초 업데이트 루틴                           *
;**********************************************************
SEC:      MOV     A,R5           
          ADD     A,#1H          ; 초 단위 증가
          DA      A              ; 십진화 표현
          MOV     R5,A             
          SJMP    RETPOINT       ; RETPOINT 로 분기
                                
MIN:      MOV     A,R6     
          ADD     A,#1H          ; 분 단위 증가
          DA      A              ; 십진화 표현
          MOV     R6,A              
          SJMP    RETPOINT       ; RETPOINT 로 분기   
                
HOUR:     MOV     A,R7       
          ADD     A,#1H          ; 시 단위 증가
          DA      A              ; 십진화 표현
          MOV     R7,A       
          SJMP    RETPOINT       ; RETPOINT 로 분기

;*********************************************************
;*        서브 루틴: DISPLAY                             *
;*             입력: ACC                                 *
;*             출력; 6 개의 7_SEGMENT                    *
;*             기능: 6 개의 7_SEGMENT 에 시간 표시       *
;*                   프로그램 사이즈를 줄이고 컨트롤을   *
;*                   용이 하게 하기 위하여               *
;*                   표시 루틴을 하나로 합침             *
;*        단점 : R5~R7를 항상 디스플레이 변수로 사용     *
;*********************************************************
DISPLAY:  MOV     DPTR,#LEDSEC    ; 초 표시
          MOV     A, R5              
          MOVX    @DPTR,A           

          MOV     DPTR,#LEDMIN    ; 분 표시 
          MOV     A, R6           
          MOVX    @DPTR,A         

          MOV     DPTR,#LEDHOU    ; 시 표시 
          MOV     A, R7           
          MOVX    @DPTR,A         
          RET                    

END