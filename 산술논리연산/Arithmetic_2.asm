;         산술 연산 시험 

          ORG   8000H

          MOV   A,#76H    ;0111_0110    118
          ADD   A,#57H    ;0101_0111   + 87
                          ;Over Flow 발생  
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
          MOV   0D0H,#80H   ;강제로 PSW의 Carry에 1을 넣음.
          ADDC  A,@R1       ;Overflow 발생, AuxCarry 발생,  1의갯수
;
          MOV   A,#22H      ; 34
          MOV   60H,#35H    ; 53
          MOV   0D0H,#80H   ;강제로 PSW의 Carry에 1을 넣음
          SUBB  A,60H       ; 34 - 53 - 1 = -20

