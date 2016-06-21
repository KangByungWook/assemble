; LCD 실험3 ~ LCD에 글자 적기 

;*******************************************************************                      
LCDWIR      EQU     0FFE0H  ; LCD IR 쓰기
LCDWDR      EQU     0FFE1H  ; LCD DR 쓰기
LCDRIR      EQU     0FFE2H  ; LCD IR 읽기
LCDRDR      EQU     0FFE3H  ; LCD DR 읽기

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
	  CALL LCD_DISPLAY

          RET   

LCD_DISPLAY:
   	  PUSH DPH
	  PUSH DPL
	  PUSH A
	  PUSH 05H
	  PUSH 06H
	  PUSH 07H
	  
	  CALL LCD_INIT
	  
	  POP 07H
	  POP 06H
	  POP 05H
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
	
	;첫번째 행 시간 정보 글자 뿌리기
	    MOV     LROW,#01H ; 글자 시작 위치(행), 01H=첫번째 행, 01H=두번째 행
            MOV     LCOL,#06H ; 글자 시작 위치(열)
            CALL    CUR_MOV
            MOV     INST,#ENTRY2
            CALL    INSTWR 
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
	    MOV	    A, INFO3
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
	   
	;두번째 행 글자 뿌리기 시작
            MOV     LROW,#02H
            MOV     LCOL,#06H
            CALL    CUR_MOV
	    ;연월일 정보 초기화(일단 임시값으로)
	    MOV YEARINFO, #16
	    MOV MONTHINFO, #6
	    MOV DAYINFO, #21
 	    
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
            RET


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
	 DB ':','-'          
      
END