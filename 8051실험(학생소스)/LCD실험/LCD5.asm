; LCD 실험5 ~ LCD 글자 이동하기 

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
;**********************************************************
 ; 표시 클리어 
CLEAR       EQU     01H    ;CLEAR 명령

 ; 커서 훔 
CUR_HOME    EQU     02H    ;CURSOR HOME 위치로 이동

 ; 커서의 진행 방향을 제어하고,표시의 이동을 제어
ENTRY2      EQU     06H    ; 어드레스를 +1 증가 시키고, 커서나 블링크를 우로 이동

 ; 표시부 ON/OFF 제어
DCB6        EQU     0EH    ;표시(ON) ,커서(ON) ,블링크(OFF)

 ;커서 표시 이동
DR_SHIFT    EQU     1CH    ;표시 전체를 우로 이동

 ;펑션 세트
FUN5        EQU     38H    ;8비트 2행 5*7  1/16 듀티 

 ;DD RAM 어드레스 세트
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 번째 줄로 이동
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 번째 줄로 이동 


            ORG     8000H
            CALL    LCD_INIT

            MOV     LROW,#01H
            MOV     LCOL,#01H
            CALL    CUR_MOV
            CALL    LCD_MESG

            MOV     LROW,#02H
            MOV     LCOL,#01H
            CALL    CUR_MOV
            CALL    LCD_MESG

            MOV     LROW,#01H
            MOV     LCOL,#14H
            CALL    CUR_MOV
            CALL    LCD_MESG

            MOV     LROW,#02H
            MOV     LCOL,#14H
            CALL    CUR_MOV
            CALL    LCD_MESG
                        
LOOP:       MOV     INST,#DR_SHIFT
            CALL    INSTWR
            CALL    DELAY
            JMP     LOOP    
                    
;LCD 초기화 수행                                
LCD_INIT:   MOV     INST,#FUN5   
            CALL    INSTWR                            
                 
            MOV     INST,#DCB6    
            CALL    INSTWR

            MOV     INST,#CLEAR     
            CALL    INSTWR

            MOV     INST,#ENTRY2
            CALL    INSTWR       
            RET             
            
; 메세지 표시
LCD_MESG:   MOV     DPTR,#MESSAGE
            MOV     FDPL,DPL
            MOV     FDPH,DPH            
            MOV     NUMFONT,#0DH
            CALL    DISFONT
            RET
 
;*************************************************************
;*           서브 루틴: DISFONT                              *
;*                입력: 없음                                 *
;*                출력: LCD 화면                             *
;*                기능: 글자 폰트를 읽어와 LCD에 표시        *
;*************************************************************
DISFONT:    MOV     R5,#00H      
FLOOP:      MOV     DPL,FDPL
            MOV     DPH,FDPH 
            MOV     A    , R5
            MOVC    A    , @A+DPTR                 
            MOV     DATA , A

            CALL    DATAWR
            INC     R5
            MOV     A ,R5
            CJNE    A,NUMFONT,FLOOP
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
;*          서브 루틴:DATAW                                   *
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
     
;*********************************************************
;*        DEFINE  MESSAGE                                *
;*********************************************************
MESSAGE:    DB 'D','O',' ','Y','O'
            DB 'U','R',' ','B','E'
            DB 'S','T','!'
            
;*********************************************************
;*       서브 루틴: DELAY                                *
;*********************************************************
DELAY:      MOV   R7,#03H
DELAY1:     MOV   R6,#0FFH
DELAY2:     MOV   R5,#0FFH
DELAY3:     DJNZ  R5,DELAY3
            DJNZ  R6,DELAY2
            DJNZ  R7,DELAY1
            RET
END








