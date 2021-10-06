#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void  srting(char *p1, char *p2)
{
	if (p1 == NULL)
	{
		return;
	}
	if (p2 == NULL)
	{
		return;
	}

	while (*p1++ = *p2++);
}




void  test01()
{
	char p[] = "hello world!";
	char p1[1024] = { 0 };
	srting(p1, p);
	printf("%s\n", p1);
}
 

void arrstring(char *p1, char *p2)

{
	int len = strlen(p2);
	printf("%d\n", len);
	for (int i = 0; i < len; i++)
	{
		p1[i] = p2[i];
	}

	p1[len] = '\0';
}

void test02()
{
	char prr[] = { 'h','e','l', 'l', 'o' };//字符数组不会添加\0

	char prr2[] = "hello";//字符串，可以当做字符数组处理
	char prr1[1024] = {0};
	arrstring(prr1, prr2);
	printf("%s\n", prr1);
}


//字符串反转实现
void  rev(char *pp)
{
	int i = strlen(pp);
	char *p1 = pp;
	char *p2 = (pp + i-1);//

	while (p1 < p2)
	{
		char temp = *p1;
		*p1 = *p2;
		*p2 = temp;
		++p1;
		--p2;
	}
}
//字符串反转指针实现
void verString(char *pstr)
{
	
	int i = strlen(pstr);
	char *newstr = pstr;
	char *newstr1 = pstr+i-1;
	if (*newstr == NULL || *newstr1 == NULL)
	{
		return;
	}
	while (newstr < newstr1)
	{
		char temp = *newstr;
		*newstr = *newstr1;
		*newstr1 = temp;
		++newstr;
		--newstr1;
	}
}


void tets03()
{
	char a[] = "abc";
	char b[1024];
	memset(b, 0, 1024);
	verString(a);
	printf("%s", a);
}

int main()
{

	//test01();
	//test02();
	//char a[] = "123456789";
	//rev(a);
	//verString(pstr, char *ppstr);
	//tets03();
	//printf("%s\n", a);

	test02();
	system("pause");

}