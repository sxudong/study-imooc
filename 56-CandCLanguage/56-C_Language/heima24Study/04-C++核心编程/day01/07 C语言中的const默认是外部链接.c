#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(){

	extern const int a; //���߱�������a���ⲿ(��test.c�ļ���)
	printf("a = %d \n ", a);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output
a = 10
�밴���������. . .
*/