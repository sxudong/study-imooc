#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main01()
{

	char ch[100];
	//getchar();
	//��ȡһ���ַ� scanf()
	//char * p = gets(ch);
	scanf("%[^\n]", ch);
	//���һ���ַ��� ������
	int value = puts(ch);
	//printf("%s", ch);
	//printf("%s", p);
	char * p;
	p = ch;


	printf("%d", value); //0


	return EXIT_SUCCESS;
}