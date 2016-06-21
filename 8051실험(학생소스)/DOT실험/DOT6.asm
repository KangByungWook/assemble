;DOT MATRIX ����6 ~  ���� ����� "��" ǥ�� ���� 

COLGREEN     EQU    0FFC5H  
COLRED       EQU    0FFC6H   
ROW          EQU    0FFC7H   
TEMP         EQU    30H

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
               
START:       MOV    R0,#00000001B
             MOV    R3,#00H
             CLR    C
                    
LOOP:        CALL   KOR            ; ���� ǦƮ �о� ���� 
             CALL   DOTCOLR        ; ��Ʈ ��Ʈ���� LED �ѱ�
             CALL   DELAY

             MOV    R2,#00H
             MOV    TEMP,R0        ; ���� ���� �� ����

             MOV    R0,#00H
             CALL   DOTCOLR        ; ��Ʈ ��Ʈ���� LED ����  

             MOV    R0,TEMP        ; ���� ���� �� ����
             MOV    A,R0
             RLC    A
             MOV    R0,A
             JC     START
             JMP    LOOP       
             
                                   ; ���� ��Ʈ �о���� ��ƾ 
KOR:         MOV    DPTR,#FONT
             MOV    A,R3
             MOVC   A,@A+DPTR                 
             MOV    R2,A
             INC    R3 
             RET                 

FONT:
DB           00H,7EH,40H,40H,40H,40H,40H,00H  


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

DELAY:       MOV    R7,#05H   ; 05
DELAY1:      MOV    R6,#40H   ; CF
DELAY2:      DJNZ   R6,DELAY2
             DJNZ   R7,DELAY1
             RET 
END
                     
                


                    


