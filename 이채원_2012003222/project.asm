
  	    ORG	   8000H

DATAOUT     EQU     0FFF0H  ;������ �ƿ��� �ּ�
DATAIN      EQU     0FFF1H  ;������ ���� �ּ�

ALED	    EQU	    6AH	    ;LED�� ���ð�
CMP	    EQU	    6BH	    ;��Ʈ���� ������ ���� ��

;�Ǻ��� 3���� ����
NUM1	    EQU     60H
NUM2	    EQU	    61H
NUM3	    EQU	    62H


GOTNUM	    EQU	    53H	    ;���� ������ ���� ����
SLOC	    EQU	    54H	    ;������ ��ġ�� �ӽ�����
COUNT	    EQU	    55H	    ;��ī��Ʈ �ӽ�����

STRIKE	    EQU	    56H	    ;��Ʈ����ũ ��
BALL	    EQU	    57H	    ;�� ��

ERRNUM	    EQU	    58H	    ;Ʋ�� Ƚ��

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
;*********************************************************************
 ; ǥ�� Ŭ���� 
CLEAR       EQU     01H    ;CLEAR ���

 ; Ŀ�� �� 
CUR_HOME    EQU     02H    ;CURSOR HOME ��ġ�� �̵�

 ; Ŀ���� ���� ������ �����ϰ�,ǥ���� �̵��� ����
ENTRY2      EQU     06H    ; ��巹���� +1 ���� ��Ű��, Ŀ���� ��ũ�� ��� �̵�

 ; ǥ�ú� ON/OFF ����
DCB6        EQU     0EH    ;ǥ��(ON) ,Ŀ��(ON) ,��ũ(OFF)

 ; ��� ��Ʈ
FUN5        EQU     38H    ;8��Ʈ 2�� 5*7  1/16 ��Ƽ 

 ;DD RAM ��巹�� ��Ʈ
LINE_1      EQU     80H    ;1 000 0000 : LCD 1 ��° �ٷ� �̵�
LINE_2      EQU     0C0H   ;1 010 0000 : LCD 2 ��° �ٷ� �̵� 


	   MOV	    STRIKE,#00H
	   MOV	    BALL,#00H
	   
	   MOV	    50H,#20H
	   MOV	    51H,#20H
	   MOV	    52H,#20H
	   MOV	    GOTNUM,#00H

	   MOV 	    R7,#00H ; R7�� 40H�� �̿��� ó�� ���� ��쿡�� LCD����
	   MOV	    40H,#00H

	   MOV	    ERRNUM,#00H
	   MOV	    CMP,#00000001B
 
	   MOV	    ALED,#00000000B      ;LED�� ��� �Ҵ�      
	   MOV	    P1,ALED


;�������Ϳ� �ִ� �����Ⱚ�� �̿��Ͽ� �������� ���Ѵ�
RAND:	   MOV	    A,R0
	   ANL	    A,#00001111B	;���� 4��Ʈ�� ���Ѵ�
	   SUBB	    A,#0AH	        ;10�� ��
	   JC	    RSTORE1	        ;ĳ�� �߻��ϸ� RESTORE
RE1:	   ADD	    A,#30H	        ;���� ���� �ּҰ����� ��ȯ
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
	       

;***************KEYPAD �Է� ��ƾ****************** 
KEYPAD:    CALL     SCANN   ; ��ĵ ��ƾ ȣ��
	   MOV 	    A,GOTNUM
	   CJNE	    A,#03H,KEYPAD;3�� �����ϸ� �ʱ�ȭ
	   INC	    ERRNUM
	   MOV	    GOTNUM,#00H
	   MOV	    50H,#20H
	   MOV	    51H,#20H
	   MOV	    52H,#20H

	   MOV	    A,STRIKE
	   MOV	    STRIKE,#00H
	   MOV	    BALL,#00H
	   CJNE	    A,#03H,ISERR
	   MOV	    ALED,#00000000B ;��ü�� �����״��ϱ� ����
	   CALL	    ISEND
	   RET

;Ʋ���� ��
ISERR:	   MOV	    A,ALED	;Ʋ���� �� LED�� �ϳ��� ����
	   ADD	    A,CMP
	   MOV	    ALED,A

	   MOV	    P1,ALED

	   MOV	    A,CMP	;���ڸ��� �������� ����Ʈ�� 
	   RL	    A	        ;LED���� �ϳ��� ����
	   MOV	    CMP,A

	   MOV	    A,ERRNUM
	   CJNE	    A,#08H,KEYPAD   ;8�� Ʋ���� ��
	   MOV	    ALED,#11110000B ;4���� �����ư��� ����
	   CALL	    ISEND	   

	   RET 

;���� ������ ��
ISEND:	   MOV	    P1,ALED     
	   MOV	    A,ALED
	   CPL	    A          ;������ ���� �����״� �Ѵ�
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

SCANN:     PUSH     PSW     ; PSW ���� ���ÿ� ����
           SETB     PSW.4   ; ��ũ3 �������� ���
           SETB     PSW.3

INITIAL:   MOV      R1,#00H       ; R1�� �ʱ�ȭ
           MOV      A,#11101111B  ; ������ �ƿ��� �ʱⰪ

COLSCAN:   MOV      R0,A          ; R0�� ������ �ƿ� �� ���� 
           INC      R1            ; R1 ���� �� ���� 
           CALL     SUBKEY        ; Ű �е� �Է� ���� ����
           ANL      A,#00011111B  ; ���� 3��Ʈ ����
           XRL      A,#00011111B  ; XRL ����000111111
           JNZ      RSCAN         ; ����� ���� 0 �� �ƴϸ�, �� ��ĵ
           MOV      A,R0           
           SETB     C
           RRC      A             ; ���� ���� �̵�
           JNC      INITIAL       ; ��� ���� ��ĵ������, �ٽ� ���� 
           JMP      COLSCAN       ; ���� ���� ��ĵ�� ���� �б�

RSCAN:     MOV      R2,#00H       ; R2 ���� �� ����
ROWSCAN:   RRC      A             ; ��� ���� "1" �� �ٲ������ ����
           	   
FIND:      JC       MATRIX        ; ĳ���� �߻��ϸ�, MATRIX�� �б�
           INC      R2            ; ĳ���� �߻����� ������, ���� ������ �̵�
           JMP      ROWSCAN       ; ���� ���� ��ĵ�� ���� �б�

NOTLCD:	   MOV	    40H,#01H
	   JMP	    FIND

MATRIX: 
	   MOV      A,R2          ; R2 ���� ���� �� ����
           MOV      B,#05H        ; 1���� 5���� �̷����
           MUL      AB            ; 2���� �迭�� 1���� �迭�� ���� �ٲ�
           ADD      A,R1          ; R1 ���� ���� �� ����
           CALL     INDEX         ; Ű �ڵ� ���� ����
	   POP      PSW 	  ; �������� ���� PSW���� ������ ��
	   
	   MOV 	    40H,R7
	   MOV	    41H,A
	   CJNE	    A,40H,LCD_INIT; ������ �ٸ� Ű�� ���� ��쿡�� LCD����
BACK: 	   MOV	    R7,41H	  
               
           RET                    ; ���� ��ƾ���� ����
;****************************************************************

;*****************************************************************
;*         ���� ��ƾ : SUBKEY                                    *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : ������ �ƿ����� �����͸� ��������         *
;*                     ������ ������ ����� Ȯ��                 * 
;*****************************************************************
SUBKEY:    MOV      DPTR,#DATAOUT
           MOVX     @DPTR,A
           MOV      DPTR,#DATAIN
           MOVX     A,@DPTR
           RET

;*****************************************************************
;*         ���� ��ƾ : INDEX                                     *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : Ű �ڵ尪�� ����                          * 
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



;***********************LCD ���***********************
                              
LCD_INIT:   MOV     40H,#00H
	    MOV	    R6,A	   ;���� Ű�� R6�� ����

	    MOV     INST,#FUN5   
            CALL    INSTWR                            
                 
            MOV     INST,#DCB6    
            CALL    INSTWR

            MOV     INST,#CLEAR     
            CALL    INSTWR

            MOV     INST,#ENTRY2
            CALL    INSTWR       
            
	    ;�ʱ� �޼��� ǥ��
            MOV     LROW,#01H
            MOV     LCOL,#02H
            CALL    CUR_MOV
            
	    MOV	    A,#50H	   ;50H~52H�� �Է¹��� �� ����
	    ADD	    A,GOTNUM
	    MOV	    R1,A	   
	    MOV	    SLOC,R6
	    MOV	    @R1,SLOC
            CALL    DISFONT

	    INC	    GOTNUM	   ;�Է¹��� ���� ������ 1�� �ջ�

EXPCHK:	    MOV	    A,SLOC
	    CJNE    A,#4EH,TRDCHK

	    CALL    EXPHDL
	    MOV	    GOTNUM,#00H
	    MOV	    50H,#20H
	    MOV	    51H,#20H
	    MOV	    52H,#20H

            JMP     BACK

TRDCHK:	    MOV	    A,GOTNUM
	    CJNE    A,#03H,BACK  ;3���� �Է¹����� �ι�°�� ���
	    
	    CALL    CUR_MOV2
	    CALL    RSLTCHK

	    JMP	    BACK

;���� �̿��� ���� �������� ����ó��
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
;STRIKE�� BALL�� ������ �ľ��Ѵ�
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
;*           ���� ��ƾ: DISFONT                              *
;*                �Է�: ����                                 *
;*                ���: LCD ȭ��                             *
;*                ���: ���� ��Ʈ�� �о�� LCD�� ǥ��        *
;*************************************************************
DISFONT:    MOV     R5,#00H   
	    CALL    DATAWR
            RET        

;**************************************************************
;*       ���� ��ƾ: Ŀ���� ��ġ ����(CUR_MOV)                 *
;*            ���: LCD ȭ��                                  * 
;*            ���: Ŀ�� ��ġ�� ù��° �ٷ�                   *
;**************************************************************  
CUR_MOV:    MOV     A,#LINE_1
            ADD     A ,#06H
            MOV     INST,A
            CALL    INSTWR
            JMP     RET_POINT                 

RET_POINT:  RET

;**************************************************************
;*       ���� ��ƾ: Ŀ���� ��ġ ����(CUR_MOV2)                *
;*            ���: LCD ȭ��                                  * 
;*            ���: Ŀ�� ��ġ�� �ι�° �ٷ�                   *
;**************************************************************  
CUR_MOV2:   MOV     A,#LINE_2
            ADD     A ,#04H
            MOV     INST,A
            CALL    INSTWR
            JMP     RET_POINT2                 

RET_POINT2:  RET

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
;*               ���:�Է¹��� ���� ���                      *
;**************************************************************
DATAWR:     CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,50H	    ; Ű�е�� ���� �� ����
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
;*          ���� ��ƾ:DATAW                                   *
;*               �Է�:DATA                                    * 
;*               ���:LCD ȭ��                                *
;*               ���:STRIKE�� BALL ������ ���               *
;**************************************************************
RSLTWR:     CALL     INSTRD
	    MOV      DPTR,#LCDWDR
	    MOV      A,#53H	    ; Ű�е�� ���� �� ����
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
