; AD ����2 
DAC       EQU     0FFD1H
ADC       EQU     0FFD0H

          ORG     8000H
       
ADCON:    MOV     DPTR,#ADC
          MOVX    A,@DPTR     ; A/D ��ȯ �б�
                       
DACON:    MOV     DPTR , #DAC
          MOVX    @DPTR, A    ; D/A ��ȯ ����
          JMP     ADCON

END
