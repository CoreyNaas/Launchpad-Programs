; Program Name: back.s
; Function: backend assembly for PePo
; Programmer: Corey Naas
; Date:	2017/09/26

;DATA AREA -----------------------------------------
		AREA   Variables, DATA, READWRITE, ALIGN=2
addr		SPACE	4
value		SPACE	4
		ALIGN 
		EXPORT	addr
		EXPORT	value
			
;CODE AREA -------------------------------------------
		AREA    |.text|, CODE, READONLY, ALIGN=2
		EXPORT	Peek
		EXPORT	Poke

;gets the value at a given address		
Peek
		PUSH {R4,R5,R6,R7,R8,R9}
		LDR R0, =addr
		LDR	R1, =value
		LDR R0, [R0]	;load address to peek
		
		LDR R2,	[R0]		;load value at address
		STR R2, [R1]		;store value in 'value'
		
		b end
		
;loads a given value into a given address
Poke	
		PUSH {R4,R5,R6,R7,R8,R9}

		LDR R0, =addr
		LDR	R1, =value
		LDR R0, [R0]	;load address to poke
		
		LDR R2,	[R1]	;load value to poke
		STR	R2,	[R0]	;store value at address

		b end

;Code should end safely
end   	POP {R4,R5,R6,R7,R8,R9}
		BX LR

       ALIGN      
       END  
           