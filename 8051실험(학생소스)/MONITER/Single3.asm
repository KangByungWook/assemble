;PROGRAMMED BY KIM HYUNG SOO
;20 �������� ���� 17����Ʈ�� ����� ����
;���� ���α׷��� ��ũ3 �������͸� ���

;*****************************************************
;���� ����
ADRES0    EQU     20H     ; ���� �ּ� ���� ����
ADRES1    EQU     21H     ; ���� �ּ� ���� ����
ADRESB    EQU     22H     ; �ּ� ����

DATA      EQU     23H     ; ǥ�õ� �ּҿ� �ִ� ������ ����
DATAB     EQU     24H     ; ������ ����     

CMD       EQU     25H     ; ��ɾ� ����  
MSP       EQU     26H     ; ����� ���α׷��� SP ����

TMP0      EQU     27H     ; �ӽ� ���� ����

UPCH      EQU     28H     ; ����� PC ���� �ּ�
UPCL      EQU     29H     ; ����� PC ���� �ּ�
UDPH      EQU     2AH     ; ����� DPH �� �ּ�
UDPL      EQU     2BH     ; ����� DPL �� �ּ�
UPSW      EQU     2CH     ; ����� PSW �� �ּ�
UACC      EQU     2DH     ; ����� ACC �� �ּ�
USP       EQU     2EH     ; ����� SP �� �ּ�

;****************************************************
;��� ����
DATAOUT   EQU     0FFF0H  ; Ű�е�� �����͸� �������� �ּ�
DATAIN    EQU     0FFF1H  ; Ű�е�� ���� �����͸� �д� �ּ�

DLED      EQU     0FFC1H  ; �����Ͱ��� ǥ���ϴ� 7_SEGMENT �ּ�
ALED0     EQU     0FFC2H  ; ���� �ּҰ��� ǥ���ϴ� 7_SEGMENT �ּ�
ALED1     EQU     0FFC3H  ; ���� �ּҰ��� ǥ���ϴ� 7_SEGMENT �ּ�  


CLKHIGH   EQU     089H    ; �ð� ���α׷��� ���� ���� �ּ�
CLKLOW    EQU     000H    ; �ð� ���α׷��� ���� ���� �ּ�

STARTSP   EQU     30H     ; SP�� ���� ��ġ
USPSTART  EQU     70H     ; ����� SP�� ���� ��ġ

;*****************************************************
;�Լ� Ű ����

RWKEY      EQU    10H     ; [R/W] Ű ~ �ܺ� �޸� ������ ���� �� Ȯ��
INCKEY     EQU    11H     ; [ ,]  Ű ~ �ּ� ����
ENDKEY     EQU    12H     ; [ .]  Ű ~ �Լ�Ű ����� ����
GO         EQU    13H     ; [GO]  Ű ~ ���α׷��� ���� ���
REG        EQU    14H     ; [REG] Ű ~ ���� ��������,�޸� ���� �� Ȯ��
DECKEY     EQU    15H     ; [INC] Ű ~ �ּ� ����
CODE       EQU    16H     ; [CD]  Ű ~ ���α׷� �޸� ���� Ȯ��
ST         EQU    17H     ; [ST]  Ű ~ �̱۽��� ���� ���
RST        EQU    18H     ; [RST] Ű ~ ���� ���

;*****************************************************
;���� �ڵ� ����
ERRCHK     EQU    10H     ; ���� üũ�� ���� Ű �� 10H
                          ; �Լ� Ű �� ��� 10H ���� ũ��
ERRCODE0   EQU    0F0H    ; ���� �ڵ� "F0" ~ ���� ��ƾ������ ���� ǥ��
ERRCODE1   EQU    0F1H    ; ���� �ڵ� "F1" ~ R/W ������ ���� ǥ��
ERRCODE2   EQU    0F2H    ; ���� �ڵ� "F2" ~ CD ������ ���� ǥ��
ERRCODE3   EQU    0F3H    ; ���� �ڵ� "F3" ~ REG ������ ���� ǥ��
ERRCODE4   EQU    0F4H    ; ���� �ڵ� "F4" ~ ST ������ ���� ǥ��
ERRCODE5   EQU    0F5H    ; ���� �ڵ� "F5" ~ GO ������ ���� ǥ��
;******************************************************

           ORG    8000H
           MOV    TMOD,#00010001B  ; GATE =0 , Ÿ�̸�0 ���1 ����
           MOV    IE,#10000010B    ; ���ͷ�Ʈ �ο��̺� Ÿ�̸�0         

;***************************************************
;             ���� ��ƾ                            *
;***************************************************

START:     MOV    SP,#STARTSP   ; SP�� 30H �� �̵�
           MOV    UPSW,#0       ; ����� PSW "00" �� �ʱ�ȭ
           MOV    UPCH,#CLKHIGH ; ����� PC ���� �ּ� "89H" �� �ʱ�ȭ
           MOV    UPCL,#CLKLOW  ; ����� PC ���� �ּ� "00H" �� �ʱ�ȭ
           MOV    USP,#USPSTART ; ����� SP "70H" �� �ʱ�ȭ

           MOV    UDPH,#00H     ; ����� DPH "00" �� �ʱ�ȭ
           MOV    UDPL,#00H     ; ����� DPL "00" �� �ʱ�ȭ
           MOV    UACC,#00H     ; ����� ACC "00" �� �ʱ�ȭ

D8051:     CALL   DIS8051       ; �ʱ�ȭ��  8051 ǥ��

MAIN:      CALL   SCANN         ; Ű �Է� ����
           
           CJNE   A,#RWKEY,INSCHK1 ; [R/W] Ű �̸�
           CALL   RWINIT           ; �ܺ� �޸� READ , WRITE
           JMP    D8051            ; D8051�� �б�. ���� ��� ���

INSCHK1:   CJNE   A,#ST,INSCHK2    ; [ST] Ű �̸�
           CALL   SINGLE           ; �̱� ���� ��� ����
           JMP    D8051            ; D8051�� �б�. ���� ��� ���

INSCHK2:   CJNE   A,#REG,INSCHK3   ; [REG] Ű �̸�
           CALL   INTRAM           ; ���� �޸� READ,WRITE
           JMP    D8051            ; D8051�� �б�. ���� ��� ���

INSCHK3:   CJNE   A,#CODE,INSCHK4  ; [CD] Ű �̸�
           CALL   PROGMEM          ; ���α׷� �޸� READ
           JMP    D8051            ; D8051�� �б�. ���� ��� ���

INSCHK4:   CJNE   A,#RST,INSCHK5   ; [RST] Ű �̸�
           SJMP   START            ; ���α׷� ����. ���� �ʱ�ȭ
 
INSCHK5:   CJNE   A,#GO,ERR0       ; [GO] Ű �̸�
           CALL   BRK              ; ���α׷� ���� ��� ����
           JMP    D8051            ; D8051�� �б�. ���� ��� ���

ERR0:      MOV    A,#ERRCODE0      ; Ű �Է��� �߸��Ǹ�
                                   ; ������ �ٽ� �ʱ�ȭ�ϰ�,
                                   ; ���α׷��� �ٽ� ����
           CALL   ERR              ; ���� ��ƾ������ ���� �ڵ� ǥ��


;*******************************************************
;    Ÿ�̸� ���ͷ�Ʈ ���� ��ƾ                       *
;     1. �̱� ����(ST)              : CMD.0  = 1       *
;     2. ���α׷� ���� ���(GO)     : CMD.0  = 0       *
;     3. ���α׷� ���� ���(GO)     : RST Ű üũ      *
;*******************************************************
SERVICE:   CLR    TR0               ; Ÿ�̸�0 ���� ����
           ; ���� ���� ����� PC���� ����
           POP    UPCH              
           POP    UPCL        
           
           JNB    CMD.0   BREAKPRO   
           ; �̱� ������ ���      CMD.0 =  " 1 "            
           ; ���α׷� ������ ���  CMD.0 =  " 0 "

           ;�̱� ���� ������ ���� �������Ͱ� ����
RETPRO:    MOV    UACC,ACC  
           MOV    UDPH,DPH
           MOV    UDPL,DPL
           MOV    UPSW,PSW
           MOV    USP,SP
           MOV    SP,MSP ; ����� ���α׷� ������� SP ������
           SJMP   BACK   ; �̱� ���� ����  

BREAKPRO:  PUSH   ACC
           PUSH   DPH
           PUSH   DPL

CHKSTOP:   MOV    A,#11111110B        ;������ ���� üũ
           MOV    DPTR,#DATAOUT
           MOVX   @DPTR,A
           
           MOV    DPTR,#DATAIN 
           MOVX   A,@DPTR
           
           CJNE   A,#11101111B,CHKBRK
           ;[RST]Ű �̸� ���α׷� �ʱ�ȭ

           MOV    DPTR,#START    
           PUSH   DPL                 
           PUSH   DPH                          
           SJMP   BACK       ; START�� �б�

CHKBRK:    CALL   DBLEQU     ; CHECK CURRENT ADDRESS           
           JZ     RETPRO     ; IF ACC EQUAL ZERO THEN RETURN TO MAIN

           POP    DPL        ; �������� ���� ����
           POP    DPH
           POP    ACC

           PUSH   UPCL                 
           PUSH   UPCH                   

           MOV    TH0,#0FFH  ; Ÿ�̸�0 �ٽ� ����
           MOV    TL0,#0FFH   
           SETB   TR0        ; Ÿ�̸� ���� ���� 

BACK:      RETI              ; ���ͷ��� ���� ��ƾ ����

;****************************************************************
;*         ���� ��ƾ: RANDW    (READ AND WRITE)                 *
;*              �Է�: Ű �е�                                   *
;*              ���: ADRES0,ADRES1,ADRESB,ALED0,ALED1          *
;*    ���� ���� ��ƾ: SCANN,DRANDW,ADIS,AROT                    *
;*              ���: �Է� �ּ� ǥ��                            *
;****************************************************************
RWINIT:    CALL   CLEAR             ; ǥ�� â�� ���� ������ �ʱ�ȭ
           MOV    ADRES1,#CLKHIGH   ; ����Ʈ ���� ���� �ּ�
           MOV    ADRES0,#CLKLOW    ; ����Ʈ ���� ���� �ּ�
           CALL   ADIS              ; ���� �ּ� ǥ��

RANDW:     CALL   SCANN             ; Ű �Է� üũ
           
           CJNE   A,#INCKEY,WRTCHK1 ; [,] Ű �Է��̸�
           CALL   DRANDW            ; �ּ� ����, ������ ǥ��


WRTCHK1:   CJNE   A,#DECKEY,WRTCHK2 ; [INC] Ű �Է��̸�
           CALL   DRANDW            ; �ּ� ����, ������ ǥ��
                                    
WRTCHK2:   CJNE   A,#ENDKEY,WRTCHK3 ; [.]Ű �Է��̸� RANDW ��ƾ�� ����
           RET                      ; ���� ��ƾ���� ����

WRTCHK3:   CJNE   A,#ERRCHK,WRTCHK4 ; [NUMBER]Ű �̸�, ĳ�� ��Ʈ�� "1"
                                    ; [���] Ű �̸�, ĳ�� ��Ʈ�� "0"

WRTCHK4:   JNC    ERR1
           MOV    ADRESB,A          ; ����ؼ� �ּ� ǥ��
           CALL   AROT              ; �ּ� ǥ�� �̵� ��ƾ ȣ��
           CALL   ADIS              ; �ּ� ǥ�� ��ƾ ȣ��
           JMP    RANDW             ; ���� �ּҰ� �Էµɶ� ���� ���   

ERR1:      MOV    A,#ERRCODE1       ; [R/W] ���� �ڵ� "F1" ������
           CALL   ERR               ; ������ ǥ���� �� RANDW ��ƾ�� ����


;***************************************************************
;*         ���� ��ƾ: DRANDW  (DATA READ AND WRITE RUTINE)     *
;*              �Է�: DATA,DATAB                               *
;*              ���: DLED,DATA,ALED,ADRES0,ADRES1,"** ACC **" *
;*    ���� ���� ��ƾ: SCANN,DROT,DATADIS,INCREAS               *
;*              ���: �ּ� ������ ������ �ּ��� ������ ǥ��    *
;***************************************************************
DRANDW:    MOV    DPL,ADRES0      ; DPL�� ADRES0�� �ִ� ���� ����
           MOV    DPH,ADRES1      ; DPH�� ADRES1�� �ִ� ���� ����
           CLR    A
           MOVC   A,@a+DPTR       
           ; ǥ�ø� ���� �ּҷκ��� �����͸� ������ �̵�             
           MOV    DATA,A           
           CALL   DATADIS         ; ������ ǥ�� 
           CALL   SCANN           ; ���� Ű �Է��� ���� �� ���� ���

TEST0:     CJNE   A,#INCKEY,TEST1 ; [,]  Ű �̸�
           CALL   DWRITE          ; ǥ�õ� �ּ��� ������ ����
           CALL   INCREAS         ; �ּ� ����
           JMP    DRANDW          ; DRADW ��ƾ���� �б�
                               
TEST1:     CJNE   A,#DECKEY,TEST2 ; [INC] Ű �̸�
           CALL   DWRITE          ; ǥ�õ� �ּ��� ������ ����
           CALL   DECREAS         ; �ּ� ���� 
           JMP    DRANDW          ; DRADW ��ƾ���� �б�

TEST2:     CJNE   A,#ENDKEY,TEST3 ; [.] Ű �̸�
           CALL   DWRITE          ; ǥ�õ� �ּ��� ������ ����
           MOV    A,#ENDKEY        
           RET          
        
TEST3:     CJNE   A,#ERRCHK,TEST4 ; [NUMBER]Ű �̸� ĳ�� ��Ʈ "1"
                                  ; [���]Ű �̸� ĳ�� ��Ʈ "0"  

TEST4:     JNC    EERR1           ; [���]Ű �̸� ���� ǥ��
           MOV    DATAB,A         ; ���ο� ������ �Է�
           CALL   DROT            ; ������ ǥ�� �̵�
           CALL   DATADIS         ; ������ ǥ��

           CALL   SCANN           ; ���� Ű �Է±��� ���
           JMP    TEST0           ; Ű �Է��� �߻��ϸ� �ٽ� Ű ��� ����

EERR1:     MOV    A,#ERRCODE1     ; [R/W] ���� �ڵ� "F1" ǥ��
           CALL   ERR             ; ���� ǥ���� ����

;**************************************************************
;*         ���� ��ƾ: DWRITE(DATA WRITE)                      *
;*              �Է�: ADRES0,ADRE1,DATA                       *
;*              ���: DISPLAYED ADDRESS                       *
;*              ���: ǥ�õ� �ܺ� ������ �޸� �ּҿ�        *
;*                    ������ ����                             *
;**************************************************************
DWRITE:    MOV    DPL,ADRES0      ; DPL�� ǥ�� ���� �ּ� ADRES0 ����
           MOV    DPH,ADRES1      ; DPH�� ǥ�� ���� �ּ� ADRES1 ����
           MOV    A,DATA          ; ������ â�� �ִ� �����͸� ������
           MOVX   @DPTR,A         ; ����⿡ �ִ� �����͸� ����
           RET

;**************************************************************
;*         ���� ��ƾ: INCREAS                                 *
;*              �Է�: ADRES0,ADRES1                           *
;*              ���: ADRES0,ADRES1                           *
;*    ���� ���� ��ƾ: ADIS                                    *
;*              ���: �ּҸ� ���� ��Ű�� ������ ǥ��          * 
;**************************************************************   
INCREAS:   MOV    A,ADRES0        ; ���� �ּҸ� ������
           INC    A               ; ���� �ּ� ����
           MOV    ADRES0,A        ; ������ �ּҸ� ���� �ּҷ�

           CJNE   A,#00H,INCDIS   ; ���� �ּҸ� ���� ���Ѿ� ���� üũ
                                  ; ���� �ּҰ� �� ���� ������, 
                                  ; ������ �ּ� ǥ�� 
           MOV    A,ADRES1         
           INC    A               ; ���� �ּ� ����
           MOV    ADRES1,A        ; ������ �ּҸ� ���� �ּҷ�

INCDIS:    CALL   ADIS            ; �ּ� ǥ�� ��ƾ ȣ��
           RET                    ; ���� ��ƾ���� ����
          
;**************************************************************
;*         ���� ��ƾ: DECREAS                                 *
;*              �Է�: ADRES0,ADRES1                           *
;*              ���: ADRES0,ADRES1                           *
;*    ���� ���� ��ƾ: ADIS                                    *
;*              ���: �ּҸ� ���� ��Ű�� ������ ǥ��          *
;**************************************************************   
DECREAS:   MOV    A,ADRES0        ; ���� �ּҸ� ������ 
           DEC    A               ; ���� �ּ� ����
           MOV    ADRES0,A        ; ���ҵ� �ּҸ� ���� �ּҷ�

           CJNE   A,#0FFH,DECEND  ; ���� �ּҸ� ���� ���Ѿ� ���� üũ
           DEC    ADRES1          ; ���� �ּ� ����
                                     
DECEND:    CALL   ADIS            ; �ּ� ǥ�� ��ƾ ȣ��
           RET                    ; ���� ��ƾ���� ����

;**************************************************************
;*         ���� ��ƾ: AROT  (ADDRESS ROTATE)                  *
;*              �Է�: ADRESB                                  *
;*              ���: ADRES0 , ADRES1                         *
;*              ���: �ּ� ���ۿ� �ִ� �ּ� ������Ʈ          *    
;**************************************************************
HIGH4      EQU    0F0H  ; ���� �ּҸ� ��� ���� ����ũ ����
LOW4       EQU    00FH  ; ���� �ּҸ� ��� ���� ����ũ ����

AROT:      MOV    A,ADRES1      ; ���� �ּҸ� ������
           ANL    A,#LOW4       ; LOW4�� ����ũ
           SWAP   A             
           MOV    ADRES1,A      

           MOV    A,ADRES0      ; ���� �ּҸ� ������
           ANL    A,#HIGH4      ; HIGH4�� ����ũ
           SWAP   A             
           ADD    A,ADRES1      
           MOV    ADRES1,A      

           MOV    A,ADRES0      ; ���� �ּҸ� ������
           ANL    A,#LOW4       ; LOW4�� ����ũ
           SWAP   A             
           MOV    ADRES0,A       

           MOV    A,ADRESB      ; �ּ� ���۸� ������
           ANL    A,#LOW4       ; LOW4�� ����ũ
           ADD    A,ADRES0      
           MOV    ADRES0,A      
           RET                  ; ���� ��ƾ���� ����

;*************************************************************
;*         ���� ��ƾ: DROT  (DATA ROTATE)                    *
;*              �Է�: DATAB                                  *
;*              ���: DATA                                   *
;*              ���: ������ ���ۿ� �ִ� ������ ������Ʈ     *
;*************************************************************

DROT:      MOV    A,DATA        ; ǥ�õ� �ּҿ� �ִ� �����͸� ������
           ANL    A,#LOW4       ; LOW4�� ����ũ
           SWAP   A             
           MOV    DATA,A        
           MOV    A,DATAB       ; ������ ���ۿ� �ִ� �����͸� ������
           ANL    A,#LOW4       ; LOW4�� ����ũ
           ADD    A,DATA        
           MOV    DATA,A        
           RET                  ; ���� ��ƾ���� ����

;*************************************************************
;*         ���� ��ƾ: ADIS  (ADDRESS DISPLAY)                *
;*              �Է�: ADRES0,ADRES1                          *
;*              ���: ALED DISPLAY                           *
;*************************************************************
ADIS:      MOV    A,ADRES0      ; ���� �ּҰ��� ������
           MOV    DPTR,#ALED0   ; DPTR�� ���� �ּ� ǥ�� â ����
           MOVX   @DPTR,A       ; ���� �ּ� ǥ��
                                   
           MOV    A,ADRES1      ; ���� �ּҰ��� ������ 
           MOV    DPTR,#ALED1   ; DPTR�� ���� �ּ� ǥ�� â ����
           MOVX   @DPTR,A       ; ���� �ּ� ǥ��
           RET

;*************************************************************
;*         ���� ��ƾ: DATADIS(DATA DISPLAY)                  *
;*              �Է�: DATA                                   *
;*              ���: DLED                                   *
;*              ���: ǥ�õ� �ּ��� ������ ���� ǥ��         *
;*************************************************************
DATADIS:    MOV   A,DATA        ; ǥ�õ� �ּ��� �����͸� ������ 
            MOV   DPTR,#DLED    ; DPTR�� ������ ǥ�� â ����
            MOVX  @DPTR,A       ; ������ ǥ��
            RET

;*************************************************************
;*         ���� ��ƾ: INTRAM(INTERNAL RAM)                   *
;*              �Է�: Ű �е�                                *
;*              ���: ALED0,DLED,ADRES0,ADRESB,DATA,DATAB    *
;*    ���� ���� ��ƾ: CLEAER,SCANN,RAMROT,ADIS,RAMWRT,ERR    *
;*              ���: ���� �޸� �б�,����                  *
;*                    - 8��Ʈ �ּ� ADRES0 �� ���            * 
;*************************************************************
INTRAM:     CALL  CLEAR         ; ǥ��â�� ���� ������ �ʱ�ȭ
            MOV   ADRES0,#00H   ; ����Ʈ ���� �޸� �ּ�
            CALL  ADIS          ; ���� �ּ� ǥ��

RAMWAIT:    CALL  SCANN         ; Ű �Է� ���� üũ

RAMCHK1:    CJNE  A,#ERRCHK,RAMCHK2 ; [����] Ű ĳ�� ��Ʈ "1"
                                    ; [���] Ű ĳ�� ��Ʈ "0"
RAMCHK2:    JNC   RAMCHK3           ; [���] Ű �̸�,[���] üũ
            MOV   ADRESB,A          ; [����] Ű �̸�, ���ο� �ּ� �Է�
            CALL  RAMROT            ; �ּ� ǥ�� �̵�
            CALL  ADIS              ; �ּ� ǥ��
            JMP   RAMWAIT           ; RAMWAIT�� �б�

RAMCHK3:    CJNE  A,#INCKEY,RAMCHK4 ; [,] Ű �̸�
            CALL  RAMWRT            ; RAMWRT ȣ��
                                     
RAMCHK4:    CJNE  A,#DECKEY,RAMCHK5 ; [INC] Ű �̸� 
            CALL  RAMWRT            ; RAMWRT ȣ��
                                    
RAMCHK5:    CJNE  A,#ENDKEY,ERR3    ; [.] Ű �̸�
            RET                     ; �������� ����

ERR3:       MOV   A,#ERRCODE3       ; [REG] �����ڵ� "F3"
            CALL  ERR               ; ���� �ڵ� ǥ��

;************************************************************
;*          ���� ��ƾ: RAMWRT(INTERNAL RAM WRITE)           *
;*               �Է�: Ű �е�                              *
;*               ���: ALED0,DLED,ADRES0,ADRESB,DATA,DATAB  *
;*     ���� ���� ��ƾ: RAMROT,DROT,ADIS,DATADIS             * 
;*                     INCREAS,DECREAS                      *
;*               ���: ���� �޸� ���� �б�,����           *
;************************************************************
RAMWRT:     PUSH  PSW               
            SETB  PSW.4              ; ��ũ3 �������� ���   
            SETB  PSW.3             

RAMSTAT:    MOV   R0,ADRES0          ; R0�� ADRES0 �� ����
            MOV   DATA,@R0           
            CALL  DATADIS            ; ���� �޸� ������ ǥ��

            CALL  SCANN              ; Ű �Է°� üũ

CHKRAM1:    CJNE  A,#INCKEY,CHKRAM2  ; [,]Ű �̸�
            CALL  RAMDWRT            ; ���� �޸� ����
            CALL  INCREAS            ; �ּ� ����
            JMP   RAMSTAT            ; RAMSTAT�� �б�

CHKRAM2:    CJNE  A,#DECKEY,CHKRAM3  ; [INC]Ű �̸� 
            CALL  RAMDWRT            ; �ּ� ����
            CALL  DECREAS            ; �ּ� ����
            JMP   RAMSTAT            ; RAMSTART�� �б�

CHKRAM3:    CJNE  A,#ENDKEY,CHKRAM4  ; [.]Ű �̸�
            CALL  RAMDWRT            ; ���� �޸� ����
            POP   PSW                 
            RET                      ; ���� ��ƾ���� ����

CHKRAM4:    CJNE  A,#ERRCHK,CHKRAM5  ; [���]Ű ĳ�� ��Ʈ "0"
                                     ; [����]Ű ĳ�� ��Ʈ "1" 
CHKRAM5:    JNC   EERR3              ; [���]Ű ~ ���� ǥ��
            MOV   DATAB,A            ; [����]Ű ~ ���ο� ������ �Է�
            CALL  DROT               ; ������ ǥ�� �̵�
            CALL  DATADIS            ; ������ ǥ��
            CALL  SCANN              ; Ű �Է°� üũ
            JMP   CHKRAM1            ; Ű �Է� �߻���, CHKRAM1���� �б�

EERR3:      MOV   A,#ERRCODE3        ; [REG] ���� �ڵ� "F3"
            CALL  ERR                ; ���� ǥ��

;***********************************************************
;*          ���� ��ƾ: RAMROT  (RAM ADDRESS ROTATE)        *
;*               �Է�: ADRESB                              *
;*               ���: ADRES0                              *
;*               ���: �ּ� ǥ�� �̵�                      *
;***********************************************************
RAMROT:     MOV   A,ADRES0           ; �ּҰ��� ������
            ANL   A,#LOW4            ; LOW4 ����ũ
            SWAP  A                  
            MOV   ADRES0,A           
            MOV   A,ADRESB           ; �ּ� ���� ���� ������
            ANL   A,#LOW4            ; LOW4 ����ũ
            ADD   A,ADRES0           
            MOV   ADRES0,A           
            RET                      ; ���� ��ƾ���� ����

;***********************************************************
;*          ���� ��ƾ: RAMDWRT(WRITE RAM DATA)             *
;*               �Է�: ADRES0,DATA                         *
;*               ���: DISPLAYED ADDRESS                   *
;*               ���: ���� �޸� ����                    *
;*                     ��ũ3 ���������� R0 �� ���         *
;***********************************************************
RAMDWRT:    MOV   R0,ADRES0          ; R0�� ADRES0 �� ����
            MOV   @R0,DATA           ; R0�� ���� ���� ���� ����
            RET                      ; ���� ��ƾ ����

;***********************************************************
;*          ���� ��ƾ: PROGMEM (PROGRAMM MEMORY)           *
;*               �Է�: Ű �е�                             *
;*               ���: 6���� 7_SEGMENT ǥ��                *     
;*     ���� ���� ��ƾ: ROMREAD                             *
;*               ���: ���α׷� �޸��� ���� �б�         *
;***********************************************************
PROGMEM:    CALL  CLEAR              ; ǥ��â�� ���� ������ �ʱ�ȭ
            MOV   ADRES0,#00H        ; ����Ʈ ���α׷� �޸� ���� �ּ�
            MOV   ADRES1,#00H        ; ����Ʈ ���α׷� �޸� ���� �ּ�   
            CALL  ADIS               ; �ʱ� �ּ� ǥ��
            CALL  ROMREAD            ; �ʱ� �ּ��� ������ �б�


ROMSTART:   CALL  SCANN              ; Ű �Է� üũ

ROMCHK1:    CJNE  A,#ERRCHK,ROMCHK2  ; [����] Ű �̸� ĳ�� ��Ʈ "1"
                                     ; [���] Ű �̸� ĳ�� ��Ʈ "0"
ROMCHK2:    JNC   ROMCHK3            ; [���] Ű �̸� , [���] üũ
            MOV   ADRESB,A           ; �ּ� ���۷� ���ο� �ּ� �Է�
            CALL  AROT               ; �ּ� ǥ�� �̵�
            CALL  ADIS               ; �ּ� ǥ��
            CALL  ROMREAD            ; ���ο� �ּ��� ���α׷� �޸� �б�
            JMP   ROMSTART           ; ROMSTART�� �б�

ROMCHK3:    CJNE  A,#INCKEY,ROMCHK4  ; [,]Ű �̸�
            CALL  INCREAS            ; ���α׷� �޸� �ּ� ����
            CALL  ROMREAD            ; ������ �ּ��� ������ �б�,ǥ��
            JMP   ROMSTART           ; ROMSTART�� �б�

ROMCHK4:    CJNE  A,#DECKEY,ROMCHK5  ; [INC]Ű �̸�
            CALL  DECREAS            ; ���α׷� �޸� �ּ� ����
            CALL  ROMREAD            ; ���ҵ� �ּ��� ������ �б�,ǥ��
            JMP   ROMSTART           ; ROMSTART�� �б�

ROMCHK5:    CJNE  A,#ENDKEY,ERR2     ; [.]Ű �̸�
            RET                      ; ���α׷� �޸� �б� ����

ERR2:       MOV   A,#ERRCODE2        ; [CD] ���� �ڵ� "F2" ǥ��
            CALL  ERR                ; ���� ǥ�� �� ����

;**********************************************************
;*          ���� ��ƾ: ROMREAD                            *
;*               �Է�: ADRES0,ADRES1                      *
;*               ���: ������ ǥ�� â                     *
;*               ���: ���α׷� �޸𸮷κ���  ������ �б� *
;**********************************************************
ROMREAD:    MOV   DPH,ADRES1         ; ���α׷� �޸� ���� �ּ� ����
            MOV   DPL,ADRES0         ; ���α׷� �޸� ���� �ּ� ����
            MOV   A,#00H             ; ����⸦ �ʱ�ȭ
            MOVC  A,@A+DPTR          ; ���α׷� �޸� �б�
            MOV   DATA,A             ; DATA�� ���α׷� �޸� �� �̵�
            CALL  DATADIS            ; ���α׷� �޸� ���� ǥ��
            RET                      ; ���� ��ƾ���� ����

;**********************************************************
;*          ���� ��ƾ: SINGLE (SINGLE STEP)               *
;*               �Է�: Ű �е�                            *
;*               ���: ����� ���� �޸� (20H -2FH)      *
;*                     �ּ�,������ ǥ��â                 *
;*     ���� ���� ��ƾ: SCANN,AROT,DIS8051,DISUPC,EXECUTE  *
;*               ���: �̱� ���� ���� ����                *
;*                     ����� PCǥ��                      *
;**********************************************************
SINGLE:     CALL  CLEAR              ; ǥ��â ���� , ���� �ʱ�ȭ
            CALL  DISUPC             ; ����Ʈ ���� �ּ� ǥ��

WAITKEY:    CALL  SCANN              ; Ű �Է°� ����
                                                    
CHECK1:     CJNE  A,#ERRCHK,CHECK2   ; [���] Ű �̸� ĳ�� ��Ʈ "0"
                                     ; [����] Ű �̸� ĳ�� ��Ʈ "1"

CHECK2:     JNC   CHECK3             ; [���] Ű �̸�, � ��� Ű ���� ����
            MOV   ADRESB,A           ; �̱� ������ ���� �ּ� �Է�
            CALL  AROT               ; �ּ� ǥ�� �̵�
            MOV   UPCH,ADRES1        ; ���� ���� �ּҸ� UPCH��
            MOV   UPCL,ADRES0        ; ���� ���� �ּҸ� UPCL��
            CALL  ADIS               ; �ּ� ǥ��
            JMP   WAITKEY            ; WAITKEY�� �б�

CHECK3:     CJNE  A,#ST,CHECK4       ; [ST]Ű �̸�
            CALL  DISUPC             ; ����� [PC] ǥ��
            JMP   WAITKEY            ; WAITKEY�� �б�

CHECK4:     CJNE  A,#INCKEY,CHECK5   ; [,]Ű �̸�
            SETB  CMD.0              ; �̱� ���� ���� ��ƾ���� ��Ÿ��
            CALL  EXCUTE             ; �� ��� ���� ��ƾ ȣ��
            JMP   WAITKEY            ; WAITKEY�� �б�

CHECK5:     CJNE  A,#ENDKEY,ERR4     ; [.]Ű �̸�
            RET                      ; �������� ����

ERR4:       MOV   A,#ERRCODE4        ; [ST]���� ǥ�� "F4"
            CALL  ERR                ; ���� ǥ��

;*********************************************************
;*          ���� ��ƾ: DISUPC                            *
;*               �Է�: UPCH,UPCL                         *
;*               ���: ADRES0,ADRE1,ALED0,ALED1          *
;*     ���� ���� ��ƾ: ADIS                              *
;*               ���: [ST] Ű �Է¿� ����               * 
;*                     ����� PC ǥ��                    *
;*********************************************************
DISUPC:     MOV   ADRES1,UPCH       ; ����� ���� PC�� �ּ�
            MOV   ADRES0,UPCL       ; ����� ���� PC�� �ּ�
            CALL  ADIS              ; ����� PC�� ǥ��
            RET                     ; ���� ��ƾ�� ����

;*********************************************************
;*          ���� ��ƾ: EXCUTE                            *
;*               �Է�: UPCH,UPCL                         *
;*               ���: UPCH,UPCL                         *
;*                 ~ �� ����� ����� �� ������ PC��     *     
;*     ���� ���� ��ƾ: READY,REVERSE,UPCINC,SPECIAL      *
;*               ���: UPC�� ����Ű�� �� �����          *
;*                     ������ �� UPC ����                *
;*********************************************************
EXCUTE:     MOV   A,UACC            ; �̱� ���� ����� �ʿ���
            MOV   PSW,UPSW          ; �������� ������ �ٲ�
            MOV   DPH,UDPH          
            MOV   DPL,UDPL    

            MOV   MSP,SP            ; ������ SP ���� MSP�� ����

            MOV   SP,USP            ; SP ���� �̵�

            PUSH  UPCL   
            PUSH  UPCH   

	    MOV	  TH0,#0FFH         ; Ÿ�̸� ����
	    MOV	  TL0,#0FEH         
            SETB  TR0		    ; Ÿ�̸� ���� ����
            RET                     ; JMP ��� ����� ���� ��� �߻�

;*********************************************************
;*          ���� ��ƾ: DBLEQU                            *
;*               �Է�: UPCH ,UPCL, ADRES0,ADRES1         *
;*               ���: ACC 0:EQUAL 1:NOT EQUAL           *
;*               ���: �ߴ��� �ּҿ�                     *
;*                     ���� ���� ��� �ּ� ��          *
;*********************************************************
DBLEQU:     MOV   A,UPCL            ; ���� ���� ��� ���� �ּ�
            XRL   A,ADRES0          ; (XRL) �ߴ��� ���� �ּ�
            JNZ   RETURN            ; ��ġ ���� ������ ����

            MOV   A,UPCH            ; ���� ���� ��� ���� �ּ�
            XRL   A,ADRES1          ; (XRL) �ߴ��� ���� �ּ�
RETURN:     RET                     ; ������ ����� ����

;*********************************************************
;*          ���� ��ƾ: BRK (BREAK POINT)                 *
;*               �Է�: Ű �е�                           *
;*               ���: ����� ���� �޸� (20H -2FH)     *
;*                     �ּ�,������ ǥ��â                *
;*     ���� ���� ��ƾ: SCANN,AROT,DIS8051,DISUPC,EXECUTE *
;*               ���: �ߴ������� ���α׷� ����          *
;*********************************************************
BRK:        CALL  CLEAR    ; ǥ��â ����, ������ �ʱ�ȭ
            CALL  DISUPC   ; ����Ʈ ���α׷� ���� ���� �ּ� ǥ��

WAITBRK:    CALL  SCANN    ; Ű �Է°� ����
                          
BRKCHK1:    CJNE  A,#ERRCHK,BRKCHK2 ; [���]Ű �̸� ĳ�� ��Ʈ "0" 
                                    ; [����]Ű �̸� ĳ�� ��Ʈ "1" 

BRKCHK2:    JNC   BRKCHK3           ; [���]Ű �̸� � ������� ����
            MOV   ADRESB,A          ; [����]Ű �̸� ���ο� �ּ� �Է�
            CALL  AROT              ; �ּ� ǥ�� �̵�
            MOV   UPCH,ADRES1       ; ���� �ּ� UPCH�� ����
            MOV   UPCL,ADRES0       ; ���� �ּ� UPCL�� ����
            CALL  ADIS              ; �ּ� ǥ��
            JMP   WAITBRK           ; WAITBRK�� �б�

BRKCHK3:    CJNE  A,#ENDKEY,BRKCHK4 ; [.]Ű �̸�

EXE:        CLR   CMD.0             ; ���α׷� ���� ��� ��ƾ���� ��Ÿ��
            CALL  EXCUTE            ; EXECUTE ��ƾ ȣ��
            SJMP  WAIT_KEY          ; WAIT_KEY ��ƾ���� �б�

BRKCHK4:    CJNE  A,#INCKEY,CHKBRK3 ; [,]Ű �̸�

WAITBRK2:   CALL  SCANN             ; Ű �Է°� ����

CHKBRK1:    CJNE  A,#ERRCHK,CHKBRK2 
CHKBRK2:    JNC   CHKBRK3           ; Ű �Է��� [����] �̸�
            MOV   ADRESB,A          ; �ּ� �Է�
            CALL  AROT              ; �ּ� ǥ�� �̵�
            CALL  ADIS              ; �ּ� ǥ��
            JMP   WAITBRK2          ; WAITBRK2�� �б�

CHKBRK3:    CJNE  A,#ENDKEY,ERR5    ; [.]Ű �̸�
            JMP   EXE               ; EXE�� �б�. ���α׷� ����

WAIT_KEY:   CALL  SCANN             ; Ű �Է°� ����
            RET                     ; ���� ��ƾ���� ����

ERR5:       MOV   A,#ERRCODE5       ; ���� �ڵ� "F5" 
            CALL  ERR               ; ���� �ڵ� ǥ��

;************************************************************
;*          ���� ��ƾ: DIS8051(DISPLAY 8051)                *
;*               �Է�: ����                                 *
;*               ���: ADRES1,ADRES0,DATA,ALED1,ALED0,DLED  *
;*     ���� ���� ��ƾ: ADIS,DATADIS                         *
;*               ���: 80 51 00 ǥ��                        *
;************************************************************
DIS8051:    MOV   ADRES1,#80H 
            MOV   ADRES0,#51H 
            MOV   DATA,#00H   
            CALL  ADIS       
            CALL  DATADIS    
            RET             

;************************************************************
;*          ���� ��ƾ: CLEAR(OFF ALL LED)                   *
;*               �Է�: ����                                 *
;*               ���: ADRES0,ADRES1,ADRESB,                *
;*                     DATA,DATAB,ALED0,ALED1,DLED          *
;*     ���� ���� ��ƾ: ADIS,DATADIS                         *
;*               ���: 7_SEGMENT�� ����                     *
;*                     �ּҿ� ������ ���۸� �ʱ�ȭ          * 
;************************************************************
CLEAR:      MOV   ADRES0,#00FFH   
            MOV   ADRES1,#00FFH   
            MOV   ADRESB,#00H     
            MOV   DATA,#00FFH     
            MOV   DATAB,#00H      
            CALL  ADIS           
            CALL  DATADIS        
            RET                 

;************************************************************
;*          ���� ��ƾ: ERR(ERROR)                           *
;*               �Է�: ACC                                  *
;*               ���: SP (INITIALIZE Stack Pointer)        *
;*               ���: ���� �ڵ� ǥ�� , SP�� �ʱ�ȭ         *
;************************************************************
ERR:        PUSH  PSW          
            SETB  PSW.3          ; ��ũ3 �������� ���
            SETB  PSW.4
 
            MOV   TMP0,A         ; ����� ���� ����
          

RELOAD:     MOV   R1,#5          ; 5�� �����Ÿ�

ERRDIS:     CALL  DIS8051        ; 8051 ǥ��
            MOV   DATA,TMP0      ; ���� �ڵ� �б�
            CALL  DATADIS        ; ���� �ڵ� ǥ��
            CALL  LDELAY         ; ���� �ð� ���� ǥ��
            CALL  CLEAR          ; ǥ��â ����
            CALL  LDELAY         ; ���� �ð� ����
            DJNZ  R1 , ERRDIS    ; �ݺ� ����

            CLR   A
            CALL  SUBKEY       
          
            CJNE  A,#0FFH,RELOAD ; Ű �Է��� ������ �ݺ�
            POP   PSW            
            JMP   START          ; ���� �ڵ� ǥ���� �ٽ� ����

;***********************************************************
;*          ���� ��ƾ: �ð� ����                           *
;***********************************************************
LDELAY:   
            MOV   R0,#010H

LONGDEL:    CALL  DELAY
            DJNZ  R0,LONGDEL
            RET

;******************************************************************
;*          ���� ��ƾ: SCANN (KEY SCANN RUTINE -- MOST IMPORTANT) *
;*               �Է�: ����                                       *  
;*               ���: ����� ---  KEY_INDEX                      * 
;*     ���� ���� ��ƾ: SUBKEY,INDEX,DELAY                         *
;*     ��� ���� ����: R0(DATA),R1(COL),R2(ROW),R6,R7(CLOCK) USED *
;******************************************************************
SCANN:      PUSH  PSW            ; PSW���� ���ÿ� ����
            SETB  PSW.4          ; ��ũ3 �������� ���
            SETB  PSW.3 

            CALL  DELAY          ; Ű�� ������ �ִ� ������ �ð� ����

HOLD:       MOV   A,#00H         ; ������ �ƿ����� ������ ����(00H)
            CALL  SUBKEY         ; ������ ������ ������ �б�
            XRL   A,#0FFH        ; ������ �� �� (XRL) 11111111B

HOLD1:      JNZ   HOLD           

            CALL  DELAY          ; Ű�� ���� �ִ� ������ �ð� ����

INITIAL:    MOV   R1,#00H        ; R1 (COL)�� �ʱ�ȭ
            MOV   A,#11101111B   ; ���� �Է� ������

COLSCAN:    MOV   R0,A           ; R0 : Ű ��ĵ �Է� ������
            INC   R1             ; R1 : ���� �� ����
            CALL  SUBKEY         ; Ű �� ��ĵ
            XRL   A,#0FFH        ; ������ �ƿ� (XRL) 11111111B
            JNZ   RSCAN          ; Ű�� ���� ������, 0�� �ƴ� ���� ������.
            MOV   A,R0
            SETB  C
            RRC   A              ; ���� ���� ��ĵ�� ����
            JNC   INITIAL        ; ��� ���� ��ĵ�ϸ�, �ٽ� ����
            JMP   COLSCAN        ; ���� �� ��ĵ�� ���� �б�

RSCAN:      MOV   R2,#00H        ; R2 : ���� �� ����
ROWSCAN:    RRC   A              ; ��� ���� ���� ������ ����.
                                 ; XRL ���� ��� ������ Ű�� ���� "1"
                                 ; RRC ������ ���� ĳ�� ��Ʈ üũ 
            JC    MATRIX         ; ĳ���� �߻�������, MATRIX �� �б� 
            INC   R2             ; ĳ���� �߻����� �ʾ�����,
                                 ; ���� ������ �̵� 
            JMP   ROWSCAN        ; ROWSCAN���� �б� 
         
MATRIX:     MOV   A,R2           ; R2 ���� �� ����
            MOV   B,#05H         ; 1���� 5���� ���� �̷����
            MUL   AB             ; 2���� ���� 1���� ������ �ٲ�
            ADD   A,R1           ; R1 ���� �� ����
                                 ; ������� �� = R2*5 +R1
            CALL  INDEX          ; Ű �ڵ� ���� �о��

BRKOUT:     POP   PSW            ; PSW���� ����
            RET                  ; ���� ��ƾ���� ����

;*************************************************************
;*          ���� ��ƾ: �ð� ���� ��ƾ                        *
;*               �Է�: ����                                  *
;*               ���: ����                                  *
;*               ���: ����(Ű �ٿ ����)                  *
;*************************************************************
DELAY:      MOV   R7,#020H      

DELAY1:     MOV   R6,#0FF0H     
DELAY2:     DJNZ  R6,DELAY2    
            DJNZ  R7,DELAY1    
            RET

;*************************************************************
;*          ���� ��ƾ: SUBKEY                                *
;*               �Է�: ACC                                   *
;*               ���: ACC                                   *
;*               ���: ������ �ƿ����� �����͸� ���� ��      *
;*                     ������ ������ �����͸� �о� ����      *
;*************************************************************
SUBKEY:     MOV   DPTR,#DATAOUT
            MOVX  @DPTR,A
            MOV   DPTR,#DATAIN
            MOVX  A,@DPTR
            RET

;**************************************************************
;*          ���� ��ƾ: INDEX                                  *
;*               �Է�: ACC                                    *
;*               ���: ACC                                    *
;*               ���: ���ǵ� Ű �ڵ� ���� �о� ����          *
;**************************************************************
INDEX:      MOVC  A,@A+PC    ; 1~24 ������ ���� ���� 
            RET
KEYBASE:    DB    ST         ;SW1,ST             1
            DB    DECKEY     ;SW6,INC            2
            DB    CODE       ;SW11,CODE          3
            DB    REG        ;SW15,REG           4
            DB    GO         ;SW19,GO            5
            DB    0CH        ;SW2,C              6
            DB    0DH        ;SW7,D              7
            DB    0EH        ;SW12,E             8
            DB    0FH        ;SW16,F             9
            DB    INCKEY     ;SW20,COMMA (,)    10
            DB    08H        ;SW3,8             11
            DB    09H        ;SW8,9             12
            DB    0AH        ;SW13,A            13
            DB    0BH        ;SW17,B            14
            DB    ENDKEY     ;SW21,PERIOD(.)    15
            DB    04H        ;SW4,4             16
            DB    05H        ;SW9,5             17
            DB    06H        ;SW14,6            18
            DB    07H        ;SW18,7            19
            DB    RWKEY      ;SW22,R/W          20
            DB    00H        ;SW5,0             21
            DB    01H        ;SW10,1            22
            DB    02H        ;SW24,2            23
            DB    03H        ;SW23,3            24
            DB    RST        ;SW24  RST KEY     25

;*************************************************************
;*         8900 ������ �ε�� �ð� ���α׷�                  *
;*************************************************************
           ORG    8900H
LEDHOU     EQU    0FFC3H       ; ��(HOUR) ǥ�� â�� �ּ�
LEDMIN     EQU    0FFC2H       ; ��(MIN)  ǥ�� â�� �ּ�
LEDSEC     EQU    0FFC1H       ; ��(SEC)  ǥ�� â�� �ּ�
                
           LCALL  ALLCLEAR     ; �ʱ�ȭ
                        
CLOCK:     MOV    R0,#2
           DJNZ   R0, $
               
CONDITON:  CJNE   R5,#59H,SEC  ; "��" ���� ��
                                     
           CJNE   R6,#59H,MIN  ; "��" ���� ��

           CJNE   R7,#23H,HOUR ; "��" ���� ��
                                       
           ACALL  ALLCLEAR     ; �ٽ� �ʱ�ȭ
           LJMP   CLOCK        ; �ٽ� ����
                          
SEC:       MOV    A,R5    
           ADD    A,#1H        ; "��" ���� ���� 
           DA     A            ; ������ ǥ�� 
           MOV    R5,A    
           ACALL  DISSEC  
           SJMP   CLOCK   
                                
MIN:       MOV    A,R6               
           ADD    A,#1H        ; "��" ���� ����      
           DA     A            ; ������ ǥ��                 
           MOV    R6,A
           LCALL  CLRSEC       ; ��(SEC) �ʱ�ȭ
           LCALL  DISMIN       ; ��(MIN) ǥ�� ��ƾ ȣ��
           MOV    A,#00H
           LCALL  DISSEC       ; ��(SEC) ǥ�� ��ƾ ȣ��
           LJMP   CLOCK        ; CLOCK ���� �б�
                                 
HOUR:      MOV    A,R7
           ADD    A,#1H
           DA     A
           MOV    R7,A
           LCALL  CLRMIN
           LCALL  DISHOU
           MOV    A,#00H
           LCALL  DISMIN
           LCALL  DISSEC
           LJMP   CLOCK
      
ALLCLEAR:  LCALL  CLRHOU       ; ��,��,�� �ʱ�ȭ
           MOV    A,#00H       ; ������ ǥ�� â ȣ��
           LCALL  DISHOU
           LCALL  DISMIN
           LCALL  DISSEC
           RET
                                
CLRHOU:    MOV    R7,#0H       ; �� ���� �ʱ�ȭ
CLRMIN:    MOV    R6,#0H       ; �� ���� �ʱ�ȭ
CLRSEC:    MOV    R5,#0H       ; �� ���� �ʱ�ȭ
           RET
                                
DISHOU:    MOV    DPTR,#LEDHOU ; �� ǥ�� ��ƾ
           MOVX   @DPTR,A      
           RET                 
                               
DISMIN:    MOV    DPTR,#LEDMIN ; �� ǥ�� ��ƾ
           MOVX   @DPTR,A
           RET

DISSEC:    MOV    DPTR,#LEDSEC ; �� ǥ�� ��ƾ
           MOVX   @DPTR,A
           RET

           ORG    9F0BH  
           ; ���ͷ�Ʈ ���� ��ƾ�� ���� �ּ� 
           JMP    SERVICE 

END
