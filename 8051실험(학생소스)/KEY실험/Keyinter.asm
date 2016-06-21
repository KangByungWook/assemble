; Ű �е� �������̽� ����1 
          ORG      8000H   
DATAOUT   EQU      0FFF0H  ;������ �ƿ��� �ּ�
DATAIN    EQU      0FFF1H  ;������ ���� �ּ�
DLED      EQU      0FFC1H  ;������ 2���� 7_SEGMENT �ּ�
ALED0     EQU      0FFC2H  ;�߰� 2���� 7_SEGMENT �ּ�
ALED1     EQU      0FFC3H  ;���� 2���� 7_SEGMENT �ּ�

LOOP:     CALL     SCANN   ; ��ĵ ��ƾ ȣ�� 
          JMP      LOOP    ; �ݺ� ������ ���� �б� 

;Ű �е� �������̽� ����

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
           JC       MATRIX        ; ĳ���� �߻��ϸ�, MATRIX�� �б�
           INC      R2            ; ĳ���� �߻����� ������, ���� ������ �̵�
           JMP      ROWSCAN       ; ���� ���� ��ĵ�� ���� �б�

MATRIX:    MOV      A,R2          ; R2 ���� ���� �� ����
           MOV      B,#05H        ; 1���� 5���� �̷����
           MUL      AB            ; 2���� �迭�� 1���� �迭�� ���� �ٲ�
           ADD      A,R1          ; R1 ���� ���� �� ����
           CALL     INDEX         ; Ű �ڵ� ���� ����
           CALL     DISPLAY       ; Ű �ڵ� ���� ǥ�� 
           POP      PSW           ; �������� ���� PSW���� ������ ��
           RET                    ; ���� ��ƾ���� ����


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
;*         ���� ��ƾ : DISPLAY                                   *
;*              �Է� : ACC                                       *
;*              ��� : ACC                                       *
;*              ��� : Ű �ڵ尪�� 7_SEGMENT �� ǥ��             *
;*****************************************************************
DISPLAY:   MOV      DPTR,#DLED
           MOVX     @DPTR,A
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
