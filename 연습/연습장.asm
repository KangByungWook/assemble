	ORG 00H
	MOV A, #00H
	MOV DPTR, #00H
	JMP START

	ORG 08H
START: 
	ADD A, #1
	JMP START

ABC: DB '1'
