
  	    ORG	   8000H

DATAOUT     EQU     0FFF0H  ;데이터 아웃의 주소
DATAIN      EQU     0FFF1H  ;데이터 인의 주소

ALED	    EQU	    6AH	    ;LED등 지시값
CMP	    EQU	    6BH	    ;비트단위 연산을 위한 값

;판별할 3개의 숫자
NUM1	    EQU     60H
NUM2	    EQU	    61H
NUM3	    EQU	    62H


GOTNUM	    EQU	    53H	    ;받은 숫자의 개수 저장
SLOC	    EQU	    54H	    ;저장할 위치를 임시저장
COUNT	    EQU	    55H	    ;볼카운트 임시저장

STRIKE	    EQU	    56H	    ;스트라이크 수
BALL	    EQU	    57H	    ;볼 수

ERRNUM	    EQU	    58H	    ;틀린 횟수

;*******************************************************************                      
LCDWIR      EQU     0FFE0H  ; LCD IR 쓰기
LCDWDR      EQU     0FFE1H  ; LCD DR 쓰기
LCDRIR      EQU     0FFE2H  ; LCD IR 읽기
LCDRDR      EQU     0FFE3H  ; LCD DR 읽기

;DEFINE VARIABLE
;********************************************************************
INST        EQU     20H    ; LCD INSTRUCTION 값 보관
DATA        EQU     21H    ; LCD DATA 값 보관
LROW        EQU     22H    ; LCD 표시 좌표: 행의 값 보관  
LCOL        EQU     23H    ; LCD 표시 좌표: 열의 값 보관
NUMFONT     EQU     24H    ; 메세지 갯수 보관 
FDPL        EQU     25H    ; DPL 값 보관
FDPH        EQU     26H    ; DPH 값 보관 

;DEFINE LCD INSTRUCTION 
;*********************************************************************
 ; 표시 클리어 
CLEAR       EQU     01H    ;CLEAR 명령

 ; 커서 훔 
CUR_HOME    EQU     02H    ;CURSOR HOME 위치로 이동

 ; 커서의 진행 방향을 제어하고,표시의 이동을 제어
ENTRY2      EQU     06H    ; 어드레스를 +1 증가 시키고, 커서나 블링크를 우로 이동

 ; 표시부 ON/OFF 제어
DCB6        EQU     0EH    ;표시(ON) ,커서(ON) ,블링크(OFF)

 ; 펑션 세트
FUN5        EQU     38H    ;8비트 2행 5*7  1/16 듀티 

 ;DD RAM 어드레스 세트
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 번째 줄로 이동
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 번째 줄로 이동 


	   MOV	    STRIKE,#00H
	   MOV	    BALL,#00H
	   
	   MOV	    50H,#20H
	   MOV	    51H,#20H
	   MOV	    52H,#20H
	   MOV	    GOTNUM,#00H

	   MOV 	    R7,#00H ; R7과 40H를 이용해 처음 눌린 경우에만 LCD실행
	   MOV	    40H,#00H

	   MOV	    ERRNUM,#00H
	   MOV	    CMP,#00000001B
 
	   MOV	    ALED,#00000000B      ;LED를 모두 켠다      
	   MOV	    P1,ALED


;레지스터에 있는 쓰레기값을 이용하여 랜덤값을 취한다
RAND:	   MOV	    A,R0
	   ANL	    A,#00001111B	;하위 4비트를 취한다
	   SUBB	    A,#0AH	        ;10을 뺌
	   JC	    RSTORE1	        ;캐리 발생하면 RESTORE
RE1:	   ADD	    A,#30H	        ;취한 값을 주소값으로 변환
	   MOV	    NUM1,A

	   MOV	    A,R1
	   ANL	    A,#00001111B
	   SUBB	    A,#0AH
	   JC	    RSTORE2
RE2:	   ADD	    A,#30H
	   MOV	    NUM2,A

	   MOV	    A,R3
	   ANL	    A,#00001111B
	   SUBB	    A,#0AH
	   JC	    RSTORE3
RE3:	   ADD	    A,#30H
	   MOV	    NUM3,A

	   JMP	    KEYPAD

RSTORE1:   ADD	    A,#0AH
	   JMP	    RE1
RSTORE2:   ADD	    A,#0AH
	   JMP	    RE2
RSTORE3:   ADD	    A,#0AH
	   JMP	    RE3
	       

;***************KEYPAD 입력 루틴****************** 
KEYPAD:    CALL     SCANN   ; 스캔 루틴 호출
	   MOV 	    A,GOTNUM
	   CJNE	    A,#03H,KEYPAD;3번 수행하면 초기화
	   INC	    ERRNUM
	   MOV	    GOTNUM,#00H
	   MOV	    50H,#20H
	   MOV	    51H,#20H
	   MOV	    52H,#20H

	   MOV	    A,STRIKE
	   MOV	    STRIKE,#00H
	   MOV	    BALL,#00H
	   CJNE	    A,#03H,ISERR
	   MOV	    ALED,#00000000B ;전체를 껐다켰다하기 위해
	   CALL	    ISEND
	   RET

;틀렸을 때
ISERR:	   MOV	    A,ALED	;틀렸을 때 LED를 하나씩 끈다
	   ADD	    A,CMP
	   MOV	    ALED,A

	   MOV	    P1,ALED

	   MOV	    A,CMP	;한자리씩 왼쪽으로 쉬프트해 
	   RL	    A	        ;LED등을 하나씩 끈다
	   MOV	    CMP,A

	   MOV	    A,ERRNUM
	   CJNE	    A,#08H,KEYPAD   ;8번 틀렸을 때
	   MOV	    ALED,#11110000B ;4개씩 번갈아가며 점등
	   CALL	    ISEND	   

	   RET 

;게임 끝났을 때
ISEND:	   MOV	    P1,ALED     
	   MOV	    A,ALED
	   CPL	    A          ;보수를 취해 껐다켰다 한다
	   MOV	    ALED,A
	   CALL	    DELAY
	   JMP	    ISEND
	   
DELAY:     MOV   R1,#01FH
DELAY2:	   MOV	 R2,#0FFH
DELAY3:	   MOV	 R3,#0FFH
DELAY4:    DJNZ	 R3,DELAY4
	   DJNZ	 R2,DELAY3
	   DJNZ  R1,DELAY2

           RET

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
           	   
FIND:      JC       MATRIX        ; 캐리가 발생하면, MATRIX로 분기
           INC      R2            ; 캐리가 발생하지 않으면, 다음 행으로 이동
           JMP      ROWSCAN       ; 다음 행의 스캔을 위한 분기

NOTLCD:	   MOV	    40H,#01H
	   JMP	    FIND

MATRIX: 
	   MOV      A,R2          ; R2 에는 행의 값 보존
           MOV      B,#05H        ; 1행은 5열로 이루어짐
           MUL      AB            ; 2차원 배열을 1차원 배열로 값을 바꿈
           ADD      A,R1          ; R1 에는 열의 값 보존
           CALL     INDEX         ; 키 코드 값을 지정
	   POP      PSW 	  ; 스택으로 부터 PSW값을 가지고 옴
	   
	   MOV 	    40H,R7
	   MOV	    41H,A
	   CJNE	    A,40H,LCD_INIT; 이전과 다른 키가 눌린 경우에만 LCD실행
BACK: 	   MOV	    R7,41H	  
               
           RET                    ; 상위 루틴으로 복귀
;****************************************************************

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

KEYBASE:   DB 4EH           ;SW1,ST                  1
           DB 4EH           ;SW6,CODE                2
           DB 4EH           ;SW11,CD                 3
           DB 4EH           ;SW15,REG                4
           DB 4EH           ;SW19,GO                 5
           DB 4EH           ;SW2,C                   6
           DB 4EH           ;SW7,D                   7
           DB 4EH           ;SW12,E                  8
           DB 4EH           ;SW16,F                  9
           DB 4EH           ;SW20,COMMA (,)         10
           DB 38H           ;SW3,8                  11
           DB 39H           ;SW8,9                  12
           DB 4EH           ;SW13,A                 13
           DB 4EH           ;SW17,B                 14
           DB 4EH           ;SW21,PERIOD(.)         15
           DB 34H           ;SW4,4                  16
           DB 35H           ;SW9,5                  17
           DB 36H           ;SW14,6                 18
           DB 37H           ;SW18,7                 19
           DB 4EH           ;SW22,R/W               20
           DB 30H           ;SW5,0                  21
           DB 31H           ;SW10,1                 22
           DB 32H     	    ;SW24,2                 23
           DB 33H           ;SW23,3                 24
          ;DB RST           ;SW24  RST KEY          25    



;***********************LCD 출력***********************
                              
LCD_INIT:   MOV     40H,#00H
	    MOV	    R6,A	   ;눌린 키를 R6에 저장

	    MOV     INST,#FUN5   
            CALL    INSTWR                            
                 
            MOV     INST,#DCB6    
            CALL    INSTWR

            MOV     INST,#CLEAR     
            CALL    INSTWR

            MOV     INST,#ENTRY2
            CALL    INSTWR       
            
	    ;초기 메세지 표시
            MOV     LROW,#01H
            MOV     LCOL,#02H
            CALL    CUR_MOV
            
	    MOV	    A,#50H	   ;50H~52H에 입력받은 값 저장
	    ADD	    A,GOTNUM
	    MOV	    R1,A	   
	    MOV	    SLOC,R6
	    MOV	    @R1,SLOC
            CALL    DISFONT

	    INC	    GOTNUM	   ;입력받은 숫자 개수에 1을 합산

EXPCHK:	    MOV	    A,SLOC
	    CJNE    A,#4EH,TRDCHK

	    CALL    EXPHDL
	    MOV	    GOTNUM,#00H
	    MOV	    50H,#20H
	    MOV	    51H,#20H
	    MOV	    52H,#20H

            JMP     BACK

TRDCHK:	    MOV	    A,GOTNUM
	    CJNE    A,#03H,BACK  ;3개를 입력받으면 두번째줄 출력
	    
	    CALL    CUR_MOV2
	    CALL    RSLTCHK

	    JMP	    BACK

;숫자 이외의 값이 들어왔을때 예외처리
EXPHDL:     CALL    CUR_MOV2
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#57H	    
	    MOVX     @DPTR,A

	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#52H	  
	    MOVX     @DPTR,A

	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#4FH	    
	    MOVX     @DPTR,A

	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#4EH	  
	    MOVX     @DPTR,A

	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#47H	    
	    MOVX     @DPTR,A
       
            RET      


;***********************************************
;STRIKE와 BALL의 개수를 파악한다
RSLTCHK:    MOV	    COUNT,#00H
	    MOV	    70H,NUM1
	    
CHK1:	    MOV	    A,70H
	    CJNE    A,50H,L1
	    INC	    STRIKE
	    JMP	    CHK2
L1:	    CJNE    A,51H,L2
	    INC	    STRIKE
	    JMP	    CHK2
L2:	    CJNE    A,52H,NONUM
	    INC	    STRIKE
	    JMP	    CHK2

NONUM:	    INC	    BALL
CHK2:	    INC	    COUNT
	    MOV	    A,#NUM1
	    ADD	    A,COUNT
	    MOV	    R1,A
	    MOV	    70H,@R1
	    MOV	    A,COUNT
	    CJNE    A,#03H,CHK1


PRINT:	    CALL    RSLTWR
	    

	    RET
;****************************************************


;*************************************************************
;*           서브 루틴: DISFONT                              *
;*                입력: 없음                                 *
;*                출력: LCD 화면                             *
;*                기능: 글자 폰트를 읽어와 LCD에 표시        *
;*************************************************************
DISFONT:    MOV     R5,#00H   
	    CALL    DATAWR
            RET        

;**************************************************************
;*       서브 루틴: 커서의 위치 제어(CUR_MOV)                 *
;*            출력: LCD 화면                                  * 
;*            기능: 커서 위치를 첫번째 줄로                   *
;**************************************************************  
CUR_MOV:    MOV     A,#LINE_1
            ADD     A ,#06H
            MOV     INST,A
            CALL    INSTWR
            JMP     RET_POINT                 

RET_POINT:  RET

;**************************************************************
;*       서브 루틴: 커서의 위치 제어(CUR_MOV2)                *
;*            출력: LCD 화면                                  * 
;*            기능: 커서 위치를 두번째 줄로                   *
;**************************************************************  
CUR_MOV2:   MOV     A,#LINE_2
            ADD     A ,#04H
            MOV     INST,A
            CALL    INSTWR
            JMP     RET_POINT2                 

RET_POINT2:  RET

;**************************************************************
;*         서브 루틴: INSTWR                                  *
;*              입력: INST                                    *
;*              출력: LCD 화면                                *
;*              기능: LCD INSTRUCTION 레지스터 쓰기           *
;**************************************************************
INSTWR:     CALL     INSTRD
            MOV      DPTR,#LCDWIR
            MOV      A,INST
            MOVX     @DPTR,A
            RET

;**************************************************************
;*          서브 루틴:DATAW                                   *
;*               입력:DATA                                    * 
;*               출력:LCD 화면                                *
;*               기능:입력받은 값을 출력                      *
;**************************************************************
DATAWR:     CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,50H	    ; 키패드로 받은 값 전달
	    MOVX     @DPTR,A
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,51H
	    MOVX     @DPTR,A
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,52H
	    MOVX     @DPTR,A
            RET

;**************************************************************
;*          서브 루틴:DATAW                                   *
;*               입력:DATA                                    * 
;*               출력:LCD 화면                                *
;*               기능:STRIKE와 BALL 개수를 출력               *
;**************************************************************
RSLTWR:     CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#53H	    ; 키패드로 받은 값 전달
	    MOVX     @DPTR,A
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,#3AH
	    MOVX     @DPTR,A
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,#30H
	    ADD	     A,STRIKE
	    MOVX     @DPTR,A

	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,#20H
	    MOVX     @DPTR,A

	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,#42H
	    MOVX     @DPTR,A
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,#3AH
	    MOVX     @DPTR,A
	    CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV	     A,#30H
	    ADD	     A,BALL
	    MOVX     @DPTR,A
            RET

;**************************************************************
;*          서브 루틴:INSTRD                                  *
;*               입력:없음                                    *
;*               출력;BUSY                                    *
;*               기능:비지 플래그/어드레스 읽기               *
;**************************************************************
INSTRD:     MOV      DPTR,#LCDRIR
            MOVX     A,@DPTR
            JB       ACC.7,INSTRD 
            RET               


;***************************************************************
;*         DEFINE  MESSAGE                                     *
;***************************************************************
MESSAGE1:   DB '0'
	    DB '1'
	    DB '2'
            DB '3'
	    DB '4'
	    DB '5'
	    DB '6'
	    DB '7'
	    DB '8'
	    DB '9'
            DB 'N'        
	    DB ' '
MESSAGE2:   DB 'S'
	    DB 'B'
	    DB ':'
	    DB 'W'
	    DB 'R'
	    DB 'O'
	    DB 'N'
	    DB 'G'

END
