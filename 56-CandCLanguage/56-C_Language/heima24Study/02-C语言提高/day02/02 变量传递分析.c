#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void A()
{
	int *param = malloc(4);
	B();
}

void B()
{

}


int main(){

	int a = 10;
	A();

	system("pause");
	return EXIT_SUCCESS;
}