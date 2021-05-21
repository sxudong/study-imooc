#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

typedef unsigned long long ull;

enum MyEnum
{
	a,b,c,d
}abc;
typedef enum MyEnum me;

int main01()
{
	me m;
	m = a;
	switch (abc)
	{
        case a:
            break;
        case b:
            break;
        case c:
            break;
        case d:
            break;
        default:
            break;
    }

	system("pause");
	return EXIT_SUCCESS;
}