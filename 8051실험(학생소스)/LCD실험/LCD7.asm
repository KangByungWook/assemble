; LCD 실험7 ~  사용자 문자 패턴 정의 
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
NUMFONT     EQU     24H    ; 데이터 갯수 보관
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

 ;펑션 세트
FUN5        EQU     38H    ;8비트 2행 5*7  1/16 듀티 

 ;DD RAM 어드레스 세트
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 번째 줄로 이동
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 번째 줄로 이동 


            ORG     8000H
            CALL    LCD_INIT
            MOV     R4,#00H

            MOV     INST,#01000000B ;CG-RAM 의 어드레스 세팅
LOOP:       CALL    INSTWR          

            CALL    LCD_FONT        ;CG-RAM FONT적기                             

            MOV     A,INST       
            INC     A               ;CG-RAM의 주소 증가
            MOV     INST,A
            INC     R4              ;다음 FONT를 적기위해, R4 증가
            CJNE    R4,#10H,LOOP 
            
            MOV     LROW,#01H       ;커서 위치 지정
            MOV     LCOL,#05H
            CALL    CUR_MOV
            
            MOV     DATA,#00H       ;사용자 FONT LCD 화면에 적기
            CALL    DATAWR
            
            MOV     DATA,#01H
            CALL    DATAWR
            JMP     $              
           
                    
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
            
; FONT 읽어와, CG-RAM 에 적기
LCD_FONT:   MOV     DPTR,#UFONT
            MOV     A    , R4
            MOVC    A    , @A+DPTR                 
            MOV     DATA , A
            CALL    DATAWR
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

;***************************************************************
;*         DEFINE  UFONT                                       *
;***************************************************************
UFONT:      DB 00000000B,00001001B,00010101B,00001001B,00000000B
            DB 00010000B,00011110B,00000000B
            DB 00000000B,00011110B,00000010B,00000000B,00011111B
            DB 00000100B,00000100B,00000000B

END








