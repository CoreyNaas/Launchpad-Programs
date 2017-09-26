; Program Name: getSmallest.s
; Function: Given the starting address and number of words to check, find
;			the smallest number stored, and return it in a register.
; Programmer: Corey Naas
; Date: 2017/09/17

;DATA AREA -----------------------------------------
		AREA   Variables, DATA, READWRITE, ALIGN=2
;RAM Data variables go here
		ALIGN 
			
		AREA   Constants, DATA, READONLY, ALIGN=2
Nums	DCD	8,4,9,3,2,8,1,3,7,6,5,7
		ALIGN   
			
;CODE AREA -------------------------------------------
		AREA    |.text|, CODE, READONLY, ALIGN=2
		EXPORT  Start
			
Start  	LDR R0, =Nums
		MOV R1, #11
		BL	findSmallest
		B	loop

;####################
;NAME:	findSmallest
;FUNC:	Finds the smallest value in a given memory block
;INPU:	The address of the first value and the number of values to check
;OUTP:	the smallest value
;REGISTER USAGE:
;R0 = address of first value, return value
;R1 = number of values, to decrement
;R2 = value to cmp to smallest
;R3 = smallest value
;********************
findSmallest
		;assume R0 and R1 already have the req'd values
		LDR R3, [R0] ;initialize R3 with first value
sLoop	
		LDR R2, [R0], #4	;Get next value
		CMP R2, R3	;compare value to current smallest
;continue unless R3 is higher than or equal to R2, then move R2 -> R3
		BHI cont	;continue if R2 is higher than R3
		BEQ cont	;continue is R2 is equal to R3
		MOV R3, R2 ;latest value is now the lowest value so far		
cont
		SUB R1, R1, #1	;decrement counter
sLoopRet
		CMP R1, #0	;compare counter to 0
;end loop if counter == 0, otherwise jmp to loop beginning
		BEQ smallestRet	;if R1 == 0, break loop and end
		B	sLoop	;if R1 > 0, continue
smallestRet
		MOV R0, R3	;move smallest value to R0
		BX	LR	;return to parent

;Code should end safely
loop   	B   loop			; Stay put

       ALIGN      
       END  
           