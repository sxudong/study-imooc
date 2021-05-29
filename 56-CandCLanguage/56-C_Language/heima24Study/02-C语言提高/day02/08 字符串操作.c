#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


void test01()
{
	char str1[] = { 'h', 'e', 'l', 'l', 'o' };
	printf("%s\n", str1); // hello烫烫烫蘢酥韅?

	char* str2[] = { 'h', 'e', 'l', 'l', 'o' };
	printf("%s\n", str2); // h

	char* str3 = "hello";
	printf("%s\n", str3); // hello
}

/*
* 字符串拷贝功能实现一
*/
void copyString01(char* dst, const char* source)
{
	int len = strlen(source);

	for (int i = 0; i < len; ++i)
	{
		dst[i] = source[i];
	}

	dst[len] = '\0';
}

/*
* 字符串拷贝功能实现二
*/
void copyString02(char* dst, const char* source)
{
	while (*source != '\0')
	{
		*dst = *source; //指针值赋值
		++dst;
		++source;
	}

	*dst = '\0';
}

/*
* 字符串拷贝功能实现三
*/
void copyString03(char* dst, const char* source)
{
	if (NULL == dst)
	{
		return;
	}

	if (NULL == source)
	{
		return;
	}

	while (*dst++ = *source++); //跟第二种差不多，先赋值加++
}

/*
* 1. 字符串拷贝
*/
void test02()
{
	char* source = "hello world!";
	char buf[1024] = { 0 };
	//copyString01(buf, source); //hello world!
	//copyString02(buf, source); //hello world!
	copyString03(buf, source);   //hello world!
	printf("%s\n", buf);

}

void reverseString(char* str)
{
	if (NULL == str)
	{
		return;
	}

	int len = strlen(str);

//第1个字符与最后一个字符交换位置
#if 0
	int start = 0;
	int end = len - 1;
	while (start < end)
	{
		char temp = str[start];
		str[start] = str[end];
		str[end] = temp;

		++start;
		--end;
	}
#else

	char* pStart = str;
	char* pEnd = str + len - 1;

	while (pStart < pEnd)
	{
		char temp = *pStart;
		*pStart = *pEnd;
		*pEnd = temp;

		++pStart;
		--pEnd;
	}
#endif


}

/*
* 2. 字符串反转
*/
void test03()
{
	char p[] = "abc";
	reverseString(p);
	printf("p = %s\n", p); //p = cba
}

void test04()
{
	char* src = "hello world!";
	char* temp = malloc(100);
	char* p = temp;

	while (*p++ = *src++);

	printf("temp = %s\n", temp); //temp = hello world!

	free(temp);  //释放堆空间
	temp = NULL; //指向空
}


int main() {
	test01();
	printf("----------------\n");
	test02();
	printf("----------------\n");
	test03();
	printf("----------------\n");
	test04();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
hello烫烫烫蘉 ? 誤
h
hello
----------------
hello world!
----------------
p = cba
----------------
temp = hello world!
请按任意键继续. . .
*/
