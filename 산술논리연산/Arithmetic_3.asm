;         산술 연산 시험 
;         1234H+ 12EFH  
;         4660D + 4847D = 9507 (2325H)


          ORG   8000H

          MOV   40H,#34H
          MOV   41H,#12H


          MOV   42H,#0EFH   
          MOV   43H,#12H
 
          ;하위 바이트 먼저 더함.
          MOV   A,40H                   
          ADD   A,42H  ;캐리발생       34H + EFH = 123H (1_0010_0011B)
 
          MOV   40H,A  ; 40H 번지에 저장 = 40H 번지의 내용 + 42H 번지의 내용  
       

          ;상위 바이트 먼저 더함.
          MOV   A,41H
          ADDC  A,43H  ;캐리발생       12H + 12H +1H(Carry) = 25H (10_0101B)
 
          MOV   41H,A  ; 41H 번지에 저장 = 401 번지의 내용 + 43H 번지의 내용  + Carry

       

