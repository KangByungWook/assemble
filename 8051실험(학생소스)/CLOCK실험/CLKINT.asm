; 타이머0 모드1 을 이용한 시계

LEDHOU      EQU    0FFC3H ; 왼쪽   2개 7_SEGMENT의 주소        
LEDMIN      EQU    0FFC2H ; 중간   2개 7_SEGMENT의 주소        
LEDSEC      EQU    0FFC1H ; 오른쪽 2개 7_SEGMENT의 주소        

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
            ; FFFF 에서 00000로 바뀔때 오버플로우가 발생
            ; JMP $ 가 한번더 수행되어야 한다. 그래야 TF 가 SET
            JMP    $                 ; 2 
                                  ; 9210    
SERVICE:    CLR    TCON.TR0          ; 1  << SERVICE 루틴에 왔을때 9216  
            MOV    TH0   , #0DCH     ; 2    
            MOV    TL0   , #0CH      ; 2  
            SETB   TCON.TR0          ; 1     
            ; FFFF - DC0C = 23F3 >> 9203
            ;  세팅까지             9208 
            ; DJNZ 가 하번더 수행되어야 한다. 그래야 TF 가 SET
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