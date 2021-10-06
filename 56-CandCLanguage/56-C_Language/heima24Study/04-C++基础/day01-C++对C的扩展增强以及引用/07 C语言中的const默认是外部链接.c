#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(){

	extern const int a; //告诉编译器在a在外部(在test.c文件中)
	printf("a = %d \n ", a);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output
a = 10
请按任意键继续. . .
*/