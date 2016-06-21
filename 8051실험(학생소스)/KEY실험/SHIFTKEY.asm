; KEYPAD ���� 2 
;PROGRAMMED BY KIM HYUNG SOO
          ORG     8000H 
DATAOUT   EQU     0FFF0H ;������ �ƿ��� �ּ�
DATAIN    EQU     0FFF1H ;������ ���� �ּ�

DLED      EQU     0FFC1H ;������ 2��  7_SEGMENT�� �ּ�
ALED0     EQU     0FFC2H ;�߰� 2�� 7_SEGMENT�� �ּ�
ALED1     EQU     0FFC3H ;���� 2�� 7_SEGMENT�� �ּ�

;��� ���� 
REP_COUNT EQU     5

;���� ����

VSEC      EQU     30H  ; ������ 2���� 7_SEGMENT�� ǥ�� �� �� ����
VMIN      EQU     31H  ; �߰� 2���� 7_SEGMENT�� ǥ�� �� �� ���� 
VHOUR     EQU     32H  ; ���� 2���� 7_SEGMENT�� ǥ�� �� �� ����
VBUF      EQU     33H  ; �ӽ� ���� ���

          ORG     8000H
          MOV     SP,#60H    ; ���� �������� ��ġ�� �̵�

          MOV     VHOUR,#80H ; VHOUR�� �ʱ�ȭ
          MOV     VMIN,#51H  ; VMIN��  �ʱ�ȭ
          MOV     VSEC,#00H  ; VSEC��  �ʱ�ȭ
          CALL    DISPLAY

MAIN:     CALL    FINDKEYCODE   ; Ű�ڵ� ���� �о���� ��ƾ ȣ��
          JB      ACC.4, ERR    ; �Լ� Ű �̸�, ���� ǥ��
          MOV     VBUF, A       ; �о�� Ű �ڵ� ���� VBUF�� ����
          CALL    SHIFT         ; ǥ�� �̵� ��ƾ ȣ��
          CALL    DISPLAY       ; �̵��� ���� ǥ��   
          CALL    BOUNCE        ; �ٿ ������ ���ֱ� ���� ��ƾ ȣ�� 
          JMP     MAIN          ; �ݺ� ������ ���� �б�

ERR:      CALL    ERROR         ; ���� ǥ�� ��ƾ ȣ�� 
          JMP     MAIN          ; ���� ��ƾ���� ����

          ; ������ Ű�� ������ ������ ���� �ð� ����
BOUNCE:   CALL    DELAY         ; �ð� ���� ��ƾ ȣ��  

RELOAD:   MOV     A,#0          ; Ű�� ���� ������ üũ 
          CALL    SUBKEY       
          CPL     A
          JNZ     RELOAD        ; Ű�� �������� �ʾ�����, �ٽ� üũ

          CALL    DELAY         ; �ð� ���� ��ƾ ȣ��
          RET                   ; ���� ��ƾ���� ���� 

;****************************************************
;*        ���� ��ƾ : ERROR                         *
;*             �Է� : ����                          *
;*             ��� : 7_SEGMENT                     *
;*             ��� : REP_COUNT �� ������ Ƚ����ŭ  *
;*                    ���� �ѱ⸦ �ݺ�              *
;****************************************************

ERROR:    MOV     R4,#REP_COUNT

ERR_1:   
          MOV     VSEC,#0
          MOV     VMIN,#0
          MOV     VHOUR,#0
          CALL    DISPLAY       ; 6���� 7_SEGMENT �ѱ�
       
          MOV     R3,#10        
FIRST:    CALL    DELAY 
          DJNZ    R3,FIRST      ; ���� �ð� ����

          MOV     VSEC , #0FFH
          MOV     VMIN , #0FFH
          MOV     VHOUR, #0FFH
          CALL    DISPLAY       ; 6���� 7_SEGMENT �ѱ� 

          MOV     R3,#10      
SECOND:   CALL    DELAY         
          DJNZ    R3,SECOND     ; ���� �ð� ����

          DJNZ    R4,ERR_1      ; �ݺ� Ƚ�� ��ŭ �ݺ� �ߴ��� üũ 
          RET                   ; ���� ��ƾ���� ����
          

;***************************************************
;*        ���� ��ƾ : DELAY                        *
;*             �Է� : ����                         *
;*             ��� : ����                         *
;*             ��� : R1*2+3 ��ŭ�� �ð� ����      *
;***************************************************
DELAY:    MOV     R0,#020H

REPEAT:   MOV     R1,#0FFH
          DJNZ    R1,$
          DJNZ    R0,REPEAT
          RET         
      
;***************************************************
;*        ���� ��ƾ : SHIFT                        *
;*             �Է� : VBUF                         *
;*             ��� : VSEC,VMIN,VHOUR              *
;*             ��� : ǥ�õ� ���� �������� �̵�    *
;*                    ��Ű��                       *
;***************************************************
SHIFT:    MOV     A,VHOUR
          SWAP    A           
          MOV     VHOUR,A         

          MOV     A,VMIN
          SWAP    A
          MOV     VMIN,A          

          MOV     A,VSEC
          SWAP    A
          MOV     VSEC,A          

          MOV     A,VMIN
          MOV     R0,#VHOUR
          XCHD    A,@R0           
          MOV     VMIN,A

          MOV     A,VSEC
          MOV     R0,#VMIN
          XCHD    A,@R0           
          MOV     VSEC,A

          MOV     A,VBUF
          MOV     R0,#VSEC
          XCHD    A,@R0        ; ���� �Էµ� Ű ������ �ٲ�
          RET
           
;***************************************************
;*        ���� ��ƾ: FINDKEYCODE                   * 
;*             �Է�: A                             *
;*             ���: A                             *
;*             ���: Ű �ڵ尪��  ã�Ƴ���         *
;***************************************************

FINDKEYCODE:
           PUSH    PSW        ; ���ÿ� PSW���� ����
           SETB    PSW.4      ; ��ũ3 �������� ���
           SETB    PSW.3

INITIAL:   MOV     R1,#00H      ; R1���� �ʱ�ȭ
           MOV     A,#11101111B ; ������ �ƿ��� �ʱⰪ
           SETB    C             

COLSCAN:   MOV     R0,A         ; R0�� ������ �ƿ� �� ���� 
           INC     R1           ; R1 ���� �� ����
           CALL    SUBKEY       ; Ű �е� �Է� ���� ����

           CJNE    A,#0FFH,RSCAN
           ; ������� ���� 0FFH �� �ƴϸ�, Ű �Է��� �߻� 
                                 
           MOV     A,R0
           SETB    C
           RRC     A            ; ���� ���� �̵�
           JNC     INITIAL      ; ��� ���� ��ĵ������,�ٽ� ����
           JMP     COLSCAN      ; ���� ���� ��ĵ�� ���� �б�

RSCAN:     MOV     R2,#00H      ; R2 ���� �� ����
ROWSCAN:   RRC     A            ; ��� ���� 1 �� �ٲ������ ����
           JNC     MATRIX       ; ĳ���� �߻��ϸ�, MATRIX�� �б�
           INC     R2           ; ĳ���� �߻����� ������, ���� ������ �̵�
           JMP     ROWSCAN      ; ���� ���� ��ĵ�� ���� �б�

MATRIX:    MOV     A,R2         ; R2���� ���� �� ����
           MOV     B,#05H       ; 1���� 5���� �̷����
           MUL     AB           ; 2���� �迭�� 1���� �迭�� ���� �ٲ�
           ADD     A,R1         ; R1���� ���� �� ����
           CALL    INDEX        ; Ű �ڵ� ���� ����
           POP     PSW          ; �������� ���� PSW ���� ������ ��
           RET                  ; ���� ��ƾ���� ����


;*****************************************************************
;*         ���� ��ƾ : SUBKEY                                    *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : ������ �ƿ����� �����͸� ��������         *
;*                     ������ ������ ����� Ȯ��                 * 
;*****************************************************************
SUBKEY:    MOV     DPTR,#DATAOUT
           MOVX    @DPTR,A
           MOV     DPTR,#DATAIN
           MOVX    A,@DPTR
           RET

;*****************************************************************
;*         ���� ��ƾ : DISPLAY                                   *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : Ű �ڵ尪�� 7_SEGMENT �� ǥ��             *
;*****************************************************************

DISPLAY:   MOV     DPTR,#DLED    ; ������ 2���� 7_SEGMENT ����
           MOV     A,VSEC        ; VSEC ���� ������
           MOVX    @DPTR,A       ; VSEC ���� ǥ��

           MOV     DPTR,#ALED0   ; �߰� 2���� 7_SEGMENT ����
           MOV     A,VMIN        ; VMIN ���� ������
           MOVX    @DPTR,A       ; VMIN ���� ǥ��

           MOV     DPTR,#ALED1   ; ������ 2���� 7_SEGMENT ����
           MOV     A,VHOUR       ; VHOUR ���� ������
           MOVX    @DPTR,A       ; VHOUR ���� ǥ��
           RET                   ; ���� ��ƾ���� ����             
 
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


INDEX:     MOVC    A,@A+PC ;������ 1 ~ 24�� ���� ������.
           RET

KEYBASE:   DB ST         ;SW1,ST                 1
           DB CODE       ;SW6,CODE               2
           DB DECKEY     ;SW11,CD                3
           DB REG        ;SW15,REG               4
           DB GO         ;SW19,GO                5
           DB 0CH        ;SW2,C                  6
           DB 0DH        ;SW7,D                  7
           DB 0EH        ;SW12,E                 8
           DB 0FH        ;SW16,F                 9
           DB INCKEY     ;SW20,COMMA (,)        10
           DB 08H        ;SW3,8                 11
           DB 09H        ;SW8,9                 12
           DB 0AH        ;SW13,A                13
           DB 0BH        ;SW17,B                14
           DB ENDKEY     ;SW21,PERIOD(.)        15
           DB 04H        ;SW4,4                 16
           DB 05H        ;SW9,5                 17
           DB 06H        ;SW14,6                18
           DB 07H        ;SW18,7                19
           DB RWKEY      ;SW22,R/W              20
           DB 00H        ;SW5,0                 21
           DB 01H        ;SW10,1                22
           DB 02H        ;SW24,2                23
           DB 03H        ;SW23,3                24
           DB RST        ;SW24  RST KEY         25

END
