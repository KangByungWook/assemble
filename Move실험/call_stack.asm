; ���α׷� ���۹����� �˷� �ִ� ����� ���þ�
       JMP  START            ; 
; ���� ���α׷� ����

       ORG  8000H           ; ���� ��ɾ���� ��巹���� 08000H�� ����
START: MOV  SP,#40H
       ;�� �������Ϳ� Ư������ �ε��Ѵ�.
       MOV  DPTR,#1432H
       MOV  A,#041H
       MOV  B,#72H
       MOV  20H,#95H
       MOV  R0,#59H
       MOV  R1,#38H
       ; ���ÿ� �� �������Ͱ��� Ǫ��
       PUSH DPL
       PUSH DPH
       PUSH ACC
       PUSH B
       PUSH 20H
       PUSH 00H
       PUSH 01H
       ; �� ���������� ���� ����
       XCH  A,20H
       XCH  A,B
       XCH  A,DPL
       XCH  A,DPH
       XCH  A,R0
       XCH  A,R1
       ; Ǫ�� �����ʹ� �ݴ�� ����� ���� ��
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
       END                ; ���α׷� ���� �˷� �ִ� ����� ���þ�