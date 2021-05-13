#include <stdio.h>
#include <Windows.h>

int main02(void)
{
	int a;
	int b;
	int c;
	//a = 10;
	//b = 20;
	//c = a + b;
	//»ã±à´úÂë
	__asm
	{
		mov a, 3
		mov b, 4
		mov eax, a
		add eax, b
		mov c, eax
	}
	printf("a=%d\n", a);
	printf("b=%d\n", b);
	printf("c=%d\n", c);
	getchar();
	//WinExec
	return 0;
}