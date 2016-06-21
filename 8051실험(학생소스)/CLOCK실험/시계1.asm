          ORG     8000H  
	
;PROGRAMED BY  KIM HYUNG SOO
LEDHOU    EQU     0FFC3H    ; 시(Hour) 표시 주소
LEDMIN    EQU     0FFC2H    ; 분(Min)  표시 주소
LEDSEC    EQU     0FFC1H    ; 초(Sec)  표시 주소
ADJUST    EQU     000D9H    ; 시계 속도를 맞추기 위한 상수
                
          LCALL   ALLCLEAR  ; 초기화
                
CLOCK:    MOV     R2,#0008H 
DELAY3:   MOV     R1,#00FFH
DELAY2:   MOV     R0,#00E0H
DELAY1:   DJNZ    R0,DELAY1
          DJNZ    R1,DELAY2
          DJNZ    R2,DELAY3

;******************************************************
;*        920064 주기가 걸림                          *
;*        1초는 921600 주기가 필요 하다.              *
;*        따라서  1536 주기가 더 필요하다.            *
;******************************************************
               
          MOV     R4,ADJUST     
ADJUST2:  MOV     R3,#0002H    
ADJUST1:  DJNZ    R3,ADJUST1   
          DJNZ    R4,ADJUST2   

;******************************************************
;*    ADJUST 루틴에서 걸린 주기                       * 
;*    2*VAR*2 + VAR*3 = 7*VAR CYCLE                   *
;*    VAR=215 , 따라서 1505 주기가 된다.              *
;*    나머지 31 주기는 1초를 표시하는 루틴에서        *
;******************************************************
CONDITON: CJNE    R5,#59H,SEC     ; 초 단위 비교 
                                       
          CJNE    R6,#59H,MIN     ; 분 단위 비교
                                       
          CJNE    R7,#23H,HOUR    ; 시 단위 비교
                                       
          LCALL   ALLCLEAR        ; 23:59:59 -> 00:00:00
          LJMP    CLOCK           ; CLOCK으로 분기
                          
SEC:      MOV     A,R5          
          ADD     A,#1H           ; 초 단위 증가
          DA      A               ; 십진수 표현
          MOV     R5,A          
          LCALL   DISSEC          ; 초 표시 루틴 호출
          LJMP    CLOCK           ; CLOCK으로 분기
                 
               
MIN:      MOV     A,R6               
          ADD     A,#1H           ; 분 단위 증가
          DA      A               ; 십진수 표현    
          MOV     R6,A
          LCALL   CLRSEC          
          LCALL   DISMIN          ; 분 표시 루틴 호출
          MOV     A,#00H       
          LCALL   DISSEC          ; 초 00 표시 
          LJMP    CLOCK           ; CLOCK으로 분기
                 
                
HOUR:     MOV     A,R7
          ADD     A,#1H           ; 시 단위 증가 
          DA      A               ; 십진수 표현
          MOV     R7,A
          LCALL   CLRMIN
          LCALL   DISHOU          ; 시 표시 루틴 호출       
          MOV     A,#00H
          LCALL   DISMIN 
          LCALL   DISSEC
          LJMP    CLOCK
      
ALLCLEAR: LCALL   CLRHOU          ; 표시 초기화 루틴
          MOV     A,#00H         
          LCALL   DISHOU
          LCALL   DISMIN
          LCALL   DISSEC
          RET
                                
CLRHOU:   MOV     R7,#0H          ; 변수 초기화 루틴
CLRMIN:   MOV     R6,#0H
CLRSEC:   MOV     R5,#0H
          RET
                                
DISHOU:   MOV     DPTR,#LEDHOU    ; 시 표시 루틴
          MOVX    @DPTR,A        
          RET                    
                                 
DISMIN:   MOV     DPTR,#LEDMIN    ; 분 표시 루틴 
          MOVX    @DPTR,A
          RET

DISSEC:   MOV     DPTR,#LEDSEC
          MOVX    @DPTR,A
          RET          
END