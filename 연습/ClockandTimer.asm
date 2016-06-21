; Author : Jae Yeong Bae
; UBC ECE
; jocker.tistory.com



;*********************************************************************************************
;** Parallel port addresses
;*********************************************************************************************

PortA	equ   	$00400000
PortB   	equ   	$00400002
PortC   	equ   	$00400004
PortD   	equ   	$00400006
PortE   	equ   	$00400008


;*********************************************************************************************
;** Hex 7 seg displays port addresses
;*********************************************************************************************

HEX_A   	equ   	$00400010
HEX_B   	equ   	$00400012
HEX_C   	equ   	$00400014
HEX_D   	equ  	$00400016

;**********************************************************************************************
;** LCD display port addresses
;**********************************************************************************************

LCDcommand	equ   	$00400020
LCDdata      	equ   	$00400022

EOT	equ   	0	define EOT to mean 0 to terminate strings



;**********************************************************************************************
T1Data	equ	$00400030
T1Ctrl	equ	$00400032

T2Data	equ	$00400034
T2Ctrl	equ	$00400036



;*********************************************************************************************
;** IRQ Table
;*********************************************************************************************
	org	 $00840064
VL1IRQ	ds.l 	1 	4 bytes at address 00840064
VL2IRQ	ds.l 	1 	4 bytes at address 00840068
VL3IRQ	ds.l 	1 	4 bytes at address 0084006C
VL4IRQ	ds.l 	1 	4 bytes at address 00840070
VL5IRQ	ds.l 	1 	4 bytes at address 00840074
VL6IRQ	ds.l 	1 	4 bytes at address 00840078
VL7IRQ	ds.l 	1 	4 bytes at address 0084007C


;****************************************************
;*	VARIABLES
;****************************************************
	ORG 	$00010000
T1_var1 	ds.b	1
T1 	ds.b	1

KeyMode	ds.b	1
KeyTimeout	ds.b	1

StopWatchMs	ds.b	1
StopWatchSec	ds.b	1
StopWatchMin	ds.b	1

StopWatchTime	ds.w	1

clkSec	ds.b	1
clkMin	ds.b	1
clkHr	ds.b	1
clkAmPm	ds.b	1
ClkMsg	ds.b	17

CalMonth	ds.b	1
CalDay	ds.b	1
CalYear	ds.w	1
CALBUFFER	ds.w	1
CalMsg	ds.b	17

timerMs	ds.b	1
timerSec	ds.b	1
timerMin	ds.b 	1


;*****************************************************************************************************
;* Program code starts here at address hex 00800000
;*****************************************************************************************************
       	ORG     	$00800000
main   	move   	#$2000,SR	enable all interrupts
	move.l	#$00880000,A7 		load our stack pointer to top of ram(stacks grow downwards)
	move.l 	#TimerISR,VL3IRQ
	move.l	#Key1ISR,VL4IRQ

	move.b	#190,T1Data	500ms interval for timer 1  = is pretty... accurate (190.7 real value)
	move.b	#0,T2Data	381 ticks = 1sec (381.4697)
	move.b	#1,KeyTimeout

	lea.l	ClkMsg,a0
	move.b	#$4d,1(a0)	Write non-changing Characters for clk msg
	move.b	#$20,2(a0)
	move.b	#$3a,5(a0)
	move.b	#$3a,8(a0)
	move.b	#$20,11(a0)
	move.b	#$20,12(a0)
	move.b	#$20,13(a0)
	move.b	#$20,14(a0)
	move.b	#$20,15(a0)
	move.b	#$0,16(a0)

	lea.l	CalMsg,a0
	move.b	#$20,(a0)	Write non-changing Characters for cal msg
	move.b	#$20,3(a0)	Write non-changing Characters for cal msg
	move.b	#$20,6(a0)
	move.b	#$20,11(a0)
	move.b	#$20,12(a0)
	move.b	#$20,13(a0)
	move.b	#$20,14(a0)
	move.b	#$20,15(a0)
	move.b	#$0,16(a0)


	move.b	#$56,ClkSec
	move.b	#$59,ClkMin
	move.b	#$11,ClkHr
	move.b	#$12,CalMonth
	move.b	#$31,CalDay
	move.w	#$2012,CalYear





	jsr	InitLCD     	jump/call a subroutine to initialise the LCD display
	move.b	#3,T1Ctrl

	jsr	WriteDay




main1

	move.b	PortA,d4
	beq	clear

	cmp.b	#%00000010,d4
	beq	setSec
	cmp.b	#%00000100,d4
	beq	setMin
	cmp.b	#%00001000,d4
	beq	setHr
	cmp.b	#%00010000,d4
	beq	setampm
	cmp.b	#%00100000,d4
	beq	setYear
	cmp.b	#%01000000,d4
	beq	setDay
	cmp.b	#%10000000,d4
	beq	setMonth

clear	bsr	Resetarrows
	bra 	main1


setSec	;bsr	Resetarrows
	lea.l	ClkMsg,a0
	move.b	#$7f,11(a0)
	jsr	writetime
	bra	main1

setMin	;bsr	Resetarrows
	lea.l	ClkMsg,a0
	move.b	#$7f,8(a0)
	jsr	writetime
	bra	main1

setHr	;bsr	Resetarrows
	lea.l	ClkMsg,a0
	move.b	#$7f,5(a0)
	jsr	writetime
	bra	main1

setampm	;bsr	Resetarrows
	lea.l	ClkMsg,a0
	move.b	#$7f,2(a0)
	jsr	writetime
	bra	main1

setYear	;bsr	Resetarrows
	lea.l	CalMsg,a0
	move.b	#$7f,11(a0)
	bsr	writeday
	bra	main1

setDay	;bsr	Resetarrows
	lea.l	CalMsg,a0
	move.b	#$7f,6(a0)
	bsr	writeday
	bra	main1

setMonth	;bsr	Resetarrows
	lea.l	CalMsg,a0
	move.b	#$7f,3(a0)
	bsr	writeday
	bra	main1


;***********************************************
Resetarrows
	lea.l	ClkMsg,a0
	move.b	#$20,2(a0)
	move.b	#$3a,5(a0)
	move.b	#$3a,8(a0)
	move.b	#$20,11(a0)

	lea.l	CalMsg,a0
	move.b	#$20,(a0)	Write non-changing Characters for cal msg
	move.b	#$20,3(a0)	Write non-changing Characters for cal msg
	move.b	#$20,6(a0)
	move.b	#$20,11(a0)

	jsr	writeday
	jsr	writetime
	rts
;*********************************************


StopWatch
	move.b 	KeyMode,d0
	beq	StartStopWatch
	cmp.b	#$1,d0
	beq	StopStopWatch

	move.b	#$0,KeyMode
	move.b 	#0,StopWatchms
	move.b 	#0,StopWatchSec
	move.b 	#0,StopWatchMin

	move.b	#1,PortB
	bra	endstopwatch

StartStopWatch	move.b	#$1,KeyMode
	move.b	#$3,T2Ctrl
	move.b	#3,PortB
	bra	endstopwatch

StopStopWatch	move.b	#$2,KeyMode
	move.b	#3,PortB
	move.b	StopWatchMs,HEX_B
	move.b 	StopWatchSec,HEX_C
	move.b 	StopWatchMin,HEX_D
	move.b	#$2,T2Ctrl

endstopwatch
	rts

;*******************************************
;*	KEY1 ISR
;*******************************************
Key1ISR
	move.b	KeyTimeout,d0
	beq	keydo
	sub.b	#1,KeyTimeout
	bra	endKeyISR

keydo	move.b	#1,d0
	move.b	d0,KeyTimeout
	move.b	PortA,d4
	beq	StopWatch

	cmp.b	#%00000010,d4
	beq	ksetSec
	cmp.b	#%00000100,d4
	beq	ksetMin
	cmp.b	#%00001000,d4
	beq	ksetHr
	cmp.b	#%00010000,d4
	beq	ksetampm
	cmp.b	#%00100000,d4
	beq	ksetYear
	cmp.b	#%01000000,d4
	beq	ksetDay
	cmp.b	#%10000000,d4
	beq	ksetMonth


ksetSec	move.b	#0,ClkSec
	bra	endKeyISR

ksetMin	move.b	ClkMin,d0
	cmp.b	#$59,d0
	beq	ksetmin0
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	bra 	ksetminmove
ksetmin0	move.b	#0,d0
ksetminmove	move.b	d0,ClkMin
	bra	endKeyISR


ksetHr	move.b	ClkHr,d0
	cmp.b	#$12,d0
	beq	ksetHr0
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	bra 	ksetHrmove
ksetHr0	move.b	#1,d0
ksetHrmove	move.b	d0,ClkHr
	bra	endKeyISR



ksetampm	move.b	Clkampm,d0
	beq	ksetam
	move.b	#0,d0
	bra	ksetmove
ksetam	move.b	#1,d0
ksetmove	move.b	d0,Clkampm
	bra	endKeyISR


ksetYear	move.b	#0,CCR
	move.w	CalYear,d0
	move.w	d0,d2
	and.w	#%0000000011111111,d0	d0 holds less sig byte
	lsr.w	#4,d2	d2 holds more sig byte
	lsr.w	#4,d2

	move.b	#0,d3
	move.b	#1,d1
	abcd.b	d1,d0	add 1 to less sig
	abcd.b	d3,d2	add 0 and carry to more sig

	lsl.w	#4,d2	put together again
	lsl.w	#4,d2
	add.w	d2,d0
	move.w	d0,CalYear
	bra	endKeyISR



ksetDay	move.b	CalDay,d0
	move.b	CalMonth,d1
	cmp.b	#$1,d1
	beq	ksthirtyonedays
	cmp.b	#$3,d1
	beq	ksthirtyonedays
	cmp.b	#$5,d1
	beq	ksthirtyonedays
	cmp.b	#$7,d1
	beq	ksthirtyonedays
	cmp.b	#$8,d1
	beq	ksthirtyonedays
	cmp.b	#$10,d1
	beq	ksthirtyonedays
	cmp.b	#$12,d1
	beq	ksthirtyonedays
	cmp.b	#$2,d1
	beq	kstwentyninedays

	cmp.b	#$30,d0
	beq	ksdayone
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalDay
	bra	endKeyISR

ksthirtyonedays
	cmp.b	#$31,d0
	beq	ksdayone
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalDay
	bra	endKeyISR

kstwentyninedays
	cmp.b	#$28,d0
	beq	ksdayone
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalDay
	bra	endKeyISR


ksdayone	move.b	#1,d0
	move.b	d0,CalDay
	bsr 	endKeyISR





ksetMonth	move.b	CalMonth,d0
	cmp.b	#$12,d0
	beq	ksetMo0
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	bra 	ksetMomove
ksetMo0	move.b	#1,d0
ksetMomove	move.b	d0,CalMonth
	bra	endKeyISR

endKeyISR	bsr	writetime
	bsr	writeday
	rts

;**************************************************
Timer2_do
	move.w 	StopWatchTime,d0
	cmp.w	#363,d0
	beq	inc_st_sec
	addi.w	#1,StopWatchTime
	bra	Timer2End

inc_st_sec	move.w	#0,StopWatchTime
	move.b 	StopWatchSec,d0
	cmp.b	#$59,d0
	beq	inc_st_min
	move.b	#0,CCR
	move.b 	#1,d1
	abcd	d1,d0
	move.b	d0,StopWatchSec
	bra	Timer2End

inc_st_min	move.b	#0,StopWatchSec
	move.b 	StopWatchMin,d0
	cmp.b	#$59,d0
	beq	inc_st_min_reset
	move.b	#0,CCR
	move.b 	#1,d1
	abcd	d1,d0
	move.b	d0,StopWatchMin
	bra	Timer2End

inc_st_min_reset
	move.b	#0,StopWatchMin






Timer2End	move.w	StopWatchTime,d0
	mulu.w	#100,d0
	divu.w	#364,d0
	jsr	BinarytoBCD
	move.b	d0,StopWatchMs

	move.b 	StopWatchMs,HEX_B
	move.b 	StopWatchSec,HEX_C
	move.b 	StopWatchMin,HEX_D

	rts

;**************************************************

BinarytoBCD

	move.b	#17,d2
	move.b 	d0,d1



bcdloop	subi.b	#1,d2
	beq	bcdone
	move.l	d1,d3
	lsr.l	#4,d3
	lsr.l	#4,d3
	lsr.l	#4,d3
	lsr.l	#4,d3
	move.l	d3,d4

	and.b	#$0F,d4
	cmp.b	#5,d4
	bhs	bcdadd3right
	bra 	skipadding1
bcdadd3right	add.b	#3,d4
skipadding1
	lsr.l	#4,d3
	cmp.b	#5,d3
	bhs	bcdadd3left
	bra	skipadding2
bcdadd3left	add.b	#3,d3
skipadding2
	lsl.l	#4,d3
	add.b	d4,d3
	lsl.l	#4,d3
	lsl.l	#4,d3
	lsl.l	#4,d3
	lsl.l	#4,d3
	and.l	#$0000FFFF,d1
	add.l	d3,d1
	lsl.l	#1,d1
	bra	bcdloop


bcdone	move.l	d1,d0
	lsr.l	#4,d0
	lsr.l	#4,d0
	lsr.l	#4,d0
	lsr.l	#4,d0
	rts

;*************************************************
;*	Clock Increments
;***************************************************
Timer1_do	move.b	T1_var1,d0
	bne	Timer1_do_do
	move.b	#1,d0
	move.b	d0,T1_var1
	bra	Timer1_end_n

Timer1_do_do	move.b	#0,d0
	move.b	d0,T1_var1

	move.b	ClkSec,d0
	cmp.b	#$59,d0
	beq	clk_inc_min
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,ClkSec
	bra	Timer1_do_end

clk_inc_min	move.b	#0,d0
	move.b	d0,ClkSec
	move.b	ClkMin,d0
	cmp.b	#$59,d0
	beq	clk_inc_Hr
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,ClkMin
	bra	Timer1_do_end

clk_inc_Hr	move.b	#0,d0
	move.b	d0,ClkMin
	move.b	ClkHr,d0
	cmp.b	#$12,d0
	beq	clk_hrtozero
	cmp.b	#$11,d0
	beq	clk_inc_AMPM
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,ClkHr
	bra	Timer1_do_end

clk_hrtozero	move.b	#1,d0
	move.b	d0,ClkHr
	bra	Timer1_do_end

clk_inc_AMPM	move.b	#$12,d0
	move.b	d0,ClkHr
	move.b	clkAmPm,d0
	beq	clk_AM
	move.b	#0,d0
	move.b	d0,clkAmPm
	bra	Timer1_do_end

clk_AM	move.b	#1,d0
	move.b	d0,clkAmPm


	move.b	CalDay,d0
	move.b	CalMonth,d1
	cmp.b	#$1,d1
	beq	thirtyonedays
	cmp.b	#$3,d1
	beq	thirtyonedays
	cmp.b	#$5,d1
	beq	thirtyonedays
	cmp.b	#$7,d1
	beq	thirtyonedays
	cmp.b	#$8,d1
	beq	thirtyonedays
	cmp.b	#$10,d1
	beq	thirtyonedays
	cmp.b	#$12,d1
	beq	thirtyonedays
	cmp.b	#$2,d1
	beq	twentyninedays

	cmp.b	#$30,d0
	beq	clk_inc_month
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalDay
	bsr	WriteDay
	bra	Timer1_do_end

thirtyonedays
	cmp.b	#$31,d0
	beq	clk_inc_month
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalDay
	bsr	WriteDay
	bra	Timer1_do_end

twentyninedays
	cmp.b	#$28,d0
	beq	clk_inc_month
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalDay
	bsr	WriteDay
	bra	Timer1_do_end




clk_inc_month
	move.b	#1,d0
	move.b	d0,CalDay
	move.b	CalMonth,d0
	cmp.b	#$12,d0
	beq	clk_inc_year
	move.b	#0,CCR
	move.b	#1,d1
	abcd.b	d1,d0
	move.b	d0,CalMonth
	bsr	WriteDay
	bra	Timer1_do_end

clk_inc_year
	move.b	#$1,d0
	move.b	d0,CalMonth
	move.b	#0,CCR
	move.w	CalYear,d0
	move.w	d0,d2
	and.w	#%0000000011111111,d0	d0 holds less sig byte
	lsr.w	#4,d2	d2 holds more sig byte
	lsr.w	#4,d2

	move.b	#0,d3
	move.b	#1,d1
	abcd.b	d1,d0	add 1 to less sig
	abcd.b	d3,d2	add 0 and carry to more sig

	lsl.w	#4,d2	put together again
	lsl.w	#4,d2
	add.w	d2,d0

	move.w	d0,CalYear
	bsr	WriteDay

Timer1_do_end	jsr	WriteTime
Timer1_end_n	rts


;*******************************
;*	WriteDay to lcd
;*************************************
WriteDay	lea.l	CalMsg,a0
	clr.l	d0
	move.b	CalMonth,d0
	cmp.b	#$1,d0
	beq	Writem_1
	cmp.b	#$2,d0
	beq	Writem_2
	cmp.b	#$3,d0
	beq	Writem_3
	cmp.b	#$4,d0
	beq	Writem_4
	cmp.b	#$5,d0
	beq	Writem_5
	cmp.b	#$6,d0
	beq	Writem_6
	cmp.b	#$7,d0
	beq	Writem_7
	cmp.b	#$8,d0
	beq	Writem_8
	cmp.b	#$9,d0
	beq	Writem_9
	cmp.b	#$10,d0
	beq	Writem_10
	cmp.b	#$11,d0
	beq	Writem_11
	cmp.b	#$12,d0
	beq	Writem_12


Writem_1	lea.l	m1,a2
	bra	writewhichday
Writem_2	lea.l	m2,a2
	bra	writewhichday
Writem_3	lea.l	m3,a2
	bra	writewhichday
Writem_4	lea.l	m4,a2
	bra	writewhichday
Writem_5	lea.l	m5,a2
	bra	writewhichday
Writem_6	lea.l	m6,a2
	bra	writewhichday
Writem_7	lea.l	m7,a2
	bra	writewhichday
Writem_8	lea.l	m8,a2
	bra	writewhichday
Writem_9	lea.l	m9,a2
	bra	writewhichday
Writem_10	lea.l	m10,a2
	bra	writewhichday
Writem_11	lea.l	m11,a2
	bra	writewhichday
Writem_12	lea.l	m12,a2


writewhichday

	move.b	(a2),(a0)
	move.b	1(a2),1(a0)
	move.b	2(a2),2(a0)


	move.b	CalDay,d0
	lsr.b	#4,d0
	add.b	#$30,d0
	move.b	d0,4(a0)
	move.b	CalDay,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,5(a0)

	move.w	CalYear,d0
	lsr.w	#4,d0
	lsr.w	#4,d0
	lsr.w	#4,d0
	add.b	#$30,d0
	move.b	d0,7(a0)
	move.w	CalYear,d0
	lsr.w	#4,d0
	lsr.w	#4,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,8(a0)
	move.w	CalYear,d0
	lsr.w	#4,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,9(a0)
	move.w	CalYear,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,10(a0)
	jsr	Oline1
	lea.l	CalMsg,a0
	jsr	OutMess

	rts

;********************************************
;*	Display Time to LCD
;*********************************************
WriteTime	lea.l	ClkMsg,a0
	move.b	ClkAmPm,d0
	beq	writeAm
	move.b	#$41,(a0)
	bra	Writemore
writeAm	move.b	#$50,(a0)
Writemore
	move.b	ClkHr,d0
	lsr.b	#4,d0
	add.b	#$30,d0
	move.b	d0,3(a0)
	move.b	ClkHr,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,4(a0)

	move.b	ClkMin,d0
	lsr.b	#4,d0
	add.b	#$30,d0
	move.b	d0,6(a0)
	move.b	ClkMin,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,7(a0)

	move.b	ClkSec,d0
	lsr.b	#4,d0
	add.b	#$30,d0
	move.b	d0,9(a0)
	move.b	ClkSec,d0
	and.b	#%00001111,d0
	add.b	#$30,d0
	move.b	d0,10(a0)

	jsr	Oline2
	lea.l	ClkMsg,a0
	jsr	OutMess

	rts

;*********************************************

TimerISR	btst	#0,T1Ctrl
	bne	TimerISR_1

	btst	#0,T2Ctrl
	bne	TimerISR_2
	bra	TimerISR_END

TimerISR_2	move.b	#3,T2Ctrl
	jsr	Timer2_do
	bra	TimerISR_END

TimerISR_1	move.b	#3,T1Ctrl
	jsr	Timer1_do
TimerISR_END	rts


;******************************************************************************
;* subroutine to move the cursor to the start of line 1 and clear that line
;* No registers are modified by the subroutine
;*******************************************************************************

Oline1	move.b  	#$80,LCDcommand	write $80 the value to the lcd command register
	jsr	Wait3ms	call subroutine to wait 3 ms to give LCD time to act on the command
	;jsr	Clearln	call subroutine to clear the current line
	;move.b	#$80,LCDcommand	write to LCD display
	;jsr	Wait3ms	wait for 3ms to give lcd chance to act
	rts		return from this soubroutine

;******************************************************************************
;* subroutine to move the cursor to the start of line 2 and clear that line
;* No registers are modified by the subroutine
;*******************************************************************************

Oline2 	move.b   	#$C0,LCDcommand	write $c0 to the lcd command register
	jsr	Wait3ms		call subroutine to wait 3 ms to give LCD time to act on the command
	;jsr	Clearln		call subroutine to clear the current line
	;move.b	#$C0,LCDcommand	write to LCD display
	;jsr	Wait3ms		wait for 3ms to give lcd chance to act
	rts                     	return from this soubroutine

;******************************************************************************
;* subroutine to clear the line by issuing 24 space characters
;* This subroutine uses (i.e. corrupts the value of) d0 and d1 so the
;* value in d0 and d1 is saved on entry to the subroutine and restored on exit so that it
;* is the same value that the calling program had in d0 and d1 when it returns
;*******************************************************************************

Clearln	movem.l 	d0-d1,-(a7)		Save value in d0/d1 onto stack for safe keeping in case caller wants it afterwards
	move.b 	#24,d0	Load d0 with a count of 24
    	move.b 	#' ',d1	Load d1 with the ASCII code for the space character
clearl1 	jsr      	Outchar
	subq.b   	#1,d0			decrement count in d0
	bne      	clearl1		loop while the value of the decrement operator did not produce the value 0
    	movem.l 	(a7)+,d0-d1		restore value in d0-d1
	rts				return from subroutine

;******************************************************************************
;* subroutine to output a single character held in d1 to the LCD display
;* it is assumed the character is an ASCII code and it will be displayed at the
;* current cursor position
;*******************************************************************************

Outchar	move.b	d1,LCDdata	write space character to the LCD data registers
	jsr	Wait1ms		delay while LCD display processes the new character
	rts

***********************************************************************************
* subroutine to output a message at the current cursor position of the LCD display
* This subroutine uses (i.e. corrupts the value of) d1 and address register a0
* so the value in d1 and a0 is saved on entry to the subroutine and restored on exit so that it
* is the same value that the calling program had in d1 and a0 when it returns
************************************************************************************

OutMess    	movem.l	d1/a0,-(a7)		save value in d1/a0 onto stack for safe keeping in case caller wants it afterwards
Outm1      	move.b	(a0)+,d1		get the character pointed to by a0 and increment a0
	cmp.b   	#EOT,d1		compare that character with EOT that marks the end of the string
       	beq	endst		if its the end of text character then stop
	jsr 	Outchar         	display character held in d1
	bra	Outm1		repeat until finished character fetched eventually equals EOT
endst      	movem.l 	(a7)+,d1/a0		restore d1/a0 from stack
	rts				return from this subroutine

************************************************************************************
* Subroutine to give the 68k something useless to do to waste 1 mSec
* This subroutine uses (i.e. corrupts the value of) d0 so the
* value in d0 is saved on entry to the subroutine and restored on exit so that it
* is the same value that the calling program had in d4 when it returns
************************************************************************************

Wait1ms   	move.l  	d0,-(a7)		Save value of Y onto stack
	move.l	#$1000,d0		Load d0 with delay value
Loop2     	sub.l   	#1,d0			decrement d0
	bne	Loop2		and branch until the result is zero
	move.l  	(a7)+,d0		restore d0
	rts                             	return from subroutine

************************************************************************************
* Subroutine to give the 68k something useless to do to waste 3 mSec
* This subroutine uses (i.e. corrupts the value of) d0 so the
* value in d0 is saved on entry to the subroutine and restored on exit so that it
* is the same value that the calling program had in d0 when it returns
**************************************************************************************

Wait3ms   	move.b    d0,-(a7)		Save the value of d0 (which is being used elsewhere in program) onto the stack
	move.b    #3,d0			load d0 with the value 3
loopcnt   	jsr	Wait1ms		call the 1ms delay subroutine 3 times
loop3     	sub.b     #1,d0			decrement d0
	bne	Loop3	and branch until the result is zero
	move.b   	(a7)+,d0		restore the pushed value of d0
	rts				return from this subroutine

*********************************************************************************************
* Subroutine to initialise the display by writing some commands to the LCD internal registers
*********************************************************************************************

InitLCD   	move.b 	#$0c,LCDcommand 	various commands see LCD data sheet
	jsr	Wait3ms
	move.b	#$38,LCDcommand
	jsr	Wait3ms
	rts		return from subroutine


*** 2 TEXT Messages for LCD display***

MSG1    	dc.b   "Altera/68k Rules"		The message we want to display on both lines of the LCD
        	dc.b   EOT				A single 'EOT' character marking the end of the text string
MSG2    	dc.b   "ECE Kicks Ass"			The message we want to display on both lines of the LCD
        	dc.b   EOT				A single 'EOT' character marking the end of the text string

m1	dc.b	"Jan"
m2	dc.b	"Feb"
m3	dc.b	"Mar"
m4	dc.b	"Apr"
m5	dc.b	"May"
m6	dc.b	"Jun"
m7	dc.b	"Jul"
m8	dc.b	"Aug"
m9	dc.b	"Sep"
m10	dc.b	"Oct"
m11	dc.b	"Nov"
m12	dc.b	"Dec"

    	END
