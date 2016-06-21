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

RUN:      CALL   UPDATE   ; 다른 루틴에 사용하기 위하여 지연 파트와 분리 
          SJMP   RUN            

UPDATE:   MOV    R0,#VSEC    
          CJNE   @R0,#59H,SEC ; 초 단위 비교
          MOV    @R0,#0       ; 초 변수 초기화
          INC    R0           ; 분 단위 변수 지정
          SJMP   MINCHECK     ; 분 비교 루틴으로 분기

SEC:      SJMP   ADDONE       ; 증가 루틴으로 복귀
                         
MINCHECK: CJNE   @R0,#59H,MIN ; 분 단위 비교
          MOV    @R0 , #0     ; 분 변수 초기화
          INC    R0           ; 시 단위 변수 지정
          JMP    HOUCHECK     ; 시 비교 루틴으로 분기

MIN:      JMP    ADDONE       ; 증가 루틴으로 분기

HOUCHECK: CJNE   @R0,#23H,HOUR; 시 단위 비교
          MOV    @R0,#0       ; 시 변수 초기화 
         ;INC    R0           ; 필요없는 명령       
          JMP    RETPOINT     ; RETPOINT로 분기

HOUR:     JMP    ADDONE       ; 증가 루틴으로 분기


RETPOINT: CALL   DISPLAY      ; 시간 표시 루틴 호출
          RET                 ; 상위 루틴으로 복귀

ADDONE:   MOV    A,@R0        
          ; 해당하는 시,분,초 변수의 값을 읽어옴     
          ADD    A,#1         ; 변수의 값을 1 증가 시킴
          DA     A            ; 십진 표시
          MOV    @R0 , A      ; 해당하는 변수에 저장
          SJMP   RETPOINT     ; RETPOINT로 분기
                          
;****************************************************
;*        서브 루틴: DISPLAY                        *
;*             입력: ACC                            * 
;*             출력: 6개의 7_SEGMENT                *
;*             기능: 시계 동작 표시                 *
;****************************************************
DISPLAY:   MOV   DPTR,#LEDSEC    ; 초 표시  
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
