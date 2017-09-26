; Program Name: HW_8B
; Function: finds the average of 3 numbers passed-by-value through the stack.
; Programmer: Corey Naas
; Date: 2017/09/17

;DATA AREA -----------------------------------------
		AREA   Variables, DATA, READWRITE, ALIGN=2
;RAM Data variables go here
		ALIGN 
			
		AREA   Constants, DATA, READONLY, ALIGN=2
		ALIGN   
			
;CODE AREA -------------------------------------------
		AREA    |.text|, CODE, READONLY, ALIGN=2
		EXPORT  Start
			
Start  	MOV R0, #100
		MOV R1, #200
		MOV R2, #400
		PUSH	{R0-R2}
		BL	average
		ADD	SP,	#12
		B	loop

;####################
;NAME:	average
;FUNC:	Finds the average of 3 values in the stack
;INPU:	three elements passed-by-value through the stack
;OUTP:	The average value of 3 given values
;REGISTER USAGE:
;R0 = return value
;R1 = counter 1->3
;R2 = count up to 3
;R3 = sum of elements
;R4 = element to add	
;********************
average
		MOV R2, #3	;loop counter
		MOV R1, #0
aLoop
		POP {R4}	;load element
		ADDS R3, R3, R4	;add element to sum
		
		BLO cont	;Check for carry
		MOV R0, #0xFFFFFFFF	;return this if sum carried
		BX LR
		
cont	ADD R1, R1, #1	;increment counter
		CMP R2, R1		;check counter
		BNE aLoop		;continue, otherwise finish
		
		UDIV	R0, R3, R2	;divide sum by 3 to get average
		BX LR
		

;Code should end safely
loop   	B   loop			; Stay put

       ALIGN      
       END  
           