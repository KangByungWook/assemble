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

DISSEC:   MOV     DPTR,#LEDSEC
          MOVX    @DPTR,A
          RET          
END