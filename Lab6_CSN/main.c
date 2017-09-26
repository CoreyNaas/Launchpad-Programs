// Program Name:Lab6_CSN
// Function: Takes in two memory addresses and counts the number of negative numbers,
//						positive numbers, zeros stored within those addresses.
// Programmer: Corey Naas
// Date: 2017/09/23

#include <stdio.h>  // sys lib: Standard I/O
#include "uart.h"   // user lib: UART lib

extern unsigned long StrtAddr;
extern unsigned long EndAddr;
extern unsigned long NegCount;
extern unsigned long ZerCount;
extern unsigned long PosCount;

unsigned long Count_Types(void);

int main(void) {
	UART_Init();
	
	//print welcome message
	printf("\n\nWelcome to Memory Search V0.10");
	
	//run program loop
	while(1){
		//print program instructions/prompt
		printf("\n\n Enter starting address in hex: ");
		scanf("%lx", &StrtAddr);
		printf("\n Enter ending address in hex: ");
		scanf("%lx", &EndAddr);
		
		//Execute subroutine and check result
		if(Count_Types() == 1){
			printf("\n\nInvalid: First address should be less than last... Friendo");
			continue;
		}
		
		//Print Results
		printf("\n\nSEARCH RESULTS");
		printf("\n%*ld", 6, NegCount);
		printf(" Negatives");
		printf("\n%*ld", 6, ZerCount);
		printf(" Zeros");
		printf("\n%*ld", 6, PosCount);
		printf(" Positives");
	}
}

//never reference exact memory locations.
//use "%x" to scan the input as hex values.
