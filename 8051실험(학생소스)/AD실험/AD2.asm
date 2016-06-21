; AD 실험2 
DAC       EQU     0FFD1H
ADC       EQU     0FFD0H

          ORG     8000H
       
ADCON:    MOV     DPTR,#ADC
          MOVX    A,@DPTR     ; A/D 변환 읽기
                       
DACON:    MOV     DPTR , #DAC
          MOVX    @DPTR, A    ; D/A 변환 쓰기
          JMP     ADCON

END
