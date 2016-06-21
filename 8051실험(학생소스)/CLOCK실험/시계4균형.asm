	  ORG    8000H 
LEDHOU    EQU    0FFC3H ; �� ǥ�� �ּ� 
LEDMIN    EQU    0FFC2H ; �� ǥ�� �ּ�
LEDSEC    EQU    0FFC1H ; �� ǥ�� �ּ�

VSEC      EQU    30H    ; �� ���� ����
VMIN      EQU    31H    ; �� ���� ����
VHOUR     EQU    32H    ; �� ���� ����

;*************************************************
;*  �ð��� �Ϻ��ϰ� ���߱� ���Ͽ� �� �н��� ���� *
;*  ������ Ÿ���� �����ϰ�, ������ ����          *
;*************************************************

          MOV    VSEC,#0  ; ��,��,�� ���� �ʱ�ȭ
          MOV    VMIN,#0
          MOV    VHOUR,#0
          CALL   DISPLAY  ; 00:00:00 ���� �ð� ���� ����

RUN:      MOV    R2,#0008H 

DELAY3:   MOV    R1,#00FFH
DELAY2:   MOV    R0,#00E0H
DELAY1:   DJNZ   R0,DELAY1
          DJNZ   R1,DELAY2
          DJNZ   R2,DELAY3

;*************************************************
;*        DELAY ������ �ð� ���� 920064 �ֱ�     *
;*        1�ʴ� 921600 �ֱ�                      *
;*        921600 - 1 - 920064 - 56 = 1479        *
;*        1481 �ֱⰡ �� �ʿ���                  *
;*************************************************
          MOV    R3,#147        ; 1 --> 1478= 37*40

REPEAT:   MOV    R1,#1          ; 1 
          LCALL  VALANCE        ; 2+ 2*1 + 3 = 7  
          DJNZ   R3,REPEAT      ; 2  
               
;*************************************************
;          1481 -1420 = 61                       *
;*************************************************
          MOV    R1,#1          ; 1
          LCALL  VALANCE        ; 2+2*1+3= 7

;*************************************************                
          CALL   UPDATE 
          SJMP   RUN            ; 56 CYCLE
;*************************************************

;CYCLE COUNT 1(FIRST LINE) + CONDITION 30 + DISPLAY 19 +  RET 2 
; = 52 CYCLE

UPDATE:   MOV    R0,#VSEC      
          CJNE   @R0,#59H,SEC   ; �� ���� ��                  2;TOTAL 30
          MOV    @R0,#0         ; �� ���� ���� �ʱ�ȭ           1
          INC    R0             ; �� ���� ���� ����             1
          MUL    AB             ; ���� ��� �ֱ⸦ ���߱� ����  4
          SJMP   MINCHECK       ; �� ���� �� ��ƾ���� �б�    2:8

SEC:      MOV    R1,#7          ; 1                       
          LCALL  VALANCE        ; 2 , VALANCE: 2*7+3 = 17         :20
          SJMP   ADDONE         ; ���� ��ƾ���� �б�            2 :8
                         
MINCHECK: CJNE   @R0,#59H,MIN   ; �� ���� ��                  2 ;TOTAL 20
          MOV    @R0,#0         ; �� ���� ���� �ʱ�ȭ           1
          INC    R0             ; �� ���� ���� ����             1
          MUL    AB             ; ���� ��� �ֱ⸦ ���߱� ����  4
          SJMP   HOUCHECK       ; �� ���� �� ��ƾ���� �б�    2 

MIN:      MOV    R1,#2          ; 1
          LCALL  VALANCE        ; 2 , VALANCE: 2*2+3 = 7
          SJMP   ADDONE         ; ���� ��ƾ���� �б�            2

HOUCHECK: CJNE   @R0,#23H,HOUR  ; �� ���� ��                  2 ;TOTAL 10
          MOV    @R0 , #0       ; �� ���� ���� �ʱ�ȭ           1
          INC    R0             ; ���� ��� �ֱ⸦ ���߱� ����  1
          MUL    AB             ; ���� ��� �ֱ⸦ ���߱� ����  4
          JMP    RETPOINT       ; RETPOINT�� �б�               2

HOUR:     JMP    ADDONE         ; ���� ��ƾ���� �б�              : 8 CYCLE   
                                      
RETPOINT: CALL   DISPLAY        ; �ð� ���� ǥ��
          RET                   ; ���� ��ƾ���� ����

ADDONE:   MOV    A,@R0          ;                         1
           ; �ش��ϴ� ��,��,�� ������ ���� �о��          
          ADD    A,#1           ; ������ ���� 1 ���� ��Ŵ 1
          DA     A              ; ����ǥ��                1
          MOV    @R0,A          ; �ش��ϴ� ������ ����    1
          SJMP   RETPOINT       ; RETPOINT�� �б�         2  == 6CYCLE
                          
;****************************************************
;      �� ��ƾ�� �ð� ������ ���߱� ���� ��ƾ       *
;              SPEND: R1*2+3                        *
;****************************************************
VALANCE:  DJNZ   R1,$           ; 2
          NOP                   ; 1 
          RET                   ; 2

;****************************************************
;*        ���� ��ƾ: DISPLAY                        *
;*             �Է�: ACC                            * 
;*             ���: 6���� 7_SEGMENT                *
;*             ���: �ð� ���� ǥ��                 *
;****************************************************
DISPLAY:  MOV   DPTR,#LEDSEC    ; �� ǥ��  
          MOV   A,VSEC            
          MOVX  @DPTR,A           

          MOV   DPTR,#LEDMIN    ; �� ǥ�� 
          MOV   A, VMIN          
          MOVX  @DPTR,A          

          MOV   DPTR,#LEDHOU    ; �� ǥ��
          MOV   A,VHOUR        
          MOVX  @DPTR,A        
          RET                 

END