; 프로그램 시작번지를 알려 주는 어셈블러 지시어
       JMP  START            ; 
; 메인 프로그램 시작

       ORG  8000H           ; 다음 명령어부터 어드레스를 08000H로 설정
START: MOV  SP,#40H
       ;각 레지스터에 특정값을 로드한다.
       MOV  DPTR,#1432H
       MOV  A,#041H
       MOV  B,#72H
       MOV  20H,#95H
       MOV  R0,#59H
       MOV  R1,#38H
       ; 스택에 각 레지스터값을 푸시
       PUSH DPL
       PUSH DPH
       PUSH ACC
       PUSH B
       PUSH 20H
       PUSH 00H
       PUSH 01H
       ; 각 레지스터의 값을 변경
       XCH  A,20H
       XCH  A,B
       XCH  A,DPL
       XCH  A,DPH
       XCH  A,R0
       XCH  A,R1
       ; 푸시 순서와는 반대로 저장된 값을 팝
       POP 01H
       POP 00H
       POP 20H
       POP B
       POP ACC
       POP DPH
       POP DPL
       ;
       JMP START
       ;
       END                ; 프로그랩 끝을 알려 주는 어셈블러 지시어