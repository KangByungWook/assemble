;DOT MATRIX 실험7 ~  글자 이동하기 "ㄱ"  

COLGREEN     EQU    0FFC5H    
COLRED       EQU    0FFC6H   
ROW          EQU    0FFC7H   

REPEAT       EQU    20H     ; 다이나믹 점등 횟수 보관
LSHIFTNUM    EQU    21H     ; 왼쪽 이동 값 보관 
RSHIFTNUM    EQU    22H     ; 오른쪽 이동 값 보관 
MODE         EQU    23H     ; 이동 모드 값 보관 
TEMP         EQU    24H     ; 임시 저장 변수

             ORG    8000H
             SETB   PSW.3
             SETB   PSW.4
             ;*********************  도트 매트릭스 LED 클리어 
             MOV    R1,#00H          ; DOT MATRIX LED 끄기
             MOV    R2,#00H
             MOV    R0,#00H
            
             CALL   DOTCOLG
             CALL   DOTCOLR
             CALL   DELAY

;****************************************************
;*     글자 이동 실험 프로그램의 메인 부분          *  
;*     중요 사용 변수                               *
;*       R0 : DOT ROW 값 저장                       *
;*       R1 : DOT COLUMN GREEN 값 저장              *
;*       R2 : DOT COLUMN RED 값 저장                *
;****************************************************
MAIN:        MOV    REPEAT,#20H     ; 다이나믹 점등 횟수 지정
             MOV    LSHIFTNUM,#00H  
             MOV    RSHIFTNUM,#07H  

RSTART:      MOV    A,RSHIFTNUM      
             DEC    A
             MOV    RSHIFTNUM,A
             CJNE   A,#00H,LOOP1

FSTART:      MOV    MODE,#01H
             CALL   DYNAMIC
             DJNZ   REPEAT,FSTART
             MOV    REPEAT,#20H

LSTART:      MOV    A,LSHIFTNUM
             INC    A
             MOV    LSHIFTNUM,A
             CJNE   A,#07H,LOOP2
             JMP    MAIN
             
LOOP1:       MOV    MODE,#02H
             CALL   DYNAMIC
             DJNZ   REPEAT,LOOP1
             MOV    REPEAT,#20H
             JMP    RSTART

LOOP2:       MOV    MODE,#04H
             CALL   DYNAMIC
             DJNZ   REPEAT,LOOP2
             MOV    REPEAT,#20H             
             JMP    LSTART

;***************************************************
;*     서브 루틴: DYNAMIC                          *
;*          입력: MODE ( 이동 여부 및 방향 결정 )  *
;*          출력: 도트 매트릭스 LED                *
;*          기능: 다이나믹 점등                    *
;***************************************************

DYNAMIC:     MOV    R0,#00000010B   ; 두번째 행 지정
             MOV    R3,#00H         ; 인덱스 값 저장 
                   
DLOOP:       CALL   KOR             ; 데이터 읽어오기 

             ;******************* 이동 모드에 따라 이동
             MOV    A,MODE          
             CJNE   A,#02H,PATH1
             CALL   RSHIFT           
             JMP    DOTON
            
PATH1:       CJNE   A,#04H,PATH2
             CALL   LSHIFT
             JMP    DOTON
 
PATH2:       CJNE   A,#01H,RPT

             ;****************** 도트 매트릭스 LED 켜기                  
DOTON:       CALL   DOTCOLR  ; 켜기
             CALL   DELAY    ; 일정시간 동안 켜진 상태 유지

             MOV    TEMP,R0  ; 현재 행의 값 저장
             
             ;****************** 도트 매트릭스 LED 끄기
             MOV    R2,#00H
             MOV    R0,#00H
             CALL   DOTCOLR  ; 끄기   

             MOV    R0,TEMP  ; 현재 행의 값 복원
             
             CLR    C 
             MOV    A,R0
             RLC    A        ; 다음 행으로 이동
             MOV    R0,A

             CJNE   A,#10000000B,DLOOP              
RPT:         RET             ; 상위 루틴 복귀          

;***********************************************
;*     서브 루틴: KOR                          *
;*          입력: R3                           *
;*          출력: R2                           *
;*          기능: 데이터 읽어 오는 부분        *
;***********************************************
KOR:         MOV    DPTR,#FONT 
             MOV    A,R3
             MOVC   A,@A+DPTR                 
             MOV    R2,A
             INC    R3 
             RET                 
                             ; "ㄱ" 데이터
FONT:                        
DB           7EH,40H,40H,40H,40H,40H  

;************************************************
;*     서브 루틴: RSHIFT                        *
;*          입력: R2,RSHIFTNUM                  *
;*          출력: R2                            *
;*          기능: 읽어온 데이터 오른쪽으로      *    
;*                이동 횟수 만큼 이동           *
;************************************************
RSHIFT:      MOV    TEMP,RSHIFTNUM  ; 오른쪽 이동 횟수 저장
RBACK:       CLR    C
             MOV    A,R2
             RRC    A               ; 오른쪽 이동
             MOV    R2,A
             DJNZ   RSHIFTNUM,RBACK
             MOV    RSHIFTNUM,TEMP  ; 오른쪽 이동 횟수 복원
             RET

;************************************************
;*     서브 루틴: LSHIFT                        *
;*          입력: R2,LSHIFTNUM                  *
;*          출력: R2                            *
;*          기능: 읽어온 데이터 왼쪽으로        *
;*                이동 횟수 만큼 이동           *
;************************************************ 
LSHIFT:      MOV    TEMP,LSHIFTNUM  ; 왼쪽 이동 횟수 저장
LBACK:       CLR    C
             MOV    A,R2
             RLC    A               ; 왼쪽 이동
             MOV    R2,A
             DJNZ   LSHIFTNUM,LBACK
             MOV    LSHIFTNUM,TEMP  ; 왼쪽 이동 횟수 복원
             RET 

;************************************************
;*     서브 루틴: DOTCOLG                       *
;*          입력: R1,R0                         *
;*          출력: 도트 매트릭스 LED             *
;*          기능: 주어진 행과 열의 값에         *
;*                해당하는  연두색 LED 켜기     *                   
;************************************************ 
DOTCOLG:     MOV    DPTR,#COLGREEN
             MOV    A,R1
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET

;************************************************
;*     서브 루틴: DOTCOLR                       *
;*          입력: R2,R0                         *
;*          출력: 도트 매트릭스 LED             *
;*          기능: 주어진 행과 열의 값에         *
;*                해당하는  빨강색 LED 켜기     *                   
;************************************************ 
DOTCOLR:     MOV    DPTR,#COLRED
             MOV    A,R2
             MOVX   @DPTR,A

             MOV    DPTR,#ROW
             MOV    A,R0
             MOVX   @DPTR,A
             RET 

;************************************************
;*           기능: LED 가 켜져 있는             *
;*                 시간 조절                    *
;************************************************
DELAY:       MOV    R7,#01H
DELAY1:      MOV    R6,#0CFH
DELAY2:      DJNZ   R6,DELAY2
             DJNZ   R7,DELAY1
             RET 


END
                     
                


                    






                


                    





