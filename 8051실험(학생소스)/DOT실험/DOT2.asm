;DOT MATRIX ����2 ~  ������ �� ��ü ��ĵ ���� 

COLGREEN     EQU    0FFC5H  
COLRED       EQU    0FFC6H   
ROW          EQU    0FFC7H   

             ORG    8000H

;****************************************************
;*       R0 : DOT ROW �� ����                       *
;*       R1 : DOT COLUMN GREEN �� ����              *
;*       R2 : DOT COLUMN RED �� ����                *
;****************************************************

             MOV    R1,#00H        ; DOT MATRIX LED ����
             MOV    R2,#00H
             MOV    R0,#00H
              
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY
               
INIT1:       MOV    R2,#00000000B
             MOV    R0,#00000000B    
             CALL   DOTCOLR        ; RED COLOR ����

             MOV    R1,#11111111B  ; ��� �� ON
             MOV    R0,#00000001B  ; ù��° �� ON 
             CLR    C                

LOOP1:       CALL   DOTCOLG        ; GREEN COLOR �ѱ�
             CALL   DELAY
               
             MOV    A,R0
             RLC    A              ; ���� ������ �̵� 
             MOV    R0,A

             JC     INIT2          ; ���� �ٲٱ� 
             JMP    LOOP1          ; ��� �ݺ��ϱ�     

INIT2:       MOV    R1,#00000000B
             MOV    R0,#00000000B
             CALL   DOTCOLG        ; GREEN COLOR ����

             MOV    R2,#11111111B  ; ��� �� ON 
             MOV    R0,#00000001B  ; ù��° �� ON
             CLR    C
             
LOOP2:       CALL   DOTCOLR        ; RED COLOR �ѱ�
             CALL   DELAY

             MOV    A,R0
             RLC    A              ; ���� ������ �̵�
             MOV    R0,A

             JC     INIT1          ; ���� �ٲٱ�
             JMP    LOOP2          ; ��� �ݺ��ϱ� 
                         
DOTCOLG:     MOV    DPTR,#COLGREEN
             MOV    A,R1
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET

DOTCOLR:     MOV    DPTR,#COLRED
             MOV    A,R2
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET 

DELAY:       MOV    R7,#02H
DELAY1:      MOV    R6,#0FFH
DELAY2:      MOV    R5,#0FFH
DELAY3:      DJNZ   R5,DELAY3
             DJNZ   R6,DELAY2
             DJNZ   R7,DELAY1
             RET 
END
                     
                