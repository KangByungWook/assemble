;         ��� ���� ���� 
;         1334H - 12EFH  
;         4916D - 4847D = 69D (45H)


          ORG   8000H

          MOV   40H,#34H
          MOV   41H,#13H


          MOV   42H,#0EFH   
          MOV   43H,#12H
 
          ;���� ����Ʈ ���� ����.
          CLR   C
          MOV   A,40H                   
          SUBB  A,42H  ;������(Borrow)�߻�       34H - EFH = FFFF45H
 
          MOV   40H,A  ; 40H ������ ���� = 40H ������ ���� - 42H ������ ����  
       

          ;���� ����Ʈ ���� ����.
          MOV   A,41H
          SUBB  A,43H  ;ĳ���߻�       13H - 12H - 1H(Borrow) = 00H
 
          MOV   41H,A  ; 41H ������ ���� = 401 ������ ���� - 43H ������ ����  - Borrow
