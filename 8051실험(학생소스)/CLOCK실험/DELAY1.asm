; 窜老风橇 DELAY

             ORG     0000H

             MOV     R0,#0FFH   ; 1  林扁
DELAY:       DJNZ    R0,DELAY   ; 2*R0 林扁
             JMP     $          ; 1+2*R0 林扁 
                     
