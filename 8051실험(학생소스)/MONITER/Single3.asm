;PROGRAMMED BY KIM HYUNG SOO
;20 번지에서 부터 17바이트를 사용자 지정
;메인 프로그램은 뱅크3 레지스터를 사용

;*****************************************************
;변수 정의
ADRES0    EQU     20H     ; 하위 주소 값을 보관
ADRES1    EQU     21H     ; 상위 주소 값을 보관
ADRESB    EQU     22H     ; 주소 버퍼

DATA      EQU     23H     ; 표시된 주소에 있는 데이터 보관
DATAB     EQU     24H     ; 데이터 버퍼     

CMD       EQU     25H     ; 명령어 보관  
MSP       EQU     26H     ; 모니터 프로그램의 SP 보관

TMP0      EQU     27H     ; 임시 변수 저장

UPCH      EQU     28H     ; 사용자 PC 상위 주소
UPCL      EQU     29H     ; 사용자 PC 하위 주소
UDPH      EQU     2AH     ; 사용자 DPH 의 주소
UDPL      EQU     2BH     ; 사용자 DPL 의 주소
UPSW      EQU     2CH     ; 사용자 PSW 의 주소
UACC      EQU     2DH     ; 사용자 ACC 의 주소
USP       EQU     2EH     ; 사용자 SP 의 주소

;****************************************************
;상수 정의
DATAOUT   EQU     0FFF0H  ; 키패드로 데이터를 내보내는 주소
DATAIN    EQU     0FFF1H  ; 키패드로 부터 데이터를 읽는 주소

DLED      EQU     0FFC1H  ; 데이터값을 표시하는 7_SEGMENT 주소
ALED0     EQU     0FFC2H  ; 하위 주소값을 표시하는 7_SEGMENT 주소
ALED1     EQU     0FFC3H  ; 상위 주소값을 표시하는 7_SEGMENT 주소  


CLKHIGH   EQU     089H    ; 시계 프로그램의 상위 시작 주소
CLKLOW    EQU     000H    ; 시계 프로그램의 하위 시작 주소

STARTSP   EQU     30H     ; SP의 시작 위치
USPSTART  EQU     70H     ; 사용자 SP의 시작 위치

;*****************************************************
;함수 키 정의

RWKEY      EQU    10H     ; [R/W] 키 ~ 외부 메모리 내용의 변경 및 확인
INCKEY     EQU    11H     ; [ ,]  키 ~ 주소 증가
ENDKEY     EQU    12H     ; [ .]  키 ~ 함수키 명령의 종료
GO         EQU    13H     ; [GO]  키 ~ 프로그램의 실행 명령
REG        EQU    14H     ; [REG] 키 ~ 내부 레지스터,메모리 변경 및 확인
DECKEY     EQU    15H     ; [INC] 키 ~ 주소 감소
CODE       EQU    16H     ; [CD]  키 ~ 프로그램 메모리 내용 확인
ST         EQU    17H     ; [ST]  키 ~ 싱글스텝 실행 명령
RST        EQU    18H     ; [RST] 키 ~ 리셋 명령

;*****************************************************
;에러 코드 정의
ERRCHK     EQU    10H     ; 에러 체크를 위한 키 값 10H
                          ; 함수 키 일 경우 10H 보다 크다
ERRCODE0   EQU    0F0H    ; 에러 코드 "F0" ~ 메인 루틴에서의 에러 표시
ERRCODE1   EQU    0F1H    ; 에러 코드 "F1" ~ R/W 에서의 에러 표시
ERRCODE2   EQU    0F2H    ; 에러 코드 "F2" ~ CD 에서의 에러 표시
ERRCODE3   EQU    0F3H    ; 에러 코드 "F3" ~ REG 에서의 에러 표시
ERRCODE4   EQU    0F4H    ; 에러 코드 "F4" ~ ST 에서의 에러 표시
ERRCODE5   EQU    0F5H    ; 에러 코드 "F5" ~ GO 에서의 에러 표시
;******************************************************

           ORG    8000H
           MOV    TMOD,#00010001B  ; GATE =0 , 타이머0 모드1 설정
           MOV    IE,#10000010B    ; 인터럽트 인에이블 타이머0         

;***************************************************
;             메인 루틴                            *
;***************************************************

START:     MOV    SP,#STARTSP   ; SP를 30H 로 이동
           MOV    UPSW,#0       ; 사용자 PSW "00" 로 초기화
           MOV    UPCH,#CLKHIGH ; 사용자 PC 상위 주소 "89H" 로 초기화
           MOV    UPCL,#CLKLOW  ; 사용자 PC 하위 주소 "00H" 로 초기화
           MOV    USP,#USPSTART ; 사용자 SP "70H" 로 초기화

           MOV    UDPH,#00H     ; 사용자 DPH "00" 로 초기화
           MOV    UDPL,#00H     ; 사용자 DPL "00" 로 초기화
           MOV    UACC,#00H     ; 사용자 ACC "00" 로 초기화

D8051:     CALL   DIS8051       ; 초기화면  8051 표시

MAIN:      CALL   SCANN         ; 키 입력 조사
           
           CJNE   A,#RWKEY,INSCHK1 ; [R/W] 키 이면
           CALL   RWINIT           ; 외부 메모리 READ , WRITE
           JMP    D8051            ; D8051로 분기. 다음 명령 대기

INSCHK1:   CJNE   A,#ST,INSCHK2    ; [ST] 키 이면
           CALL   SINGLE           ; 싱글 스텝 기능 수행
           JMP    D8051            ; D8051로 분기. 다음 명령 대기

INSCHK2:   CJNE   A,#REG,INSCHK3   ; [REG] 키 이면
           CALL   INTRAM           ; 내부 메모리 READ,WRITE
           JMP    D8051            ; D8051로 분기. 다음 명령 대기

INSCHK3:   CJNE   A,#CODE,INSCHK4  ; [CD] 키 이면
           CALL   PROGMEM          ; 프로그램 메모리 READ
           JMP    D8051            ; D8051로 분기. 다음 명령 대기

INSCHK4:   CJNE   A,#RST,INSCHK5   ; [RST] 키 이면
           SJMP   START            ; 프로그램 리셋. 변수 초기화
 
INSCHK5:   CJNE   A,#GO,ERR0       ; [GO] 키 이면
           CALL   BRK              ; 프로그램 실행 명령 수행
           JMP    D8051            ; D8051로 분기. 다음 명령 대기

ERR0:      MOV    A,#ERRCODE0      ; 키 입력이 잘못되면
                                   ; 스택을 다시 초기화하고,
                                   ; 프로그램을 다시 시작
           CALL   ERR              ; 메인 루틴에서의 에러 코드 표시


;*******************************************************
;    타이머 인터럽트 서비스 루틴                       *
;     1. 싱글 스텝(ST)              : CMD.0  = 1       *
;     2. 프로그램 실행 명령(GO)     : CMD.0  = 0       *
;     3. 프로그램 실행 명령(GO)     : RST 키 체크      *
;*******************************************************
SERVICE:   CLR    TR0               ; 타이머0 동작 정지
           ; 다음 실행 명령의 PC값을 저장
           POP    UPCH              
           POP    UPCL        
           
           JNB    CMD.0   BREAKPRO   
           ; 싱글 스텝일 경우      CMD.0 =  " 1 "            
           ; 프로그램 실행일 경우  CMD.0 =  " 0 "

           ;싱글 스텝 수행을 위한 레지스터값 보존
RETPRO:    MOV    UACC,ACC  
           MOV    UDPH,DPH
           MOV    UDPL,DPL
           MOV    UPSW,PSW
           MOV    USP,SP
           MOV    SP,MSP ; 모니터 프로그램 실행시의 SP 값으로
           SJMP   BACK   ; 싱글 스텝 종료  

BREAKPRO:  PUSH   ACC
           PUSH   DPH
           PUSH   DPL

CHKSTOP:   MOV    A,#11111110B        ;마지막 열을 체크
           MOV    DPTR,#DATAOUT
           MOVX   @DPTR,A
           
           MOV    DPTR,#DATAIN 
           MOVX   A,@DPTR
           
           CJNE   A,#11101111B,CHKBRK
           ;[RST]키 이면 프로그램 초기화

           MOV    DPTR,#START    
           PUSH   DPL                 
           PUSH   DPH                          
           SJMP   BACK       ; START로 분기

CHKBRK:    CALL   DBLEQU     ; CHECK CURRENT ADDRESS           
           JZ     RETPRO     ; IF ACC EQUAL ZERO THEN RETURN TO MAIN

           POP    DPL        ; 레지스터 값의 복원
           POP    DPH
           POP    ACC

           PUSH   UPCL                 
           PUSH   UPCH                   

           MOV    TH0,#0FFH  ; 타이머0 다시 세팅
           MOV    TL0,#0FFH   
           SETB   TR0        ; 타이머 동작 실행 

BACK:      RETI              ; 인터럽터 서비스 루틴 종료

;****************************************************************
;*         서브 루틴: RANDW    (READ AND WRITE)                 *
;*              입력: 키 패드                                   *
;*              출력: ADRES0,ADRES1,ADRESB,ALED0,ALED1          *
;*    보조 서브 루틴: SCANN,DRANDW,ADIS,AROT                    *
;*              기능: 입력 주소 표시                            *
;****************************************************************
RWINIT:    CALL   CLEAR             ; 표시 창을 끄고 버퍼의 초기화
           MOV    ADRES1,#CLKHIGH   ; 디폴트 상위 시작 주소
           MOV    ADRES0,#CLKLOW    ; 디폴트 하위 시작 주소
           CALL   ADIS              ; 시작 주소 표시

RANDW:     CALL   SCANN             ; 키 입력 체크
           
           CJNE   A,#INCKEY,WRTCHK1 ; [,] 키 입력이면
           CALL   DRANDW            ; 주소 증가, 데이터 표시


WRTCHK1:   CJNE   A,#DECKEY,WRTCHK2 ; [INC] 키 입력이면
           CALL   DRANDW            ; 주소 감소, 데이터 표시
                                    
WRTCHK2:   CJNE   A,#ENDKEY,WRTCHK3 ; [.]키 입력이면 RANDW 루틴은 종료
           RET                      ; 메인 루틴으로 복귀

WRTCHK3:   CJNE   A,#ERRCHK,WRTCHK4 ; [NUMBER]키 이면, 캐리 비트는 "1"
                                    ; [명령] 키 이면, 캐리 비트는 "0"

WRTCHK4:   JNC    ERR1
           MOV    ADRESB,A          ; 계속해서 주소 표시
           CALL   AROT              ; 주소 표시 이동 루틴 호출
           CALL   ADIS              ; 주소 표시 루틴 호출
           JMP    RANDW             ; 다음 주소가 입력될때 까지 대기   

ERR1:      MOV    A,#ERRCODE1       ; [R/W] 에러 코드 "F1" 누산기로
           CALL   ERR               ; 에러를 표시한 후 RANDW 루틴은 종료


;***************************************************************
;*         서브 루틴: DRANDW  (DATA READ AND WRITE RUTINE)     *
;*              입력: DATA,DATAB                               *
;*              출력: DLED,DATA,ALED,ADRES0,ADRES1,"** ACC **" *
;*    보조 서브 루틴: SCANN,DROT,DATADIS,INCREAS               *
;*              기능: 주소 증가와 증가된 주소의 데이터 표시    *
;***************************************************************
DRANDW:    MOV    DPL,ADRES0      ; DPL을 ADRES0에 있는 값을 지정
           MOV    DPH,ADRES1      ; DPH를 ADRES1에 있는 값을 지정
           CLR    A
           MOVC   A,@a+DPTR       
           ; 표시를 위한 주소로부터 데이터를 누산기로 이동             
           MOV    DATA,A           
           CALL   DATADIS         ; 데이터 표시 
           CALL   SCANN           ; 다음 키 입력이 있을 때 까지 대기

TEST0:     CJNE   A,#INCKEY,TEST1 ; [,]  키 이면
           CALL   DWRITE          ; 표시된 주소의 데이터 쓰기
           CALL   INCREAS         ; 주소 증가
           JMP    DRANDW          ; DRADW 루틴으로 분기
                               
TEST1:     CJNE   A,#DECKEY,TEST2 ; [INC] 키 이면
           CALL   DWRITE          ; 표시된 주소의 데이터 쓰기
           CALL   DECREAS         ; 주소 감소 
           JMP    DRANDW          ; DRADW 루틴으로 분기

TEST2:     CJNE   A,#ENDKEY,TEST3 ; [.] 키 이면
           CALL   DWRITE          ; 표시된 주소의 데이터 쓰기
           MOV    A,#ENDKEY        
           RET          
        
TEST3:     CJNE   A,#ERRCHK,TEST4 ; [NUMBER]키 이면 캐리 비트 "1"
                                  ; [명령]키 이면 캐리 비트 "0"  

TEST4:     JNC    EERR1           ; [명령]키 이면 에러 표시
           MOV    DATAB,A         ; 새로운 데이터 입력
           CALL   DROT            ; 데이터 표시 이동
           CALL   DATADIS         ; 데이터 표시

           CALL   SCANN           ; 다음 키 입력까지 대기
           JMP    TEST0           ; 키 입력이 발생하면 다시 키 명령 수행

EERR1:     MOV    A,#ERRCODE1     ; [R/W] 에러 코드 "F1" 표시
           CALL   ERR             ; 에러 표시후 종료

;**************************************************************
;*         서브 루틴: DWRITE(DATA WRITE)                      *
;*              입력: ADRES0,ADRE1,DATA                       *
;*              출력: DISPLAYED ADDRESS                       *
;*              기능: 표시된 외부 데이터 메모리 주소에        *
;*                    데이터 적기                             *
;**************************************************************
DWRITE:    MOV    DPL,ADRES0      ; DPL을 표시 하위 주소 ADRES0 지정
           MOV    DPH,ADRES1      ; DPH를 표시 상위 주소 ADRES1 지정
           MOV    A,DATA          ; 데이터 창에 있는 데이터를 누산기로
           MOVX   @DPTR,A         ; 누산기에 있는 데이터를 쓰기
           RET

;**************************************************************
;*         서브 루틴: INCREAS                                 *
;*              입력: ADRES0,ADRES1                           *
;*              출력: ADRES0,ADRES1                           *
;*    보조 서브 루틴: ADIS                                    *
;*              기능: 주소를 증가 시키고 데이터 표시          * 
;**************************************************************   
INCREAS:   MOV    A,ADRES0        ; 하위 주소를 누산기로
           INC    A               ; 하위 주소 증가
           MOV    ADRES0,A        ; 증가된 주소를 하위 주소로

           CJNE   A,#00H,INCDIS   ; 상위 주소를 증가 시켜야 할지 체크
                                  ; 하위 주소가 다 차지 않으면, 
                                  ; 증가된 주소 표시 
           MOV    A,ADRES1         
           INC    A               ; 상위 주소 증가
           MOV    ADRES1,A        ; 증가된 주소를 상위 주소로

INCDIS:    CALL   ADIS            ; 주소 표시 루틴 호출
           RET                    ; 상위 루틴으로 복귀
          
;**************************************************************
;*         서브 루틴: DECREAS                                 *
;*              입력: ADRES0,ADRES1                           *
;*              출력: ADRES0,ADRES1                           *
;*    보조 서브 루틴: ADIS                                    *
;*              기능: 주소를 감소 시키고 데이터 표시          *
;**************************************************************   
DECREAS:   MOV    A,ADRES0        ; 하위 주소를 누산기로 
           DEC    A               ; 하위 주소 감소
           MOV    ADRES0,A        ; 감소된 주소를 하위 주소로

           CJNE   A,#0FFH,DECEND  ; 상위 주소를 감소 시켜야 할지 체크
           DEC    ADRES1          ; 상위 주소 감소
                                     
DECEND:    CALL   ADIS            ; 주소 표시 루틴 호출
           RET                    ; 상위 루틴으로 복귀

;**************************************************************
;*         서브 루틴: AROT  (ADDRESS ROTATE)                  *
;*              입력: ADRESB                                  *
;*              출력: ADRES0 , ADRES1                         *
;*              기능: 주소 버퍼에 있는 주소 로테이트          *    
;**************************************************************
HIGH4      EQU    0F0H  ; 상위 주소를 얻기 위한 마스크 지정
LOW4       EQU    00FH  ; 하위 주소를 얻기 위한 마스크 지정

AROT:      MOV    A,ADRES1      ; 상위 주소를 누산기로
           ANL    A,#LOW4       ; LOW4와 마스크
           SWAP   A             
           MOV    ADRES1,A      

           MOV    A,ADRES0      ; 하위 주소를 누산기로
           ANL    A,#HIGH4      ; HIGH4와 마스크
           SWAP   A             
           ADD    A,ADRES1      
           MOV    ADRES1,A      

           MOV    A,ADRES0      ; 하위 주소를 누산기로
           ANL    A,#LOW4       ; LOW4와 마스크
           SWAP   A             
           MOV    ADRES0,A       

           MOV    A,ADRESB      ; 주소 버퍼를 누산기로
           ANL    A,#LOW4       ; LOW4와 마스크
           ADD    A,ADRES0      
           MOV    ADRES0,A      
           RET                  ; 상위 루틴으로 복귀

;*************************************************************
;*         서브 루틴: DROT  (DATA ROTATE)                    *
;*              입력: DATAB                                  *
;*              출력: DATA                                   *
;*              기능: 데이터 버퍼에 있는 데이터 로테이트     *
;*************************************************************

DROT:      MOV    A,DATA        ; 표시된 주소에 있는 데이터를 누산기로
           ANL    A,#LOW4       ; LOW4와 마스크
           SWAP   A             
           MOV    DATA,A        
           MOV    A,DATAB       ; 데이터 버퍼에 있는 데이터를 누산기로
           ANL    A,#LOW4       ; LOW4와 마스크
           ADD    A,DATA        
           MOV    DATA,A        
           RET                  ; 상위 루틴으로 복귀

;*************************************************************
;*         서브 루틴: ADIS  (ADDRESS DISPLAY)                *
;*              입력: ADRES0,ADRES1                          *
;*              출력: ALED DISPLAY                           *
;*************************************************************
ADIS:      MOV    A,ADRES0      ; 하위 주소값을 누산기로
           MOV    DPTR,#ALED0   ; DPTR을 하위 주소 표시 창 지정
           MOVX   @DPTR,A       ; 하위 주소 표시
                                   
           MOV    A,ADRES1      ; 상위 주소값을 누산기로 
           MOV    DPTR,#ALED1   ; DPTR을 상위 주소 표시 창 지정
           MOVX   @DPTR,A       ; 상위 주소 표시
           RET

;*************************************************************
;*         서브 루틴: DATADIS(DATA DISPLAY)                  *
;*              입력: DATA                                   *
;*              출력: DLED                                   *
;*              기능: 표시된 주소의 데이터 값을 표시         *
;*************************************************************
DATADIS:    MOV   A,DATA        ; 표시된 주소의 데이터를 누산기로 
            MOV   DPTR,#DLED    ; DPTR을 데이터 표시 창 지정
            MOVX  @DPTR,A       ; 데이터 표시
            RET

;*************************************************************
;*         서브 루틴: INTRAM(INTERNAL RAM)                   *
;*              입력: 키 패드                                *
;*              출력: ALED0,DLED,ADRES0,ADRESB,DATA,DATAB    *
;*    보조 서브 루틴: CLEAER,SCANN,RAMROT,ADIS,RAMWRT,ERR    *
;*              기능: 내부 메모리 읽기,쓰기                  *
;*                    - 8비트 주소 ADRES0 만 사용            * 
;*************************************************************
INTRAM:     CALL  CLEAR         ; 표시창을 끄고 버퍼의 초기화
            MOV   ADRES0,#00H   ; 디폴트 내부 메모리 주소
            CALL  ADIS          ; 시작 주소 표시

RAMWAIT:    CALL  SCANN         ; 키 입력 값을 체크

RAMCHK1:    CJNE  A,#ERRCHK,RAMCHK2 ; [숫자] 키 캐리 비트 "1"
                                    ; [명령] 키 캐리 비트 "0"
RAMCHK2:    JNC   RAMCHK3           ; [명령] 키 이면,[명령] 체크
            MOV   ADRESB,A          ; [숫자] 키 이면, 새로운 주소 입력
            CALL  RAMROT            ; 주소 표시 이동
            CALL  ADIS              ; 주소 표시
            JMP   RAMWAIT           ; RAMWAIT로 분기

RAMCHK3:    CJNE  A,#INCKEY,RAMCHK4 ; [,] 키 이면
            CALL  RAMWRT            ; RAMWRT 호출
                                     
RAMCHK4:    CJNE  A,#DECKEY,RAMCHK5 ; [INC] 키 이면 
            CALL  RAMWRT            ; RAMWRT 호출
                                    
RAMCHK5:    CJNE  A,#ENDKEY,ERR3    ; [.] 키 이면
            RET                     ; 메인으로 복귀

ERR3:       MOV   A,#ERRCODE3       ; [REG] 에러코드 "F3"
            CALL  ERR               ; 에러 코드 표시

;************************************************************
;*          서브 루틴: RAMWRT(INTERNAL RAM WRITE)           *
;*               입력: 키 패드                              *
;*               출력: ALED0,DLED,ADRES0,ADRESB,DATA,DATAB  *
;*     보조 서브 루틴: RAMROT,DROT,ADIS,DATADIS             * 
;*                     INCREAS,DECREAS                      *
;*               기능: 내부 메모리 내용 읽기,쓰기           *
;************************************************************
RAMWRT:     PUSH  PSW               
            SETB  PSW.4              ; 뱅크3 레지스터 사용   
            SETB  PSW.3             

RAMSTAT:    MOV   R0,ADRES0          ; R0에 ADRES0 값 저장
            MOV   DATA,@R0           
            CALL  DATADIS            ; 내부 메모리 데이터 표시

            CALL  SCANN              ; 키 입력값 체크

CHKRAM1:    CJNE  A,#INCKEY,CHKRAM2  ; [,]키 이면
            CALL  RAMDWRT            ; 내부 메모리 적기
            CALL  INCREAS            ; 주소 증가
            JMP   RAMSTAT            ; RAMSTAT로 분기

CHKRAM2:    CJNE  A,#DECKEY,CHKRAM3  ; [INC]키 이면 
            CALL  RAMDWRT            ; 주소 적기
            CALL  DECREAS            ; 주소 증가
            JMP   RAMSTAT            ; RAMSTART로 분기

CHKRAM3:    CJNE  A,#ENDKEY,CHKRAM4  ; [.]키 이면
            CALL  RAMDWRT            ; 내부 메모리 적기
            POP   PSW                 
            RET                      ; 상위 루틴으로 복귀

CHKRAM4:    CJNE  A,#ERRCHK,CHKRAM5  ; [명령]키 캐리 비트 "0"
                                     ; [숫자]키 캐리 비트 "1" 
CHKRAM5:    JNC   EERR3              ; [명령]키 ~ 에러 표시
            MOV   DATAB,A            ; [숫자]키 ~ 새로운 데이터 입력
            CALL  DROT               ; 데이터 표시 이동
            CALL  DATADIS            ; 데이터 표시
            CALL  SCANN              ; 키 입력값 체크
            JMP   CHKRAM1            ; 키 입력 발생시, CHKRAM1으로 분기

EERR3:      MOV   A,#ERRCODE3        ; [REG] 에러 코드 "F3"
            CALL  ERR                ; 에러 표시

;***********************************************************
;*          서브 루틴: RAMROT  (RAM ADDRESS ROTATE)        *
;*               입력: ADRESB                              *
;*               출력: ADRES0                              *
;*               기능: 주소 표시 이동                      *
;***********************************************************
RAMROT:     MOV   A,ADRES0           ; 주소값을 누산기로
            ANL   A,#LOW4            ; LOW4 마스크
            SWAP  A                  
            MOV   ADRES0,A           
            MOV   A,ADRESB           ; 주소 버퍼 값을 누산기로
            ANL   A,#LOW4            ; LOW4 마스크
            ADD   A,ADRES0           
            MOV   ADRES0,A           
            RET                      ; 상위 루틴으로 복귀

;***********************************************************
;*          서브 루틴: RAMDWRT(WRITE RAM DATA)             *
;*               입력: ADRES0,DATA                         *
;*               출력: DISPLAYED ADDRESS                   *
;*               기능: 내부 메모리 쓰기                    *
;*                     뱅크3 레지스터의 R0 가 사용         *
;***********************************************************
RAMDWRT:    MOV   R0,ADRES0          ; R0에 ADRES0 값 저장
            MOV   @R0,DATA           ; R0에 의한 간접 번지 지정
            RET                      ; 상위 루틴 복귀

;***********************************************************
;*          서브 루틴: PROGMEM (PROGRAMM MEMORY)           *
;*               입력: 키 패드                             *
;*               출력: 6개의 7_SEGMENT 표시                *     
;*     보조 서브 루틴: ROMREAD                             *
;*               기능: 프로그램 메모리의 내용 읽기         *
;***********************************************************
PROGMEM:    CALL  CLEAR              ; 표시창을 끄고 버퍼의 초기화
            MOV   ADRES0,#00H        ; 디폴트 프로그램 메모리 하위 주소
            MOV   ADRES1,#00H        ; 디폴트 프로그램 메모리 상위 주소   
            CALL  ADIS               ; 초기 주소 표시
            CALL  ROMREAD            ; 초기 주소의 데이터 읽기


ROMSTART:   CALL  SCANN              ; 키 입력 체크

ROMCHK1:    CJNE  A,#ERRCHK,ROMCHK2  ; [숫자] 키 이면 캐리 비트 "1"
                                     ; [명령] 키 이면 캐리 비트 "0"
ROMCHK2:    JNC   ROMCHK3            ; [명령] 키 이면 , [명령] 체크
            MOV   ADRESB,A           ; 주소 버퍼로 새로운 주소 입력
            CALL  AROT               ; 주소 표시 이동
            CALL  ADIS               ; 주소 표시
            CALL  ROMREAD            ; 새로운 주소의 프로그램 메모리 읽기
            JMP   ROMSTART           ; ROMSTART로 분기

ROMCHK3:    CJNE  A,#INCKEY,ROMCHK4  ; [,]키 이면
            CALL  INCREAS            ; 프로그램 메모리 주소 증가
            CALL  ROMREAD            ; 증가된 주소의 데이터 읽기,표시
            JMP   ROMSTART           ; ROMSTART로 분기

ROMCHK4:    CJNE  A,#DECKEY,ROMCHK5  ; [INC]키 이면
            CALL  DECREAS            ; 프로그램 메모리 주소 감소
            CALL  ROMREAD            ; 감소된 주소의 데이터 읽기,표시
            JMP   ROMSTART           ; ROMSTART로 분기

ROMCHK5:    CJNE  A,#ENDKEY,ERR2     ; [.]키 이면
            RET                      ; 프로그램 메모리 읽기 종료

ERR2:       MOV   A,#ERRCODE2        ; [CD] 에러 코드 "F2" 표시
            CALL  ERR                ; 에러 표시 후 종료

;**********************************************************
;*          서브 루틴: ROMREAD                            *
;*               입력: ADRES0,ADRES1                      *
;*               출력: 데이터 표시 창                     *
;*               기능: 프로그램 메모리로부터  데이터 읽기 *
;**********************************************************
ROMREAD:    MOV   DPH,ADRES1         ; 프로그램 메모리 상위 주소 지정
            MOV   DPL,ADRES0         ; 프로그램 메모리 하위 주소 지정
            MOV   A,#00H             ; 누산기를 초기화
            MOVC  A,@A+DPTR          ; 프로그램 메모리 읽기
            MOV   DATA,A             ; DATA로 프로그램 메모리 값 이동
            CALL  DATADIS            ; 프로그램 메모리 내용 표시
            RET                      ; 상위 루틴으로 복귀

;**********************************************************
;*          서브 루틴: SINGLE (SINGLE STEP)               *
;*               입력: 키 패드                            *
;*               출력: 사용자 정의 메모리 (20H -2FH)      *
;*                     주소,데이터 표시창                 *
;*     보조 서브 루틴: SCANN,AROT,DIS8051,DISUPC,EXECUTE  *
;*               기능: 싱글 스텝 동작 수행                *
;*                     사용자 PC표시                      *
;**********************************************************
SINGLE:     CALL  CLEAR              ; 표시창 끄고 , 버퍼 초기화
            CALL  DISUPC             ; 디폴트 시작 주소 표시

WAITKEY:    CALL  SCANN              ; 키 입력값 조사
                                                    
CHECK1:     CJNE  A,#ERRCHK,CHECK2   ; [명령] 키 이면 캐리 비트 "0"
                                     ; [숫자] 키 이면 캐리 비트 "1"

CHECK2:     JNC   CHECK3             ; [명령] 키 이면, 어떤 명령 키 인지 조사
            MOV   ADRESB,A           ; 싱글 스텝의 시작 주소 입력
            CALL  AROT               ; 주소 표시 이동
            MOV   UPCH,ADRES1        ; 상위 시작 주소를 UPCH로
            MOV   UPCL,ADRES0        ; 하위 시작 주소를 UPCL로
            CALL  ADIS               ; 주소 표시
            JMP   WAITKEY            ; WAITKEY로 분기

CHECK3:     CJNE  A,#ST,CHECK4       ; [ST]키 이면
            CALL  DISUPC             ; 사용자 [PC] 표시
            JMP   WAITKEY            ; WAITKEY로 분기

CHECK4:     CJNE  A,#INCKEY,CHECK5   ; [,]키 이면
            SETB  CMD.0              ; 싱글 스텝 수행 루틴임을 나타냄
            CALL  EXCUTE             ; 한 명령 수행 루틴 호출
            JMP   WAITKEY            ; WAITKEY로 분기

CHECK5:     CJNE  A,#ENDKEY,ERR4     ; [.]키 이면
            RET                      ; 메인으로 복귀

ERR4:       MOV   A,#ERRCODE4        ; [ST]에러 표시 "F4"
            CALL  ERR                ; 에러 표시

;*********************************************************
;*          서브 루틴: DISUPC                            *
;*               입력: UPCH,UPCL                         *
;*               출력: ADRES0,ADRE1,ALED0,ALED1          *
;*     보조 서브 루틴: ADIS                              *
;*               기능: [ST] 키 입력에 의해               * 
;*                     사용자 PC 표시                    *
;*********************************************************
DISUPC:     MOV   ADRES1,UPCH       ; 사용자 상위 PC의 주소
            MOV   ADRES0,UPCL       ; 사용자 하위 PC의 주소
            CALL  ADIS              ; 사용자 PC의 표시
            RET                     ; 상위 루틴을 복귀

;*********************************************************
;*          서브 루틴: EXCUTE                            *
;*               입력: UPCH,UPCL                         *
;*               출력: UPCH,UPCL                         *
;*                 ~ 한 명령이 수행된 후 증가된 PC값     *     
;*     보조 서브 루틴: READY,REVERSE,UPCINC,SPECIAL      *
;*               기능: UPC가 가리키는 한 명령을          *
;*                     수행한 후 UPC 증가                *
;*********************************************************
EXCUTE:     MOV   A,UACC            ; 싱글 스텝 실행시 필요한
            MOV   PSW,UPSW          ; 레지스터 값으로 바꿈
            MOV   DPH,UDPH          
            MOV   DPL,UDPL    

            MOV   MSP,SP            ; 현재의 SP 값을 MSP에 보존

            MOV   SP,USP            ; SP 값의 이동

            PUSH  UPCL   
            PUSH  UPCH   

	    MOV	  TH0,#0FFH         ; 타이머 세팅
	    MOV	  TL0,#0FEH         
            SETB  TR0		    ; 타이머 동작 실행
            RET                     ; JMP 명령 실행과 같은 결과 발생

;*********************************************************
;*          서브 루틴: DBLEQU                            *
;*               입력: UPCH ,UPCL, ADRES0,ADRES1         *
;*               출력: ACC 0:EQUAL 1:NOT EQUAL           *
;*               기능: 중단점 주소와                     *
;*                     다음 실행 명령 주소 비교          *
;*********************************************************
DBLEQU:     MOV   A,UPCL            ; 다음 실행 명령 하위 주소
            XRL   A,ADRES0          ; (XRL) 중단점 하위 주소
            JNZ   RETURN            ; 일치 하지 않으면 복귀

            MOV   A,UPCH            ; 다음 실행 명령 상위 주소
            XRL   A,ADRES1          ; (XRL) 중단점 상위 주소
RETURN:     RET                     ; 마지막 결과값 전달

;*********************************************************
;*          서브 루틴: BRK (BREAK POINT)                 *
;*               입력: 키 패드                           *
;*               출력: 사용자 정의 메모리 (20H -2FH)     *
;*                     주소,데이터 표시창                *
;*     보조 서브 루틴: SCANN,AROT,DIS8051,DISUPC,EXECUTE *
;*               기능: 중단점까지 프로그램 실행          *
;*********************************************************
BRK:        CALL  CLEAR    ; 표시창 끄기, 버퍼의 초기화
            CALL  DISUPC   ; 디폴트 프로그램 실행 시작 주소 표시

WAITBRK:    CALL  SCANN    ; 키 입력값 조사
                          
BRKCHK1:    CJNE  A,#ERRCHK,BRKCHK2 ; [명령]키 이면 캐리 비트 "0" 
                                    ; [숫자]키 이면 캐리 비트 "1" 

BRKCHK2:    JNC   BRKCHK3           ; [명령]키 이면 어떤 명령인지 조사
            MOV   ADRESB,A          ; [숫자]키 이면 새로운 주소 입력
            CALL  AROT              ; 주소 표시 이동
            MOV   UPCH,ADRES1       ; 상위 주소 UPCH로 지정
            MOV   UPCL,ADRES0       ; 하위 주소 UPCL로 지정
            CALL  ADIS              ; 주소 표시
            JMP   WAITBRK           ; WAITBRK로 분기

BRKCHK3:    CJNE  A,#ENDKEY,BRKCHK4 ; [.]키 이면

EXE:        CLR   CMD.0             ; 프로그램 실행 명령 루틴임을 나타냄
            CALL  EXCUTE            ; EXECUTE 루틴 호출
            SJMP  WAIT_KEY          ; WAIT_KEY 루틴으로 분기

BRKCHK4:    CJNE  A,#INCKEY,CHKBRK3 ; [,]키 이면

WAITBRK2:   CALL  SCANN             ; 키 입력값 조사

CHKBRK1:    CJNE  A,#ERRCHK,CHKBRK2 
CHKBRK2:    JNC   CHKBRK3           ; 키 입력이 [숫자] 이면
            MOV   ADRESB,A          ; 주소 입력
            CALL  AROT              ; 주소 표시 이동
            CALL  ADIS              ; 주소 표시
            JMP   WAITBRK2          ; WAITBRK2로 분기

CHKBRK3:    CJNE  A,#ENDKEY,ERR5    ; [.]키 이면
            JMP   EXE               ; EXE로 분기. 프로그램 실행

WAIT_KEY:   CALL  SCANN             ; 키 입력값 조사
            RET                     ; 상위 루틴으로 복귀

ERR5:       MOV   A,#ERRCODE5       ; 에러 코드 "F5" 
            CALL  ERR               ; 에러 코드 표시

;************************************************************
;*          서브 루틴: DIS8051(DISPLAY 8051)                *
;*               입력: 없음                                 *
;*               출력: ADRES1,ADRES0,DATA,ALED1,ALED0,DLED  *
;*     보조 서브 루틴: ADIS,DATADIS                         *
;*               기능: 80 51 00 표시                        *
;************************************************************
DIS8051:    MOV   ADRES1,#80H 
            MOV   ADRES0,#51H 
            MOV   DATA,#00H   
            CALL  ADIS       
            CALL  DATADIS    
            RET             

;************************************************************
;*          서브 루틴: CLEAR(OFF ALL LED)                   *
;*               입력: 없음                                 *
;*               출력: ADRES0,ADRES1,ADRESB,                *
;*                     DATA,DATAB,ALED0,ALED1,DLED          *
;*     보조 서브 루틴: ADIS,DATADIS                         *
;*               기능: 7_SEGMENT를 끄고                     *
;*                     주소와 데이터 버퍼를 초기화          * 
;************************************************************
CLEAR:      MOV   ADRES0,#00FFH   
            MOV   ADRES1,#00FFH   
            MOV   ADRESB,#00H     
            MOV   DATA,#00FFH     
            MOV   DATAB,#00H      
            CALL  ADIS           
            CALL  DATADIS        
            RET                 

;************************************************************
;*          서브 루틴: ERR(ERROR)                           *
;*               입력: ACC                                  *
;*               출력: SP (INITIALIZE Stack Pointer)        *
;*               기능: 에러 코드 표시 , SP의 초기화         *
;************************************************************
ERR:        PUSH  PSW          
            SETB  PSW.3          ; 뱅크3 레지스터 사용
            SETB  PSW.4
 
            MOV   TMP0,A         ; 누산기 값의 보존
          

RELOAD:     MOV   R1,#5          ; 5번 깜빡거림

ERRDIS:     CALL  DIS8051        ; 8051 표시
            MOV   DATA,TMP0      ; 에러 코드 읽기
            CALL  DATADIS        ; 에러 코드 표시
            CALL  LDELAY         ; 일정 시간 에러 표시
            CALL  CLEAR          ; 표시창 끄기
            CALL  LDELAY         ; 일정 시간 끄기
            DJNZ  R1 , ERRDIS    ; 반복 수행

            CLR   A
            CALL  SUBKEY       
          
            CJNE  A,#0FFH,RELOAD ; 키 입력이 있으면 반복
            POP   PSW            
            JMP   START          ; 에러 코드 표시후 다시 시작

;***********************************************************
;*          서브 루틴: 시간 지연                           *
;***********************************************************
LDELAY:   
            MOV   R0,#010H

LONGDEL:    CALL  DELAY
            DJNZ  R0,LONGDEL
            RET

;******************************************************************
;*          서브 루틴: SCANN (KEY SCANN RUTINE -- MOST IMPORTANT) *
;*               입력: 없음                                       *  
;*               출력: 누산기 ---  KEY_INDEX                      * 
;*     보조 서브 루틴: SUBKEY,INDEX,DELAY                         *
;*     사용 레지 스터: R0(DATA),R1(COL),R2(ROW),R6,R7(CLOCK) USED *
;******************************************************************
SCANN:      PUSH  PSW            ; PSW값을 스택에 보관
            SETB  PSW.4          ; 뱅크3 레지스터 사용
            SETB  PSW.3 

            CALL  DELAY          ; 키를 누르고 있는 동안의 시간 지연

HOLD:       MOV   A,#00H         ; 데이터 아웃으로 데이터 적기(00H)
            CALL  SUBKEY         ; 데이터 인으로 데이터 읽기
            XRL   A,#0FFH        ; 데이터 인 값 (XRL) 11111111B

HOLD1:      JNZ   HOLD           

            CALL  DELAY          ; 키를 떼고 있는 동안의 시간 지연

INITIAL:    MOV   R1,#00H        ; R1 (COL)의 초기화
            MOV   A,#11101111B   ; 최초 입력 데이터

COLSCAN:    MOV   R0,A           ; R0 : 키 스캔 입력 데이터
            INC   R1             ; R1 : 열의 값 저장
            CALL  SUBKEY         ; 키 값 스캔
            XRL   A,#0FFH        ; 데이터 아웃 (XRL) 11111111B
            JNZ   RSCAN          ; 키가 눌러 졌으면, 0이 아닌 값을 가진다.
            MOV   A,R0
            SETB  C
            RRC   A              ; 다음 열의 스캔값 지정
            JNC   INITIAL        ; 모든 열을 스캔하면, 다시 시작
            JMP   COLSCAN        ; 다음 열 스캔을 위한 분기

RSCAN:      MOV   R2,#00H        ; R2 : 행의 값 저장
ROWSCAN:    RRC   A              ; 어느 행이 눌러 졌는지 조사.
                                 ; XRL 연산 결과 눌러진 키의 행은 "1"
                                 ; RRC 연산을 통해 캐리 비트 체크 
            JC    MATRIX         ; 캐리가 발생했으면, MATRIX 로 분기 
            INC   R2             ; 캐리가 발생하지 않았으면,
                                 ; 다음 행으로 이동 
            JMP   ROWSCAN        ; ROWSCAN으로 분기 
         
MATRIX:     MOV   A,R2           ; R2 행의 값 보존
            MOV   B,#05H         ; 1행은 5개의 열로 이루어짐
            MUL   AB             ; 2차원 값은 1차원 값으로 바꿈
            ADD   A,R1           ; R1 열의 값 보존
                                 ; 누산기의 값 = R2*5 +R1
            CALL  INDEX          ; 키 코드 값을 읽어옴

BRKOUT:     POP   PSW            ; PSW값의 복원
            RET                  ; 상위 루틴으로 복귀

;*************************************************************
;*          서브 루틴: 시간 지연 루틴                        *
;*               입력: 없음                                  *
;*               출력: 없음                                  *
;*               기능: 없음(키 바운스 현상)                  *
;*************************************************************
DELAY:      MOV   R7,#020H      

DELAY1:     MOV   R6,#0FF0H     
DELAY2:     DJNZ  R6,DELAY2    
            DJNZ  R7,DELAY1    
            RET

;*************************************************************
;*          서브 루틴: SUBKEY                                *
;*               입력: ACC                                   *
;*               출력: ACC                                   *
;*               기능: 데이터 아웃으로 데이터를 적은 후      *
;*                     데이터 인으로 데이터를 읽어 들임      *
;*************************************************************
SUBKEY:     MOV   DPTR,#DATAOUT
            MOVX  @DPTR,A
            MOV   DPTR,#DATAIN
            MOVX  A,@DPTR
            RET

;**************************************************************
;*          서브 루틴: INDEX                                  *
;*               입력: ACC                                    *
;*               출력: ACC                                    *
;*               기능: 정의된 키 코드 값을 읽어 오기          *
;**************************************************************
INDEX:      MOVC  A,@A+PC    ; 1~24 까지의 값을 가짐 
            RET
KEYBASE:    DB    ST         ;SW1,ST             1
            DB    DECKEY     ;SW6,INC            2
            DB    CODE       ;SW11,CODE          3
            DB    REG        ;SW15,REG           4
            DB    GO         ;SW19,GO            5
            DB    0CH        ;SW2,C              6
            DB    0DH        ;SW7,D              7
            DB    0EH        ;SW12,E             8
            DB    0FH        ;SW16,F             9
            DB    INCKEY     ;SW20,COMMA (,)    10
            DB    08H        ;SW3,8             11
            DB    09H        ;SW8,9             12
            DB    0AH        ;SW13,A            13
            DB    0BH        ;SW17,B            14
            DB    ENDKEY     ;SW21,PERIOD(.)    15
            DB    04H        ;SW4,4             16
            DB    05H        ;SW9,5             17
            DB    06H        ;SW14,6            18
            DB    07H        ;SW18,7            19
            DB    RWKEY      ;SW22,R/W          20
            DB    00H        ;SW5,0             21
            DB    01H        ;SW10,1            22
            DB    02H        ;SW24,2            23
            DB    03H        ;SW23,3            24
            DB    RST        ;SW24  RST KEY     25

;*************************************************************
;*         8900 번지에 로드될 시계 프로그램                  *
;*************************************************************
           ORG    8900H
LEDHOU     EQU    0FFC3H       ; 시(HOUR) 표시 창의 주소
LEDMIN     EQU    0FFC2H       ; 분(MIN)  표시 창의 주소
LEDSEC     EQU    0FFC1H       ; 초(SEC)  표시 창의 주소
                
           LCALL  ALLCLEAR     ; 초기화
                        
CLOCK:     MOV    R0,#2
           DJNZ   R0, $
               
CONDITON:  CJNE   R5,#59H,SEC  ; "초" 단위 비교
                                     
           CJNE   R6,#59H,MIN  ; "분" 단위 비교

           CJNE   R7,#23H,HOUR ; "초" 단위 비교
                                       
           ACALL  ALLCLEAR     ; 다시 초기화
           LJMP   CLOCK        ; 다시 시작
                          
SEC:       MOV    A,R5    
           ADD    A,#1H        ; "초" 단위 증가 
           DA     A            ; 십진수 표현 
           MOV    R5,A    
           ACALL  DISSEC  
           SJMP   CLOCK   
                                
MIN:       MOV    A,R6               
           ADD    A,#1H        ; "분" 단위 증가      
           DA     A            ; 십진수 표현                 
           MOV    R6,A
           LCALL  CLRSEC       ; 초(SEC) 초기화
           LCALL  DISMIN       ; 분(MIN) 표시 루틴 호출
           MOV    A,#00H
           LCALL  DISSEC       ; 초(SEC) 표시 루틴 호출
           LJMP   CLOCK        ; CLOCK 으로 분기
                                 
HOUR:      MOV    A,R7
           ADD    A,#1H
           DA     A
           MOV    R7,A
           LCALL  CLRMIN
           LCALL  DISHOU
           MOV    A,#00H
           LCALL  DISMIN
           LCALL  DISSEC
           LJMP   CLOCK
      
ALLCLEAR:  LCALL  CLRHOU       ; 시,분,초 초기화
           MOV    A,#00H       ; 각각의 표시 창 호출
           LCALL  DISHOU
           LCALL  DISMIN
           LCALL  DISSEC
           RET
                                
CLRHOU:    MOV    R7,#0H       ; 시 변수 초기화
CLRMIN:    MOV    R6,#0H       ; 분 변수 초기화
CLRSEC:    MOV    R5,#0H       ; 초 변수 초기화
           RET
                                
DISHOU:    MOV    DPTR,#LEDHOU ; 시 표시 루틴
           MOVX   @DPTR,A      
           RET                 
                               
DISMIN:    MOV    DPTR,#LEDMIN ; 분 표시 루틴
           MOVX   @DPTR,A
           RET

DISSEC:    MOV    DPTR,#LEDSEC ; 초 표시 루틴
           MOVX   @DPTR,A
           RET

           ORG    9F0BH  
           ; 인터럽트 서비스 루틴의 시작 주소 
           JMP    SERVICE 

END
