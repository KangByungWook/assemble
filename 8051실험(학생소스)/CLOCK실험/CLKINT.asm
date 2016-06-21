; Ÿ�̸�0 ���1 �� �̿��� �ð�

LEDHOU      EQU    0FFC3H ; ����   2�� 7_SEGMENT�� �ּ�        
LEDMIN      EQU    0FFC2H ; �߰�   2�� 7_SEGMENT�� �ּ�        
LEDSEC      EQU    0FFC1H ; ������ 2�� 7_SEGMENT�� �ּ�        

VSEC        EQU    30H           
VMIN        EQU    31H          
VHOUR       EQU    32H            

            ORG    0000H
            JMP    START             ; 2

            ORG    000BH
            JMP    SERVICE           ; 2
  
START:      MOV    SP   ,#60H        ; 2       
            MOV    R4   ,#100        ; 1        
            MOV    VSEC ,#0H         ; 2       
            MOV    VMIN ,#0H         ; 2       
            MOV    VHOUR,#0H         ; 2       
            CALL   DISPLAY           ; 2         
                                     ;30 
            MOV    TMOD , #00010001B ; 2
            MOV    IE   , #10000010B ; 2 
            SETB   ET0               ; 1
            MOV    TH0  , #0DCH      ; 2
            MOV    TL0  , #2FH       ; 2
            SETB   TCON.TR0          ; 1
                                     ;40 
            ; FFFF - DC2F = 23D0 =  9168
            ; FFFF ���� 00000�� �ٲ� �����÷ο찡 �߻�
            ; JMP $ �� �ѹ��� ����Ǿ�� �Ѵ�. �׷��� TF �� SET
            JMP    $                 ; 2 
                                  ; 9210    
SERVICE:    CLR    TCON.TR0          ; 1  << SERVICE ��ƾ�� ������ 9216  
            MOV    TH0   , #0DCH     ; 2    
            MOV    TL0   , #0CH      ; 2  
            SETB   TCON.TR0          ; 1     
            ; FFFF - DC0C = 23F3 >> 9203
            ;  ���ñ���             9208 
            ; DJNZ �� �Ϲ��� ����Ǿ�� �Ѵ�. �׷��� TF �� SET
                                  ; 9210  
            DJNZ   R4 , CONTINUE     ; 2
            CALL   UPDATE
            MOV    R4 , #100              
CONTINUE:   RETI                     ; 2 


UPDATE:     NOP
            MOV    R0 , #VSEC      

            CJNE   @R0 ,#59H,SEC 
            MOV    @R0 , #0      
            INC    R0         
            SJMP   MINCHECK   

SEC:        SJMP   ADDONE       
                         
MINCHECK:   CJNE   @R0 ,#59H,MIN      
            MOV    @R0 , #0          
            INC    R0               
            JMP    HOURCHECK        

MIN:        JMP    ADDONE            

HOURCHECK:  CJNE   @R0 , #23H,HOUR     
            MOV    @R0 , #0          
            ;INC R0                
            JMP    RETPOINT          

HOUR:       JMP    ADDONE           


RETPOINT:   CALL   DISPLAY           
            RET                     

ADDONE:     MOV    A, @R0            
            ADD    A, #1             
            DA     A                  
            MOV    @R0 , A            
            SJMP   RETPOINT           
                          
DISPLAY:    MOV    DPTR,#LEDSEC  ;2     
            MOV    A, VSEC       ;1     
            MOVX   @DPTR,A       ;2   

            MOV    DPTR,#LEDMIN  ;2     
            MOV    A, VMIN       ;1     
            MOVX   @DPTR,A       ;2    

            MOV    DPTR,#LEDHOU  ;2     
            MOV    A, VHOUR      ;1    
            MOVX   @DPTR,A       ;2    
            RET                  ;2              
                                 ;17 
END               