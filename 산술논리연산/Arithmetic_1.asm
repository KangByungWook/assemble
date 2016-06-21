;         산술 연산 시험 

          ORG   8000H

          MOV   R0, #40H
          MOV   @R0,#00H
          DEC   @R0
          INC   40H
;

          MOV   DPTR,#12FFH
          INC   DPTR
;
          DEC   DPL
          DEC   DPH


        