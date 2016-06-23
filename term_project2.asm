; LCD ����3 ~ LCD�� ���� ���� 

;*******************************************************************                      
LCDWIR      EQU     0FFE0H  ; LCD IR ����
LCDWDR      EQU     0FFE1H  ; LCD DR ����
LCDRIR      EQU     0FFE2H  ; LCD IR �б�
LCDRDR      EQU     0FFE3H  ; LCD DR �б�

;Ű�е�
DATAOUT   EQU      0FFF0H  ;������ �ƿ��� �ּ�
DATAIN    EQU      0FFF1H  ;������ ���� �ּ�
DLED      EQU      0FFC1H  ;������ 2���� 7_SEGMENT �ּ�
ALED0     EQU      0FFC2H  ;�߰� 2���� 7_SEGMENT �ּ�
ALED1     EQU      0FFC3H  ;���� 2���� 7_SEGMENT �ּ�
BUZZER    EQU      0FFEFH

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
MODE_STATUS	EQU	32H; ���׸��(00H), �������(01H), ��ݸ��(10H), �������(11H)
STATICHOURINFO	EQU	33H ; ������带 ���� ���� �ð���
STATICMININFO	EQU	34H ; ������带 ���� ���� �а�
STATICSECINFO	EQU	35H ; ������带 ���� ���� �ʰ�
KEYBOARD_INPUT	EQU	36H ; Ű���� �Է°� �������
DOOR_STATUS	EQU	37H ; ���� �����ִ��� �ȿ����ִ��� ����

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
	MOV	MODE_STATUS, #00H
	
	MOV STATICHOURINFO, #00H
	MOV STATICMININFO, #00H
	MOV STATICSECINFO, #00H
	MOV DOOR_STATUS, #00H
	
	
	

	
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
	
	
	; ��尪�� ���� LCD�� �ٸ��� ǥ��  
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
	; ������带 ���� ���� �ð����� ���
	MOV STATICHOURINFO, R7
	MOV STATICMININFO, R6
	MOV STATICSECINFO, R5
	;ù��° �� �ð� ���� ���� �Ѹ���
	MOV     LROW,#01H ; ���� ���� ��ġ(��), 01H=ù��° ��, 01H=�ι�° ��
	MOV     LCOL,#06H ; ���� ���� ��ġ(��)
            
	MOV     INST,#ENTRY2
	CALL    INSTWR 
	CALL    CUR_MOV
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
	MOV	A, INFO3
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
	   
	MOV 	A, DOOR_STATUS
	CJNE	A, #00H, DOOR_OPEN
	    				;����� ���� ǥ��
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

DIS_SECOND_LINE: ;�ι�° �� ���� �Ѹ��� ����
	MOV     LROW,#02H
	MOV     LCOL,#06H
	CALL    CUR_MOV
	    
	;������ ���� �ʱ�ȭ(�ϴ� �ӽð�����)
	MOV YEARINFO, #16
	MOV MONTHINFO, #21
	MOV DAYINFO, #32
 	    
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
	MOV     LCOL,#0CH
	CALL    CUR_MOV
	MOV 	A,DAYINFO
	MOV	B,#10
	DIV	AB
	MOV	NUM1,A
	MOV	NUM2,B
	MOV	DISNUM,NUM1	;�� ���� ���ڸ�
	CALL   	DISFONT
	INC	   LCOL
	CALL   	CUR_MOV
	MOV     	DISNUM,NUM2	;�� ���� ���ڸ�
	CALL	DISFONT
	    
	; ��� ǥ���ϱ�
	INC LCOL
	INC	   	LCOL
	CALL   	CUR_MOV
	MOV     	DISNUM,#0FH	;�� ���� ���ڸ�
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
	  	;ù��° �� �ð� ���� ���� �Ѹ���
	MOV     LROW,#01H ; ���� ���� ��ġ(��), 01H=ù��° ��, 01H=�ι�° ��
	MOV     LCOL,#06H ; ���� ���� ��ġ(��)
            
	MOV     INST,#ENTRY2
	CALL    INSTWR 
	CALL    CUR_MOV
	MOV     DPTR,#CLOCKS

	MOV     FDPL,DPL
	MOV     FDPH,DPH
	    
	;�ð�����            
	MOV     NUMFONT,#02H
	MOV	    A, STATICHOURINFO
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
	MOV	    A, STATICMININFO
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
	MOV	    A, STATICSECINFO
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

	MOV 	A, DOOR_STATUS
	CJNE	A, #00H, DOOR_OPEN_MODI
	    				;����� ���� ǥ��
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
	;�ι�° �� ���� �Ѹ��� ����
	MOV     LROW,#02H
	MOV     LCOL,#06H
	CALL    CUR_MOV
	    
 	    
	;�� ����
	MOV 	A,YEARINFO
	MOV	B,#10
	DIV	AB
	MOV	NUM1,A
	MOV	NUM2,B
	MOV	DISNUM,NUM1	;�� ���� ���ڸ�
	CALL    DISFONT
	INC	LCOL
	CALL    CUR_MOV
	MOV     DISNUM,NUM2		;������ ���ڸ�
	CALL    DISFONT
	    
	;���� ����
	INC	LCOL
	CALL    CUR_MOV
	MOV     DISNUM,#0BH
	CALL    DISFONT
	    
	;�� ����
	MOV     LCOL,#09H
	CALL    CUR_MOV
	MOV 	A,MONTHINFO
	MOV	B,#10
	DIV	AB
	MOV	NUM1,A
	MOV	NUM2,B
	MOV	DISNUM,NUM1	;�� ���� ���ڸ�
	CALL   	DISFONT
	INC	LCOL
	CALL   	CUR_MOV
	MOV     DISNUM,NUM2		;�� ���� ���ڸ�
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
		
	; ��� ǥ���ϱ�
	INC LCOL
	INC	LCOL
	CALL   	CUR_MOV
	MOV    	DISNUM,#10H	;M
	CALL	DISFONT

	 ;�ι�° �� ���� �Ѹ��� ����
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




;Ű �е� �������̽� ����

SCANN:     	    		
	PUSH     PSW     ; PSW ���� ���ÿ� ����
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
           JNC	KEY_RET       ; ��� ���� ��ĵ������, �ٽ� ���� 
           JMP      COLSCAN       ; ���� ���� ��ĵ�� ���� �б�


RSCAN:     MOV      R2,#00H       ; R2 ���� �� ����
ROWSCAN:   RRC      A             ; ��� ���� "1" �� �ٲ������ ����
           JC       MATRIX        ; ĳ���� �߻��ϸ�, MATRIX�� �б�
           INC      R2            ; ĳ���� �߻����� ������, ���� ������ �̵�
           JMP      ROWSCAN       ; ���� ���� ��ĵ�� ���� �б�

MATRIX:    
	MOV      A,R2          ; R2 ���� ���� �� ����
        MOV      B,#05H        ; 1���� 5���� �̷����
	MUL      AB            ; 2���� �迭�� 1���� �迭�� ���� �ٲ�
	ADD      A,R1          ; R1 ���� ���� �� ����
	CALL     INDEX         ; Ű �ڵ� ���� ����
	CALL     DISPLAY       ; Ű �ڵ� ���� ǥ�� 
	;POP      PSW           ; �������� ���� PSW���� ������ ��
	
	JMP	KEY_RET                   ; ���� ��ƾ���� ����
KEY_RET:
	POP	PSW
	JMP	LCD_ROUTINE_END

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

;*************************************************************
;*           ���� ��ƾ: DISSTRING                              *
;*                �Է�: ����                                 *
;*                ���: LCD ȭ��                             *
;*                ���: ���� ��Ʈ�� �о�� LCD�� ǥ��        *
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
	 DB ':','-','D','C', 'O'
	 DB 'R','M'

DOOR_CLOSE: DB 'D','C'
RUNNING: DB 'R'
MODI: DB 'M'

;*****************************************************************
;*         ���� ��ƾ : SUBKEY                                    *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : ������ �ƿ����� �����͸� ��������         *
;*                     ������ ������ ����� Ȯ��                 * 
;*****************************************************************
SUBKEY:    NOP
	   MOV	    R0, A
	   MOV      DPTR,#DATAOUT
           MOVX     @DPTR,A
           MOV      DPTR,#DATAIN
           MOVX     A,@DPTR
           RET

;*****************************************************************
;*         ���� ��ƾ : DISPLAY                                   *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : Ű �ڵ尪�� 7_SEGMENT �� ǥ��             *
;*****************************************************************
DISPLAY:   MOV      DPTR,#DLED
           MOVX     @DPTR,A
	   
	   MOV	KEYBOARD_INPUT, A ; �Է°� ���
	
	   MOV	A, MODE_STATUS
	   CJNE	A, #00H, NOT_RUN_MODE	;���׸��
	   MOV	A, KEYBOARD_INPUT	
	   CJNE	A, #0BH, INTERRUPT_END
	   MOV MODE_STATUS, #01H	;B��ư�� ������ �� �������� ����
	   JMP	INTERRUPT_END

NOT_RUN_MODE:				
	CJNE A, #01H, NOT_MODI_MODE	;�������
	MOV	A, KEYBOARD_INPUT	
	CJNE	A, #0BH, NOT_B
	MOV MODE_STATUS, #00H	;B��ư�� ������ �� ���׸��� ����
	
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