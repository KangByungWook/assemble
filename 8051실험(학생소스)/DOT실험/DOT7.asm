;DOT MATRIX ����7 ~  ���� �¿� �̵��ϱ� "��"  

COLGREEN     EQU    0FFC5H    
COLRED       EQU    0FFC6H   
ROW          EQU    0FFC7H   

REPEAT       EQU    20H     ; ���̳��� ���� Ƚ�� ����
LSHIFTNUM    EQU    21H     ; ���� �̵� �� ���� 
RSHIFTNUM    EQU    22H     ; ������ �̵� �� ���� 
MODE         EQU    23H     ; �̵� ��� �� ���� 
TEMP         EQU    24H     ; �ӽ� ���� ����

             ORG    8000H
             SETB   PSW.3
             SETB   PSW.4   ; ��ũ3 �������� ��� 

             ;*********************  ��Ʈ ��Ʈ���� LED Ŭ���� 
             MOV    R1,#00H          ; DOT MATRIX LED ����
             MOV    R2,#00H
             MOV    R0,#00H
            
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY

;****************************************************
;*     ���� �̵� ���� ���α׷��� ���� �κ�          *  
;*     �߿� ��� ����                               *
;*       R0 : DOT ROW �� ����                       *
;*       R1 : DOT COLUMN GREEN �� ����              *
;*       R2 : DOT COLUMN RED �� ����                *
;****************************************************
MAIN:        MOV    REPEAT,#20H     ; ���̳��� ���� Ƚ�� ����
             MOV    LSHIFTNUM,#00H  
             MOV    RSHIFTNUM,#07H  

RSTART:      MOV    A,RSHIFTNUM      
             DEC    A
             MOV    RSHIFTNUM,A
             CJNE   A,#00H,LOOP1

FSTART:      MOV    MODE,#01H
             CALL   DYNAMIC
             DJNZ   REPEAT,FSTART
             MOV    REPEAT,#20H

LSTART:      MOV    A,LSHIFTNUM
             INC    A
             MOV    LSHIFTNUM,A
             CJNE   A,#07H,LOOP2
             JMP    MAIN
             
LOOP1:       MOV    MODE,#02H
             CALL   DYNAMIC
             DJNZ   REPEAT,LOOP1
             MOV    REPEAT,#20H
             JMP    RSTART

LOOP2:       MOV    MODE,#04H
             CALL   DYNAMIC
             DJNZ   REPEAT,LOOP2
             MOV    REPEAT,#20H             
             JMP    LSTART

;***************************************************
;*     ���� ��ƾ: DYNAMIC                          *
;*          �Է�: MODE ( �̵� ���� �� ���� ���� )  *
;*          ���: ��Ʈ ��Ʈ���� LED                *
;*          ���: ���̳��� ����                    *
;***************************************************

DYNAMIC:     MOV    R0,#00000010B   ; �ι�° �� ����
             MOV    R3,#00H         ; �ε��� �� ���� 
                   
DLOOP:       CALL   KOR             ; ������ �о���� 

             ;******************* �̵� ��忡 ���� �̵�
             MOV    A,MODE          
             CJNE   A,#02H,PATH1
             CALL   RSHIFT           
             JMP    DOTON
            
PATH1:       CJNE   A,#04H,PATH2
             CALL   LSHIFT
             JMP    DOTON
 
PATH2:       CJNE   A,#01H,RPT

             ;****************** ��Ʈ ��Ʈ���� LED �ѱ�                  
DOTON:       CALL   DOTCOLR  ; �ѱ�
             CALL   DELAY    ; �����ð� ���� ���� ���� ����

             MOV    TEMP,R0  ; ���� ���� �� ����
             
             ;****************** ��Ʈ ��Ʈ���� LED ����
             MOV    R2,#00H
             MOV    R0,#00H
             CALL   DOTCOLR  ; ����   

             MOV    R0,TEMP  ; ���� ���� �� ����
             
             CLR    C 
             MOV    A,R0
             RLC    A        ; ���� ������ �̵�
             MOV    R0,A

             CJNE   A,#10000000B,DLOOP              
RPT:         RET             ; ���� ��ƾ ����          

;***********************************************
;*     ���� ��ƾ: KOR                          *
;*          �Է�: R3                           *
;*          ���: R2                           *
;*          ���: ������ �о� ���� �κ�        *
;***********************************************
KOR:         MOV    DPTR,#FONT 
             MOV    A,R3
             MOVC   A,@A+DPTR                 
             MOV    R2,A
             INC    R3 
             RET                 
                             ; "��" ������
FONT:                        
DB           7EH,40H,40H,40H,40H,40H  

;************************************************
;*     ���� ��ƾ: RSHIFT                        *
;*          �Է�: R2,RSHIFTNUM                  *
;*          ���: R2                            *
;*          ���: �о�� ������ ��������        *    
;*                �̵� Ƚ�� ��ŭ �̵�           *
;************************************************
RSHIFT:      MOV    TEMP,RSHIFTNUM  ; ������ �̵� Ƚ�� ����
RBACK:       CLR    C
             MOV    A,R2
             RRC    A               ; ������ �̵�
             MOV    R2,A
             DJNZ   RSHIFTNUM,RBACK
             MOV    RSHIFTNUM,TEMP  ; ������ �̵� Ƚ�� ����
             RET

;************************************************
;*     ���� ��ƾ: LSHIFT                        *
;*          �Է�: R2,LSHIFTNUM                  *
;*          ���: R2                            *
;*          ���: �о�� ������ ��������        *
;*                �̵� Ƚ�� ��ŭ �̵�           *
;************************************************ 
LSHIFT:      MOV    TEMP,LSHIFTNUM  ; ���� �̵� Ƚ�� ����
LBACK:       CLR    C
             MOV    A,R2
             RLC    A               ; ���� �̵�
             MOV    R2,A
             DJNZ   LSHIFTNUM,LBACK
             MOV    LSHIFTNUM,TEMP  ; ���� �̵� Ƚ�� ����
             RET 

;************************************************
;*     ���� ��ƾ: DOTCOLG                       *
;*          �Է�: R1,R0                         *
;*          ���: ��Ʈ ��Ʈ���� LED             *
;*          ���: �־��� ��� ���� ����         *
;*                �ش��ϴ�  ���λ� LED �ѱ�     *                   
;************************************************ 
DOTCOLG:     MOV    DPTR,#COLGREEN
             MOV    A,R1
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET

;************************************************
;*     ���� ��ƾ: DOTCOLR                       *
;*          �Է�: R2,R0                         *
;*          ���: ��Ʈ ��Ʈ���� LED             *
;*          ���: �־��� ��� ���� ����         *
;*                �ش��ϴ�  ������ LED �ѱ�     *                   
;************************************************ 
DOTCOLR:     MOV    DPTR,#COLRED
             MOV    A,R2
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET 

;************************************************
;*           ���: LED �� ���� �ִ�             *
;*                 �ð� ����                    *
;************************************************
DELAY:       MOV    R7,#01H
DELAY1:      MOV    R6,#0CFH
DELAY2:      DJNZ   R6,DELAY2
             DJNZ   R7,DELAY1
             RET 


END
                     
                


                    






                


                    





