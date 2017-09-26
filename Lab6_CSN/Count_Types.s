; Program Name: Lab5.s
; Function: Iterates through a given block of memory and counts the number of
;			negative numbers, zero numbers, nonzero positive numbers.
; Programmer: Corey Naas, Logan Robins
; Date: 2017/09/18

;DATA AREA -----------------------------------------
		AREA   Variables, DATA, READWRITE, ALIGN=2
StrtAddr	SPACE	4
EndAddr		SPACE	4
NegCount	SPACE	4
ZerCount	SPACE	4
PosCount	SPACE	4
		ALIGN
		EXPORT	StrtAddr
		EXPORT	EndAddr
		EXPORT	NegCount
		EXPORT	ZerCount
		EXPORT	PosCount
			
;CODE AREA -------------------------------------------
		AREA    |.text|, CODE, READONLY, ALIGN=2
		EXPORT	Count_Types
           
			
Count_Types
		PUSH {R4,R5,R6,R7,R8,R9}
	;Clear results
		MOV R0, #0x0
		LDR R1,	=NegCount
		STR	R0, [R1], #4
		STR R0, [R1], #4
		STR R0, [R1]
		
	;Load starting and ending addresses
		LDR R0, =StrtAddr	;Never reference exact memory locations
		LDR R0, [R0]
		LDR R1, =EndAddr	;Never reference exact memory locations
		LDR R1, [R1]
	;Checks addrs vals:	if strt > end, jmp to zeroAll.
	;					if strt== end, jmp to runOnce
		CMP R1, R0	;end - strt
		BMI zeroAll	;jmp if end is higher than start
		B	init	;else goto init 
			
;Initialize loop
init
		MOV R4, R0
;Begin counting loop	
cLoop
		LDR R5, [R4], #4	;ld value into R5, iterate addr
		CMP	R5, #0			;do comparison
		BEQ isZero
		BGE isPositive
		BLT isNegative
		B isError
cLoopRet
		CMP R1, R4
		BEQ EndProg	;if R0 == R1, break loop and end
		BLT	EndProg
		B	cLoop	;if R0 < R1, continue
		
;Zeros all outputs if StrtAddr > EndAddr
zeroAll
		MOV R3, #0
		STR R3, [R2]
		STR R3, [R2], #4
		STR R3, [R2], #4
		MOV R0, #1	;return with 1 in R0
		B loop	;goto end
	
;####################
;NAME:	isPositive
;FUNC:	adds to isPos counter if # is nonzero positive
;INPU:	
;OUTP:	
;REGD:	
;********************
isPositive
		ADD R6, R6, #1
		B cLoopRet	;return to cloop

;####################
;NAME:	isZero
;FUNC:	adds to isZero counter if # is zero
;INPU:	
;OUTP:	
;REGD:	
;********************
isZero
		ADD R7, R7, #1
		B cLoopRet	;return to cloop

;####################
;NAME:	isNegative
;FUNC:	adds to isPos counter if # is negative
;INPU:	
;OUTP:	
;REGD:	
;********************
isNegative
		ADD R8, R8, #1
		B cLoopRet	;return to cloop

;####################
;NAME:	isError
;FUNC:	Catches errors I guess.
;INPU:	
;OUTP:	
;REGD:	
;********************
isError
		MOV R12, #0xCAFE	;obvious error message to R12*
		B loop

;Stores results of counting into RAM
EndProg
		LDR R2, =NegCount
		STR R8, [R2]
		STR R7, [R2, #4]
		STR R6, [R2, #8]
		
		
;Code should end safely
loop   	POP {R4,R5,R6,R7,R8,R9}			; Stay put
		BX LR

       ALIGN      
       END