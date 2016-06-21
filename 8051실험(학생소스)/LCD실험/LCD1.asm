; LCD ����1 ~ LCD �ʱ�ȭ 

; ���� ���忡 �ִ� LCD �ּ�                      
LCDWIR      EQU     0FFE0H  ; LCD IR ����
LCDWDR      EQU     0FFE1H  ; LCD DR ����
LCDRIR      EQU     0FFE2H  ; LCD IR �б�
LCDRDR      EQU     0FFE3H  ; LCD DR �б�

;DEFINE VARIABLE
;********************************************************************
INST        EQU     20H    ; LCD INSTRUCTION �� ����
DATA        EQU     21H    ; LCD DATA �� ����
BUSY        EQU     22H    ; LCD BUSY FLAG/ADDRESS ���� �� ���� 

;DEFINE LCD INSTRUCTION 
;*********************************************************************
 ; ǥ�� Ŭ���� 
CLEAR       EQU     01H    ;CLEAR ���
 ; Ŀ���� ���� ������ �����ϰ�,ǥ���� �̵��� ����
ENTRY2      EQU     06H    ; ��巹���� +1 ���� ��Ű��, Ŀ���� ��ũ�� ��� �̵�
 ; ǥ�ú� ON/OFF ����
DCB6        EQU     0EH    ; ǥ��(ON) ,Ŀ��(ON) ,��ũ(OFF)
 ; ��� ��Ʈ
FUN5        EQU     38H    ; 8��Ʈ 2�� 5*7  1/16 ��Ƽ 

            ORG     8000H
                            
LCD_INIT:   
            MOV     INST,#FUN5   
            CALL    INSTWR
                            
            MOV     INST,#DCB6    
            CALL    INSTWR
            
            MOV     INST,#CLEAR     
            CALL    INSTWR                                     
            
            MOV     INST,#ENTRY2
            CALL    INSTWR       
            JMP     $

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

END