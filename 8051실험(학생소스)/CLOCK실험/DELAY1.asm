; ���Ϸ��� DELAY

             ORG     0000H

             MOV     R0,#0FFH   ; 1  �ֱ�
DELAY:       DJNZ    R0,DELAY   ; 2*R0 �ֱ�
             JMP     $          ; 1+2*R0 �ֱ� 
                     
