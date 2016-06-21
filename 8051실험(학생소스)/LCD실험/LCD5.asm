; LCD ����5 ~ LCD ���� �̵��ϱ� 

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
NUMFONT     EQU     24H    ; �޼��� ���� ���� 
FDPL        EQU     25H    ; DPL �� ����
FDPH        EQU     26H    ; DPH �� ����

;DEFINE LCD INSTRUCTION 
;**********************************************************
 ; ǥ�� Ŭ���� 
CLEAR       EQU     01H    ;CLEAR ���

 ; Ŀ�� �� 
CUR_HOME    EQU     02H    ;CURSOR HOME ��ġ�� �̵�

 ; Ŀ���� ���� ������ �����ϰ�,ǥ���� �̵��� ����
ENTRY2      EQU     06H    ; ��巹���� +1 ���� ��Ű��, Ŀ���� ��ũ�� ��� �̵�

 ; ǥ�ú� ON/OFF ����
DCB6        EQU     0EH    ;ǥ��(ON) ,Ŀ��(ON) ,��ũ(OFF)

 ;Ŀ�� ǥ�� �̵�
DR_SHIFT    EQU     1CH    ;ǥ�� ��ü�� ��� �̵�

 ;��� ��Ʈ
FUN5        EQU     38H    ;8��Ʈ 2�� 5*7  1/16 ��Ƽ 

 ;DD RAM ��巹�� ��Ʈ
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 ��° �ٷ� �̵�
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 ��° �ٷ� �̵� 


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
            
; �޼��� ǥ��
LCD_MESG:   MOV     DPTR,#MESSAGE
            MOV     FDPL,DPL
            MOV     FDPH,DPH            
            MOV     NUMFONT,#0DH
            CALL    DISFONT
            RET
 
;*************************************************************
;*           ���� ��ƾ: DISFONT                              *
;*                �Է�: ����                                 *
;*                ���: LCD ȭ��                             *
;*                ���: ���� ��Ʈ�� �о�� LCD�� ǥ��        *
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
     
;*********************************************************
;*        DEFINE  MESSAGE                                *
;*********************************************************
MESSAGE:    DB 'D','O',' ','Y','O'
            DB 'U','R',' ','B','E'
            DB 'S','T','!'
            
;*********************************************************
;*       ���� ��ƾ: DELAY                                *
;*********************************************************
DELAY:      MOV   R7,#03H
DELAY1:     MOV   R6,#0FFH
DELAY2:     MOV   R5,#0FFH
DELAY3:     DJNZ  R5,DELAY3
            DJNZ  R6,DELAY2
            DJNZ  R7,DELAY1
            RET
END








