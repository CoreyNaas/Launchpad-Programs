// Program Name: PePo
// Function: Allows peeking and poking of device memory.
// Programmer: Corey Naas
// Date:  2017/09/26

#include <stdio.h>  // sys lib: Standard I/O
#include "uart.h"   // user lib: UART lib
#include <string.h>

extern unsigned long addr;
extern unsigned long value;

unsigned long Peek(void);
unsigned long Poke(void);

int main(void) {
	char command[5];
	UART_Init();   // init uart lib if using stdio
	
// Body of program here
	printf("\nWelcome to Peek/Poke!");
	
	while(1){
		printf("\nPeek or poke? ");
		scanf("%s",command);
		
		if(strcmp(command, "peek") == 0){
			printf("\nAddress to peek: ");
			scanf("%lx", &addr);
			Peek();
			printf("\n%lX : %lX", addr, value);
			continue;
		}else if(strcmp(command, "poke") == 0){
			printf("\nAddress to poke: ");
			scanf("%lx", &addr);
			printf("\nValue to poke: ");
			scanf("%lx", &value);
			Poke();
			Peek();
			printf("\n%lX : %lX", addr, value);
			continue;
		}else{
			printf("\n error: peek or poke only.");
			continue;
		}
		
	}
}
