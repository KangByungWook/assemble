; LCD 실험3 ~ LCD에 글자 적기 

;*******************************************************************                      
LCDWIR      EQU     0FFE0H  ; LCD IR 쓰기
LCDWDR      EQU     0FFE1H  ; LCD DR 쓰기
LCDRIR      EQU     0FFE2H  ; LCD IR 읽기
LCDRDR      EQU     0FFE3H  ; LCD DR 읽기

;키패드
DATAOUT   EQU      0FFF0H  ;데이터 아웃의 주소
DATAIN    EQU      0FFF1H  ;데이터 인의 주소
DLED      EQU      0FFC1H  ;오른쪽 2개의 7_SEGMENT 주소
ALED0     EQU      0FFC2H  ;중간 2개의 7_SEGMENT 주소
ALED1     EQU      0FFC3H  ;왼쪽 2개의 7_SEGMENT 주소
BUZZER    EQU      0FFEFH

;DEFINE VARIABLE
;********************************************************************
;LCD 관련 변수
INST        EQU     20H    ; LCD INSTRUCTION 값 보관
DATA        EQU     21H    ; LCD DATA 값 보관
LROW        EQU     22H    ; LCD 표시 좌표: 행의 값 보관  
LCOL        EQU     23H    ; LCD 표시 좌표: 열의 값 보관
NUMFONT     EQU     24H    ; 메세지 갯수 보관 
FDPL        EQU     25H    ; DPL 값 보관
FDPH        EQU     26H    ; DPH 값 보관 
DISNUM	    EQU	    27H	   ; LCD에 뿌려줄 숫자 보관
NUM1	    EQU	    28H	   ; 숫자 임시 저장공간1
NUM2	    EQU	    29H	   ; 숫자 임시 저장공간2
INFO1    EQU     2AH    ; 시간 정보 임시 저장공간
INFO2    EQU     2BH    ; 분 정보 임시 저장공간
INFO3    EQU     2CH    ; 초 정보 임시 저장공간
YEARINFO EQU     2FH    ; 연도 값 보관
MONTHINFO EQU    30H    ; 월 값 보관
DAYINFO   EQU    31H    ; 일 값 보관
MODE_STATUS	EQU	32H; 런닝모드(00H), 수정모드(01H), 잠금모드(10H), 해제모드(11H)
STATICHOURINFO	EQU	33H ; 수정모드를 위한 고정 시간값
STATICMININFO	EQU	34H ; 수정모드를 위한 고정 분값
STATICSECINFO	EQU	35H ; 수정모드를 위한 고정 초값
KEYBOARD_INPUT	EQU	36H ; 키보드 입력값 저장공간
DOOR_STATUS	EQU	37H ; 문이 열려있는지 안열려있는지 상태

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







	ORG     8000H  
	MOV	MODE_STATUS, #00H
	
	MOV STATICHOURINFO, #00H
	MOV STATICMININFO, #00H
	MOV STATICSECINFO, #00H
	MOV DOOR_STATUS, #00H
	
	
	

	
;PROGRAMED BY  KIM HYUNG SOO
LEDHOU    EQU     0FFC3H    ; 시(Hour) 표시 주소
LEDMIN    EQU     0FFC2H    ; 분(Min)  표시 주소
LEDSEC    EQU     0FFC1H    ; 초(Sec)  표시 주소
ADJUST    EQU     000D9H    ; 시계 속도를 맞추기 위한 상수
                
          LCALL   ALLCLEAR  ; 초기화
                
CLOCK:    MOV     R2,#0008H 
DELAY3:   MOV     R1,#00FFH
DELAY2:   MOV     R0,#00E0H
DELAY1:   DJNZ    R0,DELAY1
          DJNZ    R1,DELAY2
          DJNZ    R2,DELAY3

;******************************************************
;*        920064 주기가 걸림                          *
;*        1초는 921600 주기가 필요 하다.              *
;*        따라서  1536 주기가 더 필요하다.            *
;******************************************************
               
          MOV     R4,ADJUST     
ADJUST2:  MOV     R3,#0002H    
ADJUST1:  DJNZ    R3,ADJUST1   
          DJNZ    R4,ADJUST2   

;******************************************************
;*    ADJUST 루틴에서 걸린 주기                       * 
;*    2*VAR*2 + VAR*3 = 7*VAR CYCLE                   *
;*    VAR=215 , 따라서 1505 주기가 된다.              *
;*    나머지 31 주기는 1초를 표시하는 루틴에서        *
;******************************************************
CONDITON: CJNE    R5,#59H,SEC     ; 초 단위 비교 
                                       
          CJNE    R6,#59H,MIN     ; 분 단위 비교
                                       
          CJNE    R7,#23H,HOUR    ; 시 단위 비교
                                       
          LCALL   ALLCLEAR        ; 23:59:59 -> 00:00:00
          LJMP    CLOCK           ; CLOCK으로 분기
                          
SEC:      MOV     A,R5          
          ADD     A,#1H           ; 초 단위 증가
          DA      A               ; 십진수 표현
          MOV     R5,A          
          LCALL   DISSEC          ; 초 표시 루틴 호출
          LJMP    CLOCK           ; CLOCK으로 분기
                 
               
MIN:      MOV     A,R6               
          ADD     A,#1H           ; 분 단위 증가
          DA      A               ; 십진수 표현    
          MOV     R6,A
          LCALL   CLRSEC          
          LCALL   DISMIN          ; 분 표시 루틴 호출
          MOV     A,#00H       
          LCALL   DISSEC          ; 초 00 표시 
          LJMP    CLOCK           ; CLOCK으로 분기
                 
                
HOUR:     MOV     A,R7
          ADD     A,#1H           ; 시 단위 증가 
          DA      A               ; 십진수 표현
          MOV     R7,A
          LCALL   CLRMIN
          LCALL   DISHOU          ; 시 표시 루틴 호출       
          MOV     A,#00H
          LCALL   DISMIN 
          LCALL   DISSEC
          LJMP    CLOCK
      
ALLCLEAR: LCALL   CLRHOU          ; 표시 초기화 루틴
          MOV     A,#00H         
          LCALL   DISHOU
          LCALL   DISMIN
          LCALL   DISSEC
          RET
                                
CLRHOU:   MOV     R7,#0H          ; 변수 초기화 루틴
CLRMIN:   MOV     R6,#0H
CLRSEC:   MOV     R5,#0H
          RET
                                
DISHOU:   MOV     DPTR,#LEDHOU    ; 시 표시 루틴
          MOVX    @DPTR,A        
          RET                    
                                 
DISMIN:   MOV     DPTR,#LEDMIN    ; 분 표시 루틴 
          MOVX    @DPTR,A
          RET

DISSEC:   MOV     DPTR,#LEDSEC    ; 초 정보가 업데이트 될 때 LCD도 업데이트
          MOVX    @DPTR,A
	  CALL DISPLAY_LCD
	  




          RET   

DISPLAY_LCD:
	PUSH DPH
	PUSH DPL
	PUSH A
	PUSH B
	PUSH 01H
	PUSH 02H
	PUSH 03H
	PUSH 04H
	PUSH 05H
	PUSH 06H
	PUSH 07H
	  
	CALL LCD_INIT
	  
	  
	POP 07H
	POP 06H
	POP 05H
	POP 04H
	POP 03H
	POP 02H
	POP 01H
	POP B
	POP A
	POP DPL
	POP DPH
	  
	RET


;LCD 초기화 수행                                
LCD_INIT:   
	MOV     INST,#FUN5   
	CALL    INSTWR                            
           	      
	MOV     INST,#DCB6    
	CALL    INSTWR

	MOV     INST,#CLEAR     
	CALL    INSTWR
	
	MOV     INST,#ENTRY2
	CALL    INSTWR 
	       
            
            
;초기 메세지 표시

LCD_MESG:   
	;시간 정보 백업
	MOV	INFO1, R7
	MOV	INFO2, R6
	MOV	INFO3, R5
	
	
	; 모드값에 따라서 LCD에 다르게 표시  
	MOV	A, MODE_STATUS
	CJNE	A, #00H, CLOCK_RUN_PASS
	JMP	CLOCK_RUN_MODE
	  
CLOCK_RUN_PASS:
	CJNE	A, #01H, CLOCK_MODI_PASS
	JMP	CLOCK_MODI_MODE

CLOCK_MODI_PASS:
	CJNE	A, #10H, DOOR_CLOSE_PASS
	JMP	DOOR_CLOSE_MODE

DOOR_CLOSE_PASS:
	CJNE	A, #11H, DOOR_OPEN_PASS
	JMP	DOOR_OPEN_MODE

DOOR_OPEN_PASS:
	NOP
	
	
	  

	

	
CLOCK_RUN_MODE:
	; 수정모드를 위한 고정 시간정보 백업
	MOV STATICHOURINFO, R7
	MOV STATICMININFO, R6
	MOV STATICSECINFO, R5
	;첫번째 행 시간 정보 글자 뿌리기
	MOV     LROW,#01H ; 글자 시작 위치(행), 01H=첫번째 행, 01H=두번째 행
	MOV     LCOL,#06H ; 글자 시작 위치(열)
            
	MOV     INST,#ENTRY2
	CALL    INSTWR 
	CALL    CUR_MOV
	MOV     DPTR,#CLOCKS

	MOV     FDPL,DPL
	MOV     FDPH,DPH
	    
	;시간정보            
	MOV     NUMFONT,#02H
	MOV	    A, INFO1
	MOV     B, #10H
	DIV     AB
	MOV	    NUM1, A
	MOV     NUM2, B
	MOV     DISNUM,NUM1		;시간정보 십자리
	CALL    DISFONT 
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;시간정보 일자리
	CALL    DISFONT
	    
	;콜론
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0AH
	CALL    DISFONT
	    
	    
	;분 정보
	MOV     LCOL,#09H
	CALL    CUR_MOV
	MOV	    A, INFO2
	MOV     B, #10H
	DIV     AB
	MOV	    NUM1, A
	MOV     NUM2, B
	MOV     DISNUM,NUM1		;분정보 십자리
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;분정보 일자리
	CALL    DISFONT

	;콜론
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0AH
	CALL    DISFONT
	    
	    
	;초 정보
	MOV     LCOL,#0CH
	CALL    CUR_MOV
	MOV	A, INFO3
	MOV     B, #10H
	DIV     AB
	MOV	    NUM1, A
	MOV     NUM2, B
	MOV     DISNUM,NUM1		;초정보 십자리
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;초정보 일자리
	CALL    DISFONT
	   
	MOV 	A, DOOR_STATUS
	CJNE	A, #00H, DOOR_OPEN
	    				;도어락 상태 표시
	INC LCOL
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0CH		;D
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0DH		;C
	CALL    DISFONT
	JMP		DIS_SECOND_LINE
	
	DOOR_OPEN:
		INC LCOL
		INC	    LCOL
		CALL    CUR_MOV
		MOV     DISNUM,#0CH		;D
		CALL    DISFONT
		INC	    LCOL
		CALL    CUR_MOV
		MOV     DISNUM,#0FH		;O
		CALL    DISFONT

DIS_SECOND_LINE: ;두번째 행 글자 뿌리기 시작
	MOV     LROW,#02H
	MOV     LCOL,#06H
	CALL    CUR_MOV
	    
	;연월일 정보 초기화(일단 임시값으로)
	MOV YEARINFO, #16
	MOV MONTHINFO, #21
	MOV DAYINFO, #32
 	    
	;연 정보
	MOV 	A,YEARINFO
	MOV		B,#10
	DIV		AB
	MOV		NUM1,A
	MOV		NUM2,B
	MOV		DISNUM,NUM1	;연 정보 십자리
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;연정보 일자리
	CALL    DISFONT
	    
	;빼기 문자
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0BH
	CALL    DISFONT
	    
	    ;월 정보
	MOV     	LCOL,#09H
	CALL    	CUR_MOV
	MOV 	A,MONTHINFO
	MOV		B,#10
	DIV		AB
	MOV		NUM1,A
	MOV		NUM2,B
	MOV		DISNUM,NUM1	;연 정보 십자리
	CALL   	DISFONT
	INC	   	LCOL
	CALL   	CUR_MOV
	MOV     	DISNUM,NUM2		;연정보 일자리
	CALL	DISFONT
	    
	    ;빼기 문자
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0BH
	CALL    DISFONT

	    ;일 정보
	MOV     LCOL,#0CH
	CALL    CUR_MOV
	MOV 	A,DAYINFO
	MOV	B,#10
	DIV	AB
	MOV	NUM1,A
	MOV	NUM2,B
	MOV	DISNUM,NUM1	;일 정보 십자리
	CALL   	DISFONT
	INC	   LCOL
	CALL   	CUR_MOV
	MOV     	DISNUM,NUM2	;일 정보 일자리
	CALL	DISFONT
	    
	; 모드 표시하기
	INC LCOL
	INC	   	LCOL
	CALL   	CUR_MOV
	MOV     	DISNUM,#0FH	;일 정보 일자리
	CALL	DISFONT

	PUSH DPH
	PUSH DPL
	PUSH A
	PUSH B
	PUSH 01H
	PUSH 02H
	PUSH 03H
	PUSH 04H
	PUSH 05H
	PUSH 06H
	PUSH 07H
	JMP	SCANN


CLOCK_MODI_MODE:
	  	;첫번째 행 시간 정보 글자 뿌리기
	MOV     LROW,#01H ; 글자 시작 위치(행), 01H=첫번째 행, 01H=두번째 행
	MOV     LCOL,#06H ; 글자 시작 위치(열)
            
	MOV     INST,#ENTRY2
	CALL    INSTWR 
	CALL    CUR_MOV
	MOV     DPTR,#CLOCKS

	MOV     FDPL,DPL
	MOV     FDPH,DPH
	    
	;시간정보            
	MOV     NUMFONT,#02H
	MOV	    A, STATICHOURINFO
	MOV     B, #10H
	DIV     AB
	MOV	    NUM1, A
	MOV     NUM2, B
	MOV     DISNUM,NUM1		;시간정보 십자리
	CALL    DISFONT 
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;시간정보 일자리
	CALL    DISFONT
	    
	;콜론
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0AH
	CALL    DISFONT
	    
	;분 정보
	MOV     LCOL,#09H
	CALL    CUR_MOV
	MOV	    A, STATICMININFO
	MOV     B, #10H
	DIV     AB
	MOV	    NUM1, A
	MOV     NUM2, B
	MOV     DISNUM,NUM1		;분정보 십자리
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;분정보 일자리
	CALL    DISFONT

	;콜론
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0AH
	CALL    DISFONT
	    ;초 정보
	MOV     LCOL,#0CH
	CALL    CUR_MOV
	MOV	    A, STATICSECINFO
	MOV     B, #10H
	DIV     AB
	MOV	    NUM1, A
	MOV     NUM2, B
	MOV     DISNUM,NUM1		;초정보 십자리
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;초정보 일자리
	CALL    DISFONT

	MOV 	A, DOOR_STATUS
	CJNE	A, #00H, DOOR_OPEN_MODI
	    				;도어락 상태 표시
	INC LCOL
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0CH		;D
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0DH		;C
	CALL    DISFONT
	JMP		DIS_SECOND_LIN
	
	DOOR_OPEN_MODI:
	INC LCOL
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0CH		;D
	CALL    DISFONT
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0FH		;O
	CALL    DISFONT

DIS_SECOND_LIN:
	;두번째 행 글자 뿌리기 시작
	MOV     LROW,#02H
	MOV     LCOL,#06H
	CALL    CUR_MOV
	    
 	    
	;연 정보
	MOV 	A,YEARINFO
	MOV	B,#10
	DIV	AB
	MOV	NUM1,A
	MOV	NUM2,B
	MOV	DISNUM,NUM1	;연 정보 십자리
	CALL    DISFONT
	INC	LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;연정보 일자리
	CALL    DISFONT
	    
	;빼기 문자
	INC	LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0BH
	CALL    DISFONT
	    
	;월 정보
	MOV     LCOL,#09H
	CALL    CUR_MOV
	MOV 	A,MONTHINFO
	MOV	B,#10
	DIV	AB
	MOV	NUM1,A
	MOV	NUM2,B
	MOV	DISNUM,NUM1	;월 정보 십자리
	CALL   	DISFONT
	INC	LCOL
	CALL   	CUR_MOV
	MOV     DISNUM,NUM2		;월 정보 일자리
	CALL	DISFONT
	    
	;빼기 문자
	INC	    LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0BH
	CALL    DISFONT

	;일 정보
	MOV     	LCOL,#0CH
	CALL    	CUR_MOV
	MOV 	A,DAYINFO
	MOV		B,#10
	DIV		AB
	MOV		NUM1,A
	MOV		NUM2,B
	MOV		DISNUM,NUM1	;일 정보 십자리
	CALL   	DISFONT
	INC	   	LCOL
	CALL   	CUR_MOV
	MOV     	DISNUM,NUM2	;일 정보 일자리
	CALL	DISFONT
		
	; 모드 표시하기
	INC LCOL
	INC	LCOL
	CALL   	CUR_MOV
	MOV    	DISNUM,#10H	;M
	CALL	DISFONT

	 ;두번째 행 글자 뿌리기 시작
	PUSH DPH
	PUSH DPL
	PUSH A
	PUSH B
	PUSH 01H
	PUSH 02H
	PUSH 03H
	PUSH 04H
	PUSH 05H
	PUSH 06H
	PUSH 07H
	JMP	SCANN


DOOR_CLOSE_MODE:
	JMP LCD_ROUTINE_END

DOOR_OPEN_MODE:
	JMP LCD_ROUTINE_END


LCD_ROUTINE_END:
	POP 07H
	POP 06H
	POP 05H
	POP 04H
	POP 03H
	POP 02H
	POP 01H
	POP B
	POP A
	POP DPL
	POP DPH

	RET




;키 패드 인터페이스 예제

SCANN:     	    		
	PUSH     PSW     ; PSW 값을 스택에 보관
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
           JNC	KEY_RET       ; 모든 열을 스캔했으면, 다시 시작 
           JMP      COLSCAN       ; 다음 열의 스캔을 위한 분기


RSCAN:     MOV      R2,#00H       ; R2 행의 값 보관
ROWSCAN:   RRC      A             ; 어느 행이 "1" 로 바뀌었는지 조사
           JC       MATRIX        ; 캐리가 발생하면, MATRIX로 분기
           INC      R2            ; 캐리가 발생하지 않으면, 다음 행으로 이동
           JMP      ROWSCAN       ; 다음 행의 스캔을 위한 분기

MATRIX:    
	MOV      A,R2          ; R2 에는 행의 값 보존
        MOV      B,#05H        ; 1행은 5열로 이루어짐
	MUL      AB            ; 2차원 배열을 1차원 배열로 값을 바꿈
	ADD      A,R1          ; R1 에는 열의 값 보존
	CALL     INDEX         ; 키 코드 값을 지정
	CALL     DISPLAY       ; 키 코드 값의 표시 
	;POP      PSW           ; 스택으로 부터 PSW값을 가지고 옴
	
	JMP	KEY_RET                   ; 상위 루틴으로 복귀
KEY_RET:
	POP	PSW
	JMP	LCD_ROUTINE_END

;*************************************************************
;*           서브 루틴: DISFONT                              *
;*                입력: 숫자                                 *
;*                출력: LCD 화면                             *
;*                기능: 글자 폰트를 읽어와 LCD에 표시        *
;*************************************************************
DISFONT:    MOV     R5,DISNUM      
FLOOP:      MOV     DPL,FDPL
            MOV     DPH,FDPH 
            MOV     A,R5
            MOVC    A,@A+DPTR                 
            MOV     DATA,A

            CALL    DATAWR
            INC     R5
            MOV     A,R5
            ;CJNE    A,NUMFONT,FLOOP
            RET    

;*************************************************************
;*           서브 루틴: DISSTRING                              *
;*                입력: 숫자                                 *
;*                출력: LCD 화면                             *
;*                기능: 글자 폰트를 읽어와 LCD에 표시        *
;*************************************************************
DISSTRING:    MOV     R5,DISNUM      
FFLOOP:      MOV     DPL,FDPL
            MOV     DPH,FDPH 
            MOV     A,R5
            MOVC    A,@A+DPTR                 
            MOV     DATA,A

            CALL    DATAWR
            INC     R5
            MOV     A,R5
            CJNE    A,NUMFONT,FFLOOP
            RET    

;**************************************************************
;*       서브 루틴: 커서의 위치 제어(CUR_MOV)                 *
;*            입력: 커서의 행과 열 < LROW(행) ,LCOL(열) >     *
;*            출력: LCD 화면                                  * 
;*            기능: 커서 위치 조정                            *
;**************************************************************  
CUR_MOV:    MOV     A,LROW
            CJNE    A,#01H, NEXT
            MOV     A ,#LINE_1
            ADD     A ,LCOL
            MOV     INST,A
            CALL    INSTWR
            JMP     RET_POINT                 

NEXT:       CJNE    A,#02H, RET_POINT
            MOV     A ,#LINE_2
            ADD     A ,LCOL
            MOV     INST,A 
            CALL    INSTWR
RET_POINT:  RET

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
;*          서브 루틴:DATAWR                                  *
;*               입력:DATA                                    * 
;*               출력:LCD 화면                                *
;*               기능:LCD DATA 레지스터 쓰기                  *
;**************************************************************
DATAWR:     CALL     INSTRD
            MOV      DPTR,#LCDWDR
            MOV      A,DATA
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
 
CLOCKS: DB '0','1','2','3','4'
	 DB '5','6','7','8','9'
	 DB ':','-','D','C', 'O'
	 DB 'R','M'

DOOR_CLOSE: DB 'D','C'
RUNNING: DB 'R'
MODI: DB 'M'

;*****************************************************************
;*         서브 루틴 : SUBKEY                                    *
;*              입력 : ACC                                       *
;*              출력 : ACC                                       *
;*              기능 : 데이터 아웃으로 데이터를 내보내고         *
;*                     데이터 인으로 결과를 확인                 * 
;*****************************************************************
SUBKEY:    NOP
	   MOV	    R0, A
	   MOV      DPTR,#DATAOUT
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
	   
	   MOV	KEYBOARD_INPUT, A ; 입력값 백업
	
	   MOV	A, MODE_STATUS
	   CJNE	A, #00H, NOT_RUN_MODE	;런닝모드
	   MOV	A, KEYBOARD_INPUT	
	   CJNE	A, #0BH, INTERRUPT_END
	   MOV MODE_STATUS, #01H	;B버튼이 눌렸을 시 수정모드로 변경
	   JMP	INTERRUPT_END

NOT_RUN_MODE:				
	CJNE A, #01H, NOT_MODI_MODE	;수정모드
	MOV	A, KEYBOARD_INPUT	
	CJNE	A, #0BH, NOT_B
	MOV MODE_STATUS, #00H	;B버튼이 눌렸을 시 런닝모드로 변경
	
	NOT_B:
		CJNE	A, #0CH, NOT_C
		INC	STATICHOURINFO
		JMP	INTERRUPT_END
	NOT_C:
		CJNE	A, #0DH, NOT_D
		INC	STATICMININFO
		JMP	INTERRUPT_END
	NOT_D:
		CJNE	A, #0EH, NOT_E
		INC	STATICSECINFO
		JMP	INTERRUPT_END
	NOT_E:
		CJNE	A, #17H, NOT_17
		INC	YEARINFO
		JMP	INTERRUPT_END
	NOT_17:
		CJNE	A, #16H, NOT_16
		INC	MONTHINFO
		JMP	INTERRUPT_END
	NOT_16:
		CJNE	A, #15H, NOT_15
		INC	DAYINFO
		JMP	INTERRUPT_END
	NOT_15:
		JMP	INTERRUPT_END
	

NOT_MODI_MODE:
	CJNE A, #10H, NOT_CLOSE_MODE

NOT_CLOSE_MODE:
	CJNE A, #11H, INTERRUPT_END
	
	   

	
	INTERRUPT_END:
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


                    ;
                    END
      
END