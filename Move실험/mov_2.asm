; 프로그램 시작번지를 알려 주는 어셈블러 지시어
       JMP  START            ; 
; 메인 프로그램 시작

       ORG  8000H              ; 다음 명령어부터 어드레스를 0030H로 설정

START: MOV  DPTR,#0100H     ; DPTR 레지스터에 0100H를 저장
       MOV  A,#3             ; A 레지스터에 3을 저장
       MOVC A,@A+DPTR        ; 0103H 번지의 내용을 A 레지스터에 저장
       MOV  B,A              ; A 레지스터의 내용을 B 레지스터로 전송
      
       MOV  A,#8             ; A 레지스터에 8을 저장
       MOVC A,@A+DPTR        ; 0108H 번지의 내용을 A 레지스터에 저장
       JMP  START            ; START

; 0100H 번지부터 다음 데이터를 저장
       ORG  0100H

       DB 01H, 02H, 03H, 04H, 05H, 06H, 07H, 08H
       DB 09H, 10H, 11H, 12H, 13H, 14H, 15H, 16H

       END                   ; 프로그랩 끝을 알려 주는 어셈블러 지시어