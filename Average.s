; Program Name: HW_8A
; Function: finds the average of 10 numbers passed by reference.
; Programmer: Corey Naas
; Date: 2017/09/17

;DATA AREA -----------------------------------------
		AREA   Variables, DATA, READWRITE, ALIGN=2
;RAM Data variables go here
		ALIGN 
			
		AREA   Constants, DATA, READONLY, ALIGN=2
mydata	DCD 1,2,3,4,5,6,7,8,14,0
		ALIGN   
			
;CODE AREA -------------------------------------------
		AREA    |.text|, CODE, READONLY, ALIGN=2
		EXPORT  Start
			
Start  	LDR R0, =mydata
		BL	average
		B	loop

;####################
;NAME:	average
;FUNC:	Finds the average of 10 values in a given array
;INPU:	The address of the first element in a 10-element array
;OUTP:	The average value of 10 given values
;REGISTER USAGE:
;R0 = array address, return value
;R1 = counter 1->10
;R2 = count up to 10
;R3 = sum of elements
;R4 = element to add	
;********************
average
		MOV R2, #10	;loop counter
		MOV R1, #0
aLoop
		LDR R4, [R0], #4;load element
		ADDS R3, R3, R4	;add element to sum
		
		BLO cont	;Check for carry
		MOV R0, #0xFFFFFFFF	;return this if sum carried
		BX LR
		
cont	ADD R1, R1, #1	;increment counter
		CMP R2, R1		;check counter
		BNE aLoop		;continue, otherwise finish
		
		UDIV	R0, R3, R2	;divide sum by 10 to get average
		BX LR
		

;Code should end safely
loop   	B   loop			; Stay put

       ALIGN      
       END  
           