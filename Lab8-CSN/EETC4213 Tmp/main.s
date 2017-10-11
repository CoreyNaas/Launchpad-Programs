;####################
; Program Name: Two-way Traffic Light
; Function:		Implementation of a FSM in ARM Assembly for the TI Launchpad.
; Programmer:	Corey Naas
; Date:			2017/10/09
;********************

	INCLUDE tm4c123gh6pm.s

ER_NR	EQU	0x24
ER_NG	EQU	0x21
ER_NY	EQU	0x22
EG_NR	EQU	0x0C
EY_NR	EQU	0x14
	
SW1 EQU	0x40024004
SW2 EQU	0x40024008

;CODE AREA -------------------------------------------
		AREA    |.text|, CODE, READONLY, ALIGN=2
		EXPORT  Start
			
Start  	BL init

Cycle
	;R9 holds the LED sequence. Move sequence into R9, then go 
	;	into switch subroutine. 
	
	;East Red, North Red 	100100
		MOV R9, #ER_NR
		BL	switch
	;East Red, North Green	100001
		MOV R9, #ER_NG
		BL	switch
	;East Red, North Yellow	100010
		MOV R9, #ER_NY
		BL	switch
	;East Red, North Red	100100
		MOV R9, #ER_NR
		BL	switch
	;East Green, North Red	001100
		MOV R9, #EG_NR
		BL	switch
	;East Yellow, North Red	010100
		MOV R9, #EY_NR
		BL	switch
		
		B Cycle

;####################
;NAME:	delay
;FUNC:	delays for 10ms
;INPU:	
;OUTP:	
;REGD:	R2
;********************
DLENGTH		EQU	444444
delaySt
		LDR	R2,	=DLENGTH
delay
		SUBS	R2,	R2, #1
		BNE	delay
		BX LR
		
;####################
;NAME:	SwitchPressed
;FUNC:	Advances LED sequence if SW1 is pressed; checks for blink state
;INPU:	R9 = LED sequence
;OUTP:	
;REGD:	R0, R1
;********************
	;switch subroutine will:
	;1. delay for debounce
	;2. switch leds to new sequence
	;3. switch is pressed to go to next sequence, or
	;4. goto blink subroutine to check for blink
	;5. when switch is pressed again,
	;		delay, then
	;		exit suboutine back to main
switch	
	;Load new LED sequence
		LDR	R1,	=GPIO_PORTB_DATA_R
		STR R9, [R1]
swrel		
		LDR R1, =SW1
		LDR R0, [R1]
		CMP R0, #0x01	;Is SW1 pressed?
		BEQ swrel		;if yes, loop back to switch
		
swlp		
		LDR R1, =SW1
		LDR R0, [R1]
		CMP R0, #0x01	;Is SW1 pressed?
		BNE swcont		;if not, continue to blink
	
	;delay for debounce	
		PUSH{LR}
		BL	delaySt		
		POP{LR}
		BX LR			;exit back to main
swcont
	;if sw1 isn't pressed, check for blinking
		PUSH{LR}
		BL blink		
		POP{LR}
	
		B	swlp		;then, keep looping

;####################
;NAME:	Blink
;FUNC:	Nixes LEDs if SW2 is pressed until SW2 is released
;INPU:	
;OUTP:	
;REGD:	R0, R1
;********************
blink
		LDR R1, =SW2
		LDR R0, [R1]
		CMP R0, #0x02		;is SW2 pressed?
		BNE back			;if not, return to switch
	
	;delay for debounce	
		PUSH{LR}
		BL	delaySt			
		POP{LR}
		
	;turn all leds off	
		LDR	R1,	=GPIO_PORTB_DATA_R
		MOV R0, #0x00		
		STR R0, [R1]
		
		B	blink			;loop until SW2 is released
back	
		PUSH{LR}
		BL	delaySt			
		POP{LR}
		
		LDR R1, =SW2
		LDR R0, [R1]
		CMP R0, #0x02		;is SW2 pressed?
		BEQ blink			;if yes, return to back
		
		LDR	R1,	=GPIO_PORTB_DATA_R		
		STR R9, [R1]		;turn all leds back on
		BX LR

;####################
;NAME:	Initialize
;FUNC:	Initializes Port E and Port B
;INPU:	
;OUTP:	
;REGD:	R0, R1
;********************
init
	;Activate clock
		LDR R1, =SYSCTL_RCGC2_R
		LDR R0, [R1]
		ORR	R0, R0, #0x12
		STR	R0, [R1]
		NOP
		NOP
		
	;Initialize Port E for INPUT
		LDR	R1,	=GPIO_PORTE_CR_R	;enable commit for port E
		MOV	R0,	#0x05
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTE_AMSEL_R	;disable analog func.
		MOV	R0,	#0
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTE_PCTL_R	;Configure as GPIO
		MOV	R0,	#0x0000000
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTE_DIR_R	;Set direction register
		MOV	R0,	#0x00
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTE_AFSEL_R	;disable alternate func.
		MOV	R0,	#00
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTE_PUR_R	;enable pull-up resistors for 
		MOV	R0,	#0x00
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTE_DEN_R	;Enable port E digital port
		MOV	R0,	#0xFF
		STR	R0,	[R1]
	
	;Initialize Port B for OUTPUT
		LDR	R1,	=GPIO_PORTB_CR_R	;enable commit for port B
		MOV	R0,	#0xFF
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTB_AMSEL_R	;disable analog func.
		MOV	R0,	#0
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTB_PCTL_R	;Configure as GPIO
		MOV	R0,	#0x0000000
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTB_DIR_R	;Set direction register
		MOV	R0,	#0x3F
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTB_AFSEL_R	;disable alternate func.
		MOV	R0,	#0
		STR	R0,	[R1]
		LDR	R1,	=GPIO_PORTB_DEN_R	;Enable port B digital port
		MOV	R0,	#0xFF
		STR	R0,	[R1]
		
		BX LR
		
       ALIGN      
       END  
           