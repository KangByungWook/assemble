;         산술 연산 시험 
;         1334H - 12EFH  
;         4916D - 4847D = 69D (45H)


          ORG   8000H

          MOV   40H,#34H
          MOV   41H,#13H


          MOV   42H,#0EFH   
          MOV   43H,#12H
 
          ;하위 바이트 먼저 더함.
          CLR   C
          MOV   A,40H                   
          SUBB  A,42H  ;빌림수(Borrow)발생       34H - EFH = FFFF45H
 
          MOV   40H,A  ; 40H 번지에 저장 = 40H 번지의 내용 - 42H 번지의 내용  
       

          ;상위 바이트 먼저 더함.
          MOV   A,41H
          SUBB  A,43H  ;캐리발생       13H - 12H - 1H(Borrow) = 00H
 
          MOV   41H,A  ; 41H 번지에 저장 = 401 번지의 내용 - 43H 번지의 내용  - Borrow
