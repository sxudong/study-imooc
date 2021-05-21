#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main01()
{

	char ch[100];
	//getchar();
	//获取一个字符 scanf()
	//char * p = gets(ch);
	scanf("%[^\n]", ch);
	//输出一个字符串 并换行
	int value = puts(ch);
	//printf("%s", ch);
	//printf("%s", p);
	char * p;
	p = ch;


	printf("%d", value); //0


	return EXIT_SUCCESS;
}