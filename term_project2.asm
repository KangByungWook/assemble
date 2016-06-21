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
DISNUM	    EQU	    27H	   ; LCD�� �ѷ��� ���� ����
NUM1	    EQU	    28H	   ; ���� �ӽ� �������1
NUM2	    EQU	    29H	   ; ���� �ӽ� �������2
INFO1    EQU     2AH    ; �ð� ���� �ӽ� �������
INFO2    EQU     2BH    ; �� ���� �ӽ� �������
INFO3    EQU     2CH    ; �� ���� �ӽ� �������
YEARINFO EQU     2FH    ; ���� �� ����
MONTHINFO EQU    30H    ; �� �� ����
DAYINFO   EQU    31H    ; �� �� ����

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







          ORG     8000H  
	
;PROGRAMED BY  KIM HYUNG SOO
LEDHOU    EQU     0FFC3H    ; ��(Hour) ǥ�� �ּ�
LEDMIN    EQU     0FFC2H    ; ��(Min)  ǥ�� �ּ�
LEDSEC    EQU     0FFC1H    ; ��(Sec)  ǥ�� �ּ�
ADJUST    EQU     000D9H    ; �ð� �ӵ��� ���߱� ���� ���
                
          LCALL   ALLCLEAR  ; �ʱ�ȭ
                
CLOCK:    MOV     R2,#0008H 
DELAY3:   MOV     R1,#00FFH
DELAY2:   MOV     R0,#00E0H
DELAY1:   DJNZ    R0,DELAY1
          DJNZ    R1,DELAY2
          DJNZ    R2,DELAY3

;******************************************************
;*        920064 �ֱⰡ �ɸ�                          *
;*        1�ʴ� 921600 �ֱⰡ �ʿ� �ϴ�.              *
;*        ����  1536 �ֱⰡ �� �ʿ��ϴ�.            *
;******************************************************
               
          MOV     R4,ADJUST     
ADJUST2:  MOV     R3,#0002H    
ADJUST1:  DJNZ    R3,ADJUST1   
          DJNZ    R4,ADJUST2   

;******************************************************
;*    ADJUST ��ƾ���� �ɸ� �ֱ�                       * 
;*    2*VAR*2 + VAR*3 = 7*VAR CYCLE                   *
;*    VAR=215 , ���� 1505 �ֱⰡ �ȴ�.              *
;*    ������ 31 �ֱ�� 1�ʸ� ǥ���ϴ� ��ƾ����        *
;******************************************************
CONDITON: CJNE    R5,#59H,SEC     ; �� ���� �� 
                                       
          CJNE    R6,#59H,MIN     ; �� ���� ��
                                       
          CJNE    R7,#23H,HOUR    ; �� ���� ��
                                       
          LCALL   ALLCLEAR        ; 23:59:59 -> 00:00:00
          LJMP    CLOCK           ; CLOCK���� �б�
                          
SEC:      MOV     A,R5          
          ADD     A,#1H           ; �� ���� ����
          DA      A               ; ������ ǥ��
          MOV     R5,A          
          LCALL   DISSEC          ; �� ǥ�� ��ƾ ȣ��
          LJMP    CLOCK           ; CLOCK���� �б�
                 
               
MIN:      MOV     A,R6               
          ADD     A,#1H           ; �� ���� ����
          DA      A               ; ������ ǥ��    
          MOV     R6,A
          LCALL   CLRSEC          
          LCALL   DISMIN          ; �� ǥ�� ��ƾ ȣ��
          MOV     A,#00H       
          LCALL   DISSEC          ; �� 00 ǥ�� 
          LJMP    CLOCK           ; CLOCK���� �б�
                 
                
HOUR:     MOV     A,R7
          ADD     A,#1H           ; �� ���� ���� 
          DA      A               ; ������ ǥ��
          MOV     R7,A
          LCALL   CLRMIN
          LCALL   DISHOU          ; �� ǥ�� ��ƾ ȣ��       
          MOV     A,#00H
          LCALL   DISMIN 
          LCALL   DISSEC
          LJMP    CLOCK
      
ALLCLEAR: LCALL   CLRHOU          ; ǥ�� �ʱ�ȭ ��ƾ
          MOV     A,#00H         
          LCALL   DISHOU
          LCALL   DISMIN
          LCALL   DISSEC
          RET
                                
CLRHOU:   MOV     R7,#0H          ; ���� �ʱ�ȭ ��ƾ
CLRMIN:   MOV     R6,#0H
CLRSEC:   MOV     R5,#0H
          RET
                                
DISHOU:   MOV     DPTR,#LEDHOU    ; �� ǥ�� ��ƾ
          MOVX    @DPTR,A        
          RET                    
                                 
DISMIN:   MOV     DPTR,#LEDMIN    ; �� ǥ�� ��ƾ 
          MOVX    @DPTR,A
          RET

DISSEC:   MOV     DPTR,#LEDSEC    ; �� ������ ������Ʈ �� �� LCD�� ������Ʈ
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

;LCD �ʱ�ȭ ����                                
LCD_INIT:   
		MOV     INST,#FUN5   
		CALL    INSTWR                            
           	      
          	MOV     INST,#DCB6    
          	CALL    INSTWR

          	MOV     INST,#CLEAR     
          	CALL    INSTWR
	
            	MOV     INST,#ENTRY2
          	CALL    INSTWR 
	       
            
            
;�ʱ� �޼��� ǥ��

LCD_MESG:   
	;�ð� ���� ���
	MOV	INFO1, R7
	MOV	INFO2, R6
	MOV	INFO3, R5
	
	;ù��° �� �ð� ���� ���� �Ѹ���
	    MOV     LROW,#01H ; ���� ���� ��ġ(��), 01H=ù��° ��, 01H=�ι�° ��
            MOV     LCOL,#06H ; ���� ���� ��ġ(��)
            CALL    CUR_MOV
            MOV     INST,#ENTRY2
            CALL    INSTWR 
 	    MOV     DPTR,#CLOCKS

	    MOV     FDPL,DPL
            MOV     FDPH,DPH
	    
	    ;�ð�����            
            MOV     NUMFONT,#02H
	    MOV	    A, INFO1
	    MOV     B, #10H
	    DIV     AB
	    MOV	    NUM1, A
	    MOV     NUM2, B
	    MOV     DISNUM,NUM1		;�ð����� ���ڸ�
	    CALL    DISFONT 
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,NUM2		;�ð����� ���ڸ�
	    CALL    DISFONT
	    
	    ;�ݷ�
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,#0AH
	    CALL    DISFONT
	    
	    
	    ;�� ����
	    MOV     LCOL,#09H
	    CALL    CUR_MOV
	    MOV	    A, INFO2
	    MOV     B, #10H
	    DIV     AB
	    MOV	    NUM1, A
	    MOV     NUM2, B
	    MOV     DISNUM,NUM1		;������ ���ڸ�
	    CALL    DISFONT
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,NUM2		;������ ���ڸ�
	    CALL    DISFONT

	    ;�ݷ�
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,#0AH
	    CALL    DISFONT
	    
	    
	    ;�� ����
	    MOV     LCOL,#0CH
	    CALL    CUR_MOV
	    MOV	    A, INFO3
	    MOV     B, #10H
	    DIV     AB
	    MOV	    NUM1, A
	    MOV     NUM2, B
	    MOV     DISNUM,NUM1		;������ ���ڸ�
	    CALL    DISFONT
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,NUM2		;������ ���ڸ�
	    CALL    DISFONT
	   
	;�ι�° �� ���� �Ѹ��� ����
            MOV     LROW,#02H
            MOV     LCOL,#06H
            CALL    CUR_MOV
	    ;������ ���� �ʱ�ȭ(�ϴ� �ӽð�����)
	    MOV YEARINFO, #16
	    MOV MONTHINFO, #6
	    MOV DAYINFO, #21
 	    
	    ;�� ����
            MOV 	A,YEARINFO
	    MOV		B,#10
	    DIV		AB
	    MOV		NUM1,A
	    MOV		NUM2,B
	    MOV		DISNUM,NUM1	;�� ���� ���ڸ�
            CALL    DISFONT
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,NUM2		;������ ���ڸ�
	    CALL    DISFONT
	    
	    ;���� ����
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,#0BH
	    CALL    DISFONT
	    
	    ;�� ����
	    MOV     	LCOL,#09H
	    CALL    	CUR_MOV
    	    MOV 	A,MONTHINFO
	    MOV		B,#10
	    DIV		AB
	    MOV		NUM1,A
	    MOV		NUM2,B
	    MOV		DISNUM,NUM1	;�� ���� ���ڸ�
            CALL   	DISFONT
	    INC	   	LCOL
	    CALL   	CUR_MOV
	    MOV     	DISNUM,NUM2		;������ ���ڸ�
	    CALL	DISFONT
	    
	    ;���� ����
	    INC	    LCOL
	    CALL    CUR_MOV
	    MOV     DISNUM,#0BH
	    CALL    DISFONT

	    ;�� ����
	    MOV     	LCOL,#0CH
	    CALL    	CUR_MOV
    	    MOV 	A,DAYINFO
	    MOV		B,#10
	    DIV		AB
	    MOV		NUM1,A
	    MOV		NUM2,B
	    MOV		DISNUM,NUM1	;�� ���� ���ڸ�
            CALL   	DISFONT
	    INC	   	LCOL
	    CALL   	CUR_MOV
	    MOV     	DISNUM,NUM2	;�� ���� ���ڸ�
	    CALL	DISFONT
            RET


;*************************************************************
;*           ���� ��ƾ: DISFONT                              *
;*                �Է�: ����                                 *
;*                ���: LCD ȭ��                             *
;*                ���: ���� ��Ʈ�� �о�� LCD�� ǥ��        *
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
;*          ���� ��ƾ:DATAWR                                  *
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
 
CLOCKS: DB '0','1','2','3','4'
	 DB '5','6','7','8','9'
	 DB ':','-'          
      
END