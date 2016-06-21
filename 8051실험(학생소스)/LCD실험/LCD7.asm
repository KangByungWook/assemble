; LCD ����7 ~  ����� ���� ���� ���� 
;*******************************************************************                      
LCDWIR      EQU     0FFE0H  ; LCD IR ����
LCDWDR      EQU     0FFE1H  ; LCD DR ����
LCDRIR      EQU     0FFE2H  ; LCD IR �б�
LCDRDR      EQU     0FFE3H  ; LCD DR �б�

;DEFINE VARIABLE
;********************************************************************
INST        EQU     20H    ; LCD INSTRUCTION �� ����
DATA        EQU     21H    ; LCD DATA �� ����
LROW        EQU     22H    ; LCD ǥ�� ��ǥ: ���� �� ����  
LCOL        EQU     23H    ; LCD ǥ�� ��ǥ: ���� �� ����
NUMFONT     EQU     24H    ; ������ ���� ����
FDPL        EQU     25H    ; DPL �� ����
FDPH        EQU     26H    ; DPH �� ����

;DEFINE LCD INSTRUCTION 
;*********************************************************************
 ; ǥ�� Ŭ���� 
CLEAR       EQU     01H    ;CLEAR ���

 ; Ŀ�� �� 
CUR_HOME    EQU     02H    ;CURSOR HOME ��ġ�� �̵�

 ; Ŀ���� ���� ������ �����ϰ�,ǥ���� �̵��� ����
ENTRY2      EQU     06H    ; ��巹���� +1 ���� ��Ű��, Ŀ���� ��ũ�� ��� �̵�


 ; ǥ�ú� ON/OFF ����
DCB6        EQU     0EH    ;ǥ��(ON) ,Ŀ��(ON) ,��ũ(OFF)

 ;��� ��Ʈ
FUN5        EQU     38H    ;8��Ʈ 2�� 5*7  1/16 ��Ƽ 

 ;DD RAM ��巹�� ��Ʈ
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 ��° �ٷ� �̵�
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 ��° �ٷ� �̵� 


            ORG     8000H
            CALL    LCD_INIT
            MOV     R4,#00H

            MOV     INST,#01000000B ;CG-RAM �� ��巹�� ����
LOOP:       CALL    INSTWR          

            CALL    LCD_FONT        ;CG-RAM FONT����                             

            MOV     A,INST       
            INC     A               ;CG-RAM�� �ּ� ����
            MOV     INST,A
            INC     R4              ;���� FONT�� ��������, R4 ����
            CJNE    R4,#10H,LOOP 
            
            MOV     LROW,#01H       ;Ŀ�� ��ġ ����
            MOV     LCOL,#05H
            CALL    CUR_MOV
            
            MOV     DATA,#00H       ;����� FONT LCD ȭ�鿡 ����
            CALL    DATAWR
            
            MOV     DATA,#01H
            CALL    DATAWR
            JMP     $              
           
                    
;LCD �ʱ�ȭ ����                                
LCD_INIT:   MOV     INST,#FUN5   
            CALL    INSTWR                            
                 
            MOV     INST,#DCB6    
            CALL    INSTWR

            MOV     INST,#CLEAR     
            CALL    INSTWR

            MOV     INST,#ENTRY2
            CALL    INSTWR       
            RET             
            
; FONT �о��, CG-RAM �� ����
LCD_FONT:   MOV     DPTR,#UFONT
            MOV     A    , R4
            MOVC    A    , @A+DPTR                 
            MOV     DATA , A
            CALL    DATAWR
            RET        

;**************************************************************
;*       ���� ��ƾ: Ŀ���� ��ġ ����(CUR_MOV)                 *
;*            �Է�: Ŀ���� ��� �� < LROW(��) ,LCOL(��) >     *
;*            ���: LCD ȭ��                                  * 
;*            ���: Ŀ�� ��ġ ����                            *
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
;*         ���� ��ƾ: INSTWR                                  *
;*              �Է�: INST                                    *
;*              ���: LCD ȭ��                                *
;*              ���: LCD INSTRUCTION �������� ����           *
;**************************************************************
INSTWR:     CALL     INSTRD
            MOV      DPTR,#LCDWIR
            MOV      A,INST
            MOVX     @DPTR,A 
            RET

;**************************************************************
;*          ���� ��ƾ:DATAW                                   *
;*               �Է�:DATA                                    * 
;*               ���:LCD ȭ��                                *
;*               ���:LCD DATA �������� ����                  *
;**************************************************************
DATAWR:     CALL     INSTRD
            MOV      DPTR,#LCDWDR
            MOV      A,DATA
            MOVX     @DPTR,A
            RET

;**************************************************************
;*          ���� ��ƾ:INSTRD                                  *
;*               �Է�:����                                    *
;*               ���;BUSY                                    *
;*               ���:���� �÷���/��巹�� �б�               *
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








