; 키 패드 인터페이스 실험1 
          ORG      8000H   
DATAOUT   EQU      0FFF0H  ;데이터 아웃의 주소
DATAIN    EQU      0FFF1H  ;데이터 인의 주소
DLED      EQU      0FFC1H  ;오른쪽 2개의 7_SEGMENT 주소
ALED0     EQU      0FFC2H  ;중간 2개의 7_SEGMENT 주소
ALED1     EQU      0FFC3H  ;왼쪽 2개의 7_SEGMENT 주소
BUZZER    EQU      0FFEFH

LOOP:     CALL     SCANN   ; 스캔 루틴 호출 
          JMP      LOOP    ; 반복 수행을 위한 분기 

;키 패드 인터페이스 예제

SCANN:     PUSH     PSW     ; PSW 값을 스택에 보관
           SETB     PSW.4   ; 뱅크3 레지스터 사용
           SETB     PSW.3

INITIAL:   MOV      R1,#00H       ; R1의 초기화
           MOV      A,#11101111B  ; 데이터 아웃의 초기값

COLSCAN:   MOV      R0,A          ; R0에 데이터 아웃 값 보관 
           INC      R1            ; R1 열의 값 보관 
           CALL     SUBKEY        ; 키 패드 입력 상태 조사
           ANL      A,#00011111B  ; 상위 3비트 제거
           XRL      A,#00011111B  ; XRL 연산000111111
           JNZ      RSCAN         ; 누산기 값이 0 이 아니면, 행 스캔
           MOV      A,R0           
           SETB     C
           RRC      A             ; 다음 열로 이동
           JNC      INITIAL       ; 모든 열을 스캔했으면, 다시 시작 
           JMP      COLSCAN       ; 다음 열의 스캔을 위한 분기


RSCAN:     MOV      R2,#00H       ; R2 행의 값 보관
ROWSCAN:   RRC      A             ; 어느 행이 "1" 로 바뀌었는지 조사
           JC       MATRIX        ; 캐리가 발생하면, MATRIX로 분기
           INC      R2            ; 캐리가 발생하지 않으면, 다음 행으로 이동
           JMP      ROWSCAN       ; 다음 행의 스캔을 위한 분기

MATRIX:    MOV      A,R2          ; R2 에는 행의 값 보존
           MOV      B,#05H        ; 1행은 5열로 이루어짐
           MUL      AB            ; 2차원 배열을 1차원 배열로 값을 바꿈
           ADD      A,R1          ; R1 에는 열의 값 보존
           CALL     INDEX         ; 키 코드 값을 지정
           CALL     DISPLAY       ; 키 코드 값의 표시 
           MOV      A,#80H
           CALL     BUZ
           CALL     DELAY
           MOV      A,#00H
           CALL     BUZ
            
           POP      PSW           ; 스택으로 부터 PSW값을 가지고 옴
           RET                    ; 상위 루틴으로 복귀


;*****************************************************************
;*         서브 루틴 : SUBKEY                                    *
;*              입력 : ACC                                       *
;*              출력 : ACC                                       *
;*              기능 : 데이터 아웃으로 데이터를 내보내고         *
;*                     데이터 인으로 결과를 확인                 * 
;*****************************************************************
SUBKEY:    MOV      DPTR,#DATAOUT
           MOVX     @DPTR,A
           MOV      DPTR,#DATAIN
           MOVX     A,@DPTR
           RET

;*****************************************************************
;*         서브 루틴 : DISPLAY                                   *
;*              입력 : ACC                                       *
;*              출력 : ACC                                       *
;*              기능 : 키 코드값을 7_SEGMENT 로 표시             *
;*****************************************************************
DISPLAY:   MOV      DPTR,#DLED
           MOVX     @DPTR,A
           RET

;*****************************************************************
;*         서브 루틴 : INDEX                                     *
;*              입력 : ACC                                       *
;*              출력 : ACC                                       *
;*              기능 : 키 코드값을 정의                          * 
;*****************************************************************
;DEFINE  FUNCTION KEY

RWKEY      EQU     10H ;READ AND WRITE KEY
INCKEY     EQU     11H ;INCRESE KEY(COMMA ,)
ENDKEY     EQU     12H ;END KEY (PERIOD . )
GO         EQU     13H ;GO-KEY
REG        EQU     14H ;REGISTER KEY
DECKEY     EQU     15H ;DECRESE KEY
CODE       EQU     16H ;CODE KEY
ST         EQU     17H ;SINGLE STEP KEY
RST        EQU     18H ;RST KEY

INDEX:     MOVC    A,@A+PC     ;A IS FROM 1 TO 24
           RET

KEYBASE:   DB ST            ;SW1,ST                  1
           DB CODE          ;SW6,CODE                2
           DB DECKEY        ;SW11,CD                 3
           DB REG           ;SW15,REG                4
           DB GO            ;SW19,GO                 5
           DB 0CH           ;SW2,C                   6
           DB 0DH           ;SW7,D                   7
           DB 0EH           ;SW12,E                  8
           DB 0FH           ;SW16,F                  9
           DB INCKEY        ;SW20,COMMA (,)         10
           DB 08H           ;SW3,8                  11
           DB 09H           ;SW8,9                  12
           DB 0AH           ;SW13,A                 13
           DB 0BH           ;SW17,B                 14
           DB ENDKEY        ;SW21,PERIOD(.)         15
           DB 04H           ;SW4,4                  16
           DB 05H           ;SW9,5                  17
           DB 06H           ;SW14,6                 18
           DB 07H           ;SW18,7                 19
           DB RWKEY         ;SW22,R/W               20
           DB 00H           ;SW5,0                  21
           DB 01H           ;SW10,1                 22
           DB 02H           ;SW24,2                 23
           DB 03H           ;SW23,3                 24
          ;DB RST           ;SW24  RST KEY          25



BUZ:      MOV   DPTR,#BUZZER 
          MOVX  @DPTR,A
          RET

DELAY:    MOV   R7,#80H
DELAY1:   MOV   R6,#0FFH
DELAY2:   DJNZ  R6,DELAY2
          DJNZ  R7,DELAY1
          RET
          END

