; LCD ����3 ~ LCD�� ���� ���� 

;*******************************************************************                      
LCDWIR      EQU     0FFE0H  ; LCD IR ����
LCDWDR      EQU     0FFE1H  ; LCD DR ����
LCDRIR      EQU     0FFE2H  ; LCD IR �б�
LCDRDR      EQU     0FFE3H  ; LCD DR �б�

;DEFINE VARIABLE
;********************************************************************
;LCD ���� ����
INST        EQU     20H    ; LCD INSTRUCTION �� ����
DATA        EQU     21H    ; LCD DATA �� ����
LROW        EQU     22H    ; LCD ǥ�� ��ǥ: ���� �� ����  
LCOL        EQU     23H    ; LCD ǥ�� ��ǥ: ���� �� ����
NUMFONT     EQU     24H    ; �޼��� ���� ���� 
FDPL        EQU     25H    ; DPL �� ����
FDPH        EQU     26H    ; DPH �� ���� 

; �ð���� ����
INFO_H	EQU	26H	; ���� �ð��� hour�� ����
INFO_M	EQU	27H	; ���� �ð��� minute�� ����
INFO_S	EQU	28H	; ���� �ð��� second�� ����



;DEFINE LCD INSTRUCTION 
;*********************************************************************
 ; ǥ�� Ŭ���� 
CLEAR       EQU     01H    ;CLEAR ����

 ; Ŀ�� �� 
CUR_HOME    EQU     02H    ;CURSOR HOME ��ġ�� �̵�

 ; Ŀ���� ���� ������ �����ϰ�,ǥ���� �̵��� ����
ENTRY2      EQU     06H    ; ��巹���� +1 ���� ��Ű��, Ŀ���� ����ũ�� ��� �̵�

 ; ǥ�ú� ON/OFF ����
DCB6        EQU     0EH    ;ǥ��(ON) ,Ŀ��(ON) ,����ũ(OFF)

 ; ��� ��Ʈ
FUN5        EQU     38H    ;8��Ʈ 2�� 5*7  1/16 ��Ƽ 

 ;DD RAM ��巹�� ��Ʈ
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 ��° �ٷ� �̵�
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 ��° �ٷ� �̵� 


            
	    ORG     8000H

DISPLAY_TIME: CALL LCD_INIT
		

;LCD �ʱ�ȭ ����                                
LCD_INIT:   MOV     INST,#FUN5   
            CALL    INSTWR                            
                 
            MOV     INST,#DCB6    
            CALL    INSTWR

            MOV     INST,#CLEAR     
            CALL    INSTWR

            MOV     INST,#ENTRY2
            CALL    INSTWR 
	       
            
            
;�ʱ� �޼��� ǥ��

LCD_MESG:   
	;ù��° �� ���� �Ѹ���
	    MOV     LROW,#01H ; ���� ���� ��ġ(��), 01H=ù��° ��, 01H=�ι�° ��
            MOV     LCOL,#06H ; ���� ���� ��ġ(��)
            CALL    CUR_MOV
            MOV     INST,#ENTRY2
            CALL    INSTWR 
 	    MOV     DPTR,#MESSAGE1

	
            MOV     FDPL,DPL
            MOV     FDPH,DPH            
            MOV     NUMFONT,#08H
            CALL    DISFONT 
	    
	   
	;�ι�° �� ���� �Ѹ��� ����
            MOV     LROW,#02H
            MOV     LCOL,#06H
            CALL    CUR_MOV
 
            MOV     DPTR,#MESSAGE2
            MOV     FDPL,DPL
            MOV     FDPH,DPH                                 
            MOV     NUMFONT,#08H
            CALL    DISFONT

	
            JMP     $


;*************************************************************
;*           ���� ��ƾ: DISFONT                              *
;*                �Է�: ����                                 *
;*                ���: LCD ȭ��                             *
;*                ���: ���� ��Ʈ�� �о�� LCD�� ǥ��        *
;*************************************************************
DISFONT:    MOV     R5,#00H      
FLOOP:      MOV     DPL,FDPL
            MOV     DPH,FDPH 
	    MOV     A,R5
            MOVC    A,@A+DPTR                 
            MOV     DATA,A

            CALL    DATAWR
            INC     R5
            MOV     A,R5
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


;***************************************************************
;*         DEFINE  MESSAGE                                     *
;***************************************************************
MESSAGE1:   DB '1','6',':','3','0'
            DB ':','2','5'
            
MESSAGE2:   DB '1','6','-','0','6'
            DB '-','1','0'  
NUMBERS: DB '0','1','2','3','4'
	 DB '5','6','7','8','9'          
END