;*************************************************************
;* �ð��� ��Ȯ�� ���߱� ���� �ִ��� �ҽ� ������ ����.        *
;*************************************************************

    	  ORG     0000H 
LEDHOU    EQU     0FFC3H  ; �� ǥ�� 7_SEGMENT �ּ�
LEDMIN    EQU     0FFC2H  ; �� ǥ�� 7_SEGMENT �ּ�
LEDSEC    EQU     0FFC1H  ; �� ǥ�� 7_SEGMENT �ּ�

VSEC      EQU     30H     ; ��(SEC) ��ȭ�� ���� 
VMIN      EQU     31H     ; ��(MIN) ��ȭ�� ����
VHOUR     EQU     32H     ; ��(HOU) ��ȭ�� ���� 
        
          MOV     VSEC,#0 ; ��,��,�� ���� �ʱ�ȭ
          MOV     VMIN,#0
          MOV     VHOUR,#0
          CALL    DISPLAY ; 00:00:00 ���� �ð� ���� ����

RUN:      CALL    UPDATE  ; �ٸ� ��ƾ�� ����ϱ� ���Ͽ� ���� ��Ʈ�� �и� 
          SJMP    RUN            

UPDATE:   MOV     R0,#VSEC; ������ ���߱� ���Ͽ� 
                          ; R0�� ����Ͽ� ���� �ּ� ������ �ϰ�
                          ; �ٸ� �н����� ���̸� �ּ�ȭ ��.

          CJNE    @R0,#59H,SEC ; �� ���� ��                2
          MOV     @R0,#0       ; �� ���� ���� �ʱ�ȭ         1
          INC     R0           ; �� ���� ���� ����           1   
          SJMP    MINCHECK     ; �� ���� �� ��ƾ���� �б�  2   

SEC:      SJMP    ADDONE       ; ���� ��ƾ���� �б�          2 
                         
MINCHECK: CJNE    @R0,#59H,MIN ; �� ���� ��                2
          MOV     @R0 , #0     ; �� ���� ���� ���� �ʱ�ȭ    1
          INC     R0           ; �� ���� ���� ����           1
          JMP     HOUCHECK     ; �� ���� �� ��ƾ���� �б�  2 

MIN:      JMP     ADDONE       ; ���� ��ƾ���� �б�          2

HOUCHECK: CJNE    @R0,#23H,HOUR; �� ���� ��                2
          MOV     @R0 , #0     ; �� ���� ���� ���� �ʱ�ȭ    1
          ;INC    R0           ; �ʿ� ���� ��ɾ�         
          JMP     RETPOINT     ; RETPOINT�� �б�             2

HOUR:     JMP     ADDONE       ; ���� ��ƾ���� �б�


RETPOINT: CALL    DISPLAY      ; �ð� ǥ�� ��ƾ ȣ��
          RET                  ; ���� ��ƾ ���� 

ADDONE:   MOV     A,@R0      
          ; �ش��ϴ� ��,��,�� ������ ���� �о��             1
          ADD     A,#1         ; ������ ���� 1 ���� ��Ŵ     1
          DA      A            ; ����ǥ��                    1
          MOV     @R0,A        ; �ش��ϴ� ������ ����        1
          SJMP    RETPOINT     ; RETPOINT�� �б�             2  
                          

;****************************************************
;*        ���� ��ƾ: DISPLAY                        *
;*             �Է�: ACC                            * 
;*             ���: 6���� 7_SEGMENT                *
;*             ���: �ð� ���� ǥ��                 *
;****************************************************
DISPLAY:  MOV     DPTR,#LEDSEC ; �� ǥ��
          MOV     A, VSEC           
          MOVX    @DPTR,A           

          MOV     DPTR,#LEDMIN ; �� ǥ��
          MOV     A,VMIN            
          MOVX    @DPTR,A           

          MOV     DPTR,#LEDHOU ; �� ǥ�� 
          MOV     A,VHOUR           
          MOVX    @DPTR,A           
          RET                       
          
END
