;         ��� ���� ���� 

          ORG   8000H

          MOV   A,#76H    ;0111_0110    118
          ADD   A,#57H    ;0101_0111   + 87
                          ;Over Flow �߻�  
;
          MOV   A,#86H      ;1000_0110  -122
          MOV   R5,#67H     ;0110_0111  +103
          ADD   A,R5        ;1110_1101  -19
;
          MOV   A,#78H
          MOV   20H,#88H
          MOV   R1,#20H
          ADDC  A,@R1

;      
          MOV   A,#78H      ;0111_1000  +120
          MOV   20H,#88H    ;1000_1000  -120
          MOV   R1,#20H
          MOV   0D0H,#80H   ;������ PSW�� Carry�� 1�� ����.
          ADDC  A,@R1       ;Overflow �߻�, AuxCarry �߻�,  1�ǰ���
;
          MOV   A,#22H      ; 34
          MOV   60H,#35H    ; 53
          MOV   0D0H,#80H   ;������ PSW�� Carry�� 1�� ����
          SUBB  A,60H       ; 34 - 53 - 1 = -20

