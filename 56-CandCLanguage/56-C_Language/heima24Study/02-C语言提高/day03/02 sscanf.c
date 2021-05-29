#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*

sscanf函数，从字符串中读取指定格式的数据。
将参数str的字符串根据参数format字符串来转换并格式化数据。

sscanf与scanf类似，都是用于输入的，只是后者以屏幕(stdin)为输入源，前者以固定字符串为输入源。


#include <stdio.h>
int sscanf(const char *str, const char *format, ...);
-功能：
    从str指定的字符串读取数据，并根据参数format字符串来转换并格式化数据。
-参数：
	str：指定的字符串首地址
	format：字符串格式，用法和scanf()一样
-返回值：
	成功：成功则返回参数数目，失败则返回-1
	失败： - 1
*/


/*
* %*s或%*d	跳过数据
*/
void test01()
{
#if 0
	char* str = "12345abcde";
	char buf[1024] = { 0 };
	sscanf(str, "%*d%s", buf);
	printf("buf:%s\n", buf); //buf:abcde
#else
	//忽略字符串到空格或者\t
	char* str = "abcde\t12345";
	char buf[1024] = { 0 };
	sscanf(str, "%*s%s", buf);
	printf("buf:%s\n", buf); //buf:12345
#endif
}


/*
* %[width]s	读指定宽度的数据
*/
void test02()
{
	char* str = "12345abcde";
	char buf[1024] = { 0 };
	//读6个字节的数据
	sscanf(str, "%6s", buf);
	printf("buf:%s\n", buf); //buf:12345a
}


/*
* %[a-z]  匹配a到z中任意字符(尽可能多的匹配)
*/
void test03()
{
	char* str = "12345abcde";
	char buf[1024] = { 0 };
	//跳过数字，匹配a到c的字母
	sscanf(str, "%*d%[a-c]", buf); //只要匹配失败，那么就不继续匹配了
	printf("buf:%s\n", buf); //buf:abc
}


/*
* %[aBc]  匹配a、B、c中一员，贪婪性
*/
void test04()
{
	char* str = "aABbcde";
	char buf[1024] = { 0 };
	sscanf(str, "%[aAb]", buf);  //只要匹配失败，那么就不继续匹配了
	printf("buf:%s\n", buf);     //buf:aA
}


/*
* %[^a]  匹配非a的任意字符，贪婪性
*/
void test05()
{
	char* str = "aABbcde";
	char buf[1024] = { 0 };
	//匹配非c的字母
	sscanf(str, "%[^c]", buf);
	printf("buf:%s\n", buf); //buf:aABb
}


/*
* %[^a-z]  表示读取除a-z以外的所有字符
*/
void test06()
{
	char* str = "aABbcde12345";
	char buf[1024] = { 0 };
	//匹配除0-9以外的所有字符
	sscanf(str, "%[^0-9]", buf);  //只要匹配失败，那么就不继续匹配了
	printf("buf:%s\n", buf);      //buf:aABbcde
}


//练习1
void test07()
{
	char* ip = "127.0.0.1";
	int num1 = 0, num2 = 0, num3 = 0, num4 = 0;
	sscanf(ip, "%d.%d.%d.%d", &num1, &num2, &num3, &num4);

	printf("num1:%d\n", num1); //num1:127
	printf("num2:%d\n", num2); //num2:0
	printf("num3:%d\n", num3); //num3:0
	printf("num4:%d\n", num4); //num4:1
}

//练习2
void test08()
{
	char* str = "abcde#12uiop@0plju";
	char buf[1024] = { 0 };
	sscanf(str, "%*[^#]#%[^@]", buf);
	printf("buf:%s\n", buf); //buf:12uiop
}

//练习3 已给定字符串为: helloworld@itcast.cn,请编码实现helloworld输出和itcast.cn输出。
void test11()
{
	char * str = "helloworld@itcast.cn";

	char buf1[1024] = { 0 };
	char buf2[1024] = { 0 };

	sscanf(str, "%[a-z]%*[@]%s", buf1, buf2);

	printf("%s\n", buf1);
	printf("%s\n", buf2);
}

int main() {

	test01();
	printf("--------------------\n");
	test02();
	printf("--------------------\n");
	test03();
	printf("--------------------\n");
	test04();
	printf("--------------------\n");
	test05();
	printf("--------------------\n");
	test06();
	printf("--------------------\n");
	test07();
	printf("--------------------\n");
	test08();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
buf:12345
--------------------
buf : 12345a
--------------------
buf : abc
--------------------
buf : aA
--------------------
buf : aABb
--------------------
buf : aABbcde
--------------------
num1 : 127
num2 : 0
num3 : 0
num4 : 1
--------------------
buf : 12uiop
请按任意键继续. . .
*/