	      ORG 8000H  ;THIS IS UPGRADE OF SOOUP2
	
                                       ;USING CJNE AND CHANGE CLOCK BLOCK	
            ;PROGRAMED BY SUNG HO YOUNG AND KIM HYUNG SOO
LEDHOU         EQU      0FFE3H         ;ADDRESS OF HOUR LED
LEDMIN         EQU      0FFE2H         ;ADDRESS OF MINUTE LED
LEDSEC         EQU      0FFE0H         ;ADDRESS OF SECOND LED
ADJUST         EQU      000D9H         ;ADJUST CLOCK SPEED
                
               LCALL    ALLCLEAR       ;INITIALIZE ;;         
                
                                       ;CLOCK BLOCK  

CLOCK:         MOV R2,#0008H 
DELAY3:        MOV R1,#00FFH
DELAY2:        MOV R0,#00E0H
DELAY1:        DJNZ R0,DELAY1
               DJNZ R1,DELAY2
               DJNZ R2,DELAY3

 ;************************************************************************
 ;*        TOTAL 920064 CYCLE                                            *
 ;*        ONE SECOND IS 921600 MACHINE CYCLE                            *
 ;*                                                                      *
 ;*        NOW 1536 CYCLE IS ADDTIONALLY NEED                            *
 ;*                                                                      *
 ;************************************************************************
               
               MOV R4,ADJUST       ;
ADJUST2:       MOV R3,#0002H     ;---------VAR*3 CYCLE-----------------*
ADJUST1:       DJNZ R3,ADJUST1   ; 2*VAR*2 CYCLE                       *
               DJNZ R4,ADJUST2   ;-------------------------------------*

 ;************************************************************************
 ;*                                                                      *
 ;*    TOTAL ADJUST BLOCK CYCLE IS 2*VAR*2 + VAR*3 = 7*VAR CYCLE         *
 ;*    VAR IS 215 , SO TOTAL ADJUST BLOCK IS 1505 CYCLE                  *
 ;*    LAST 31 CYCLE IS SECOND LUTIN                                     *
 ;************************************************************************
CONDITON:      CJNE R5,#59H,SEC        ;IF R5 ==59 THEN NEXT CONDITION
                                       ;ELSE JUMP TO DIGIT3
           
               CJNE R6,#59H,MIN        ;IF R6 ==59 THEN NEXT CONDITION
                                       ;           ELSE JUMP TO DIGIT5

               CJNE R7,#23H,HOUR       ;IF R7 ==23 THEN NEXT CONDITION
                                       ;           ELSE JUMP TO DIGIT7

               LCALL ALLCLEAR          ;RESET BLOCK >> LED IS FULL,
               LJMP CLOCK              ;RESET ALL VARIABLES AND RESTART
                          
SEC:            MOV A,R5               ;R5 = R5+1
                ADD A,#1H              ;DECLMAL ADJUST AND
                DA A                   ;MOVE TO RESISTER,NOW IT IS BCD CODE  
                MOV R5,A               ;LED1 IS FORM OF (R5 0)
                LCALL DISSEC           ;DISPLAY SECOND 
                LJMP CLOCK             ;RETURN
                 
               
MIN:            MOV A,R6               ;R6 IS BCD CODE
                ADD A,#1H              ;ADD 1 AND DECIMAL ADJUST
                DA A                   
                MOV R6,A
                LCALL CLRSEC           ;RESET SECOND AND
                LCALL DISMIN           ;DISPLAY MIN
                MOV A,#00H
                LCALL DISSEC
                LJMP CLOCK
                 
                
HOUR:           MOV A,R7
                ADD A,#1H
                DA A
                MOV R7,A
                LCALL CLRMIN
                LCALL DISHOU
                MOV A,#00H
                LCALL DISMIN
                LCALL DISSEC
                LJMP CLOCK
      
ALLCLEAR:       LCALL CLRHOU            ;CLR ALL REGISTER & 
                MOV A,#00H              ;LED DISPLAY
                LCALL DISHOU
                LCALL DISMIN
                LCALL DISSEC
                RET
                                
CLRHOU:         MOV R7,#0H               ;CLEAR BLOCK
CLRMIN:         MOV R6,#0H
CLRSEC:         MOV R5,#0H
                RET
                                
DISHOU:         MOV DPTR,#LEDHOU         ;LED_DISPLAY BLOCK
                MOVX @DPTR,A             ;LED BLOCK DISPLAY THE BCD
                RET                      ;VALUE IN REGISTER R7 TO LED1
                                         ;         REGISTER R6 TO LED2
DISMIN:         MOV DPTR,#LEDMIN         ;         REGISTER R5 TO LED3
                MOVX @DPTR,A
                RET

DISSEC:         MOV DPTR,#LEDSEC
                MOVX @DPTR,A
                RET
                ;
                END