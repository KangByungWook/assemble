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

RUN:      CALL   UPDATE   ; �ٸ� ��ƾ�� ����ϱ� ���Ͽ� ���� ��Ʈ�� �и� 
          SJMP   RUN            

UPDATE:   MOV    R0,#VSEC    
          CJNE   @R0,#59H,SEC ; �� ���� ��
          MOV    @R0,#0       ; �� ���� �ʱ�ȭ
          INC    R0           ; �� ���� ���� ����
          SJMP   MINCHECK     ; �� �� ��ƾ���� �б�

SEC:      SJMP   ADDONE       ; ���� ��ƾ���� ����
                         
MINCHECK: CJNE   @R0,#59H,MIN ; �� ���� ��
          MOV    @R0 , #0     ; �� ���� �ʱ�ȭ
          INC    R0           ; �� ���� ���� ����
          JMP    HOUCHECK     ; �� �� ��ƾ���� �б�

MIN:      JMP    ADDONE       ; ���� ��ƾ���� �б�

HOUCHECK: CJNE   @R0,#23H,HOUR; �� ���� ��
          MOV    @R0,#0       ; �� ���� �ʱ�ȭ 
         ;INC    R0           ; �ʿ���� ���       
          JMP    RETPOINT     ; RETPOINT�� �б�

HOUR:     JMP    ADDONE       ; ���� ��ƾ���� �б�


RETPOINT: CALL   DISPLAY      ; �ð� ǥ�� ��ƾ ȣ��
          RET                 ; ���� ��ƾ���� ����

ADDONE:   MOV    A,@R0        
          ; �ش��ϴ� ��,��,�� ������ ���� �о��     
          ADD    A,#1         ; ������ ���� 1 ���� ��Ŵ
          DA     A            ; ���� ǥ��
          MOV    @R0 , A      ; �ش��ϴ� ������ ����
          SJMP   RETPOINT     ; RETPOINT�� �б�
                          
;****************************************************
;*        ���� ��ƾ: DISPLAY                        *
;*             �Է�: ACC                            * 
;*             ���: 6���� 7_SEGMENT                *
;*             ���: �ð� ���� ǥ��                 *
;****************************************************
DISPLAY:   MOV   DPTR,#LEDSEC    ; �� ǥ��  
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
