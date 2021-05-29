#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*

sscanf���������ַ����ж�ȡָ����ʽ�����ݡ�
������str���ַ������ݲ���format�ַ�����ת������ʽ�����ݡ�

sscanf��scanf���ƣ�������������ģ�ֻ�Ǻ�������Ļ(stdin)Ϊ����Դ��ǰ���Թ̶��ַ���Ϊ����Դ��


#include <stdio.h>
int sscanf(const char *str, const char *format, ...);
-���ܣ�
    ��strָ�����ַ�����ȡ���ݣ������ݲ���format�ַ�����ת������ʽ�����ݡ�
-������
	str��ָ�����ַ����׵�ַ
	format���ַ�����ʽ���÷���scanf()һ��
-����ֵ��
	�ɹ����ɹ��򷵻ز�����Ŀ��ʧ���򷵻�-1
	ʧ�ܣ� - 1
*/


/*
* %*s��%*d	��������
*/
void test01()
{
#if 0
	char* str = "12345abcde";
	char buf[1024] = { 0 };
	sscanf(str, "%*d%s", buf);
	printf("buf:%s\n", buf); //buf:abcde
#else
	//�����ַ������ո����\t
	char* str = "abcde\t12345";
	char buf[1024] = { 0 };
	sscanf(str, "%*s%s", buf);
	printf("buf:%s\n", buf); //buf:12345
#endif
}


/*
* %[width]s	��ָ����ȵ�����
*/
void test02()
{
	char* str = "12345abcde";
	char buf[1024] = { 0 };
	//��6���ֽڵ�����
	sscanf(str, "%6s", buf);
	printf("buf:%s\n", buf); //buf:12345a
}


/*
* %[a-z]  ƥ��a��z�������ַ�(�����ܶ��ƥ��)
*/
void test03()
{
	char* str = "12345abcde";
	char buf[1024] = { 0 };
	//�������֣�ƥ��a��c����ĸ
	sscanf(str, "%*d%[a-c]", buf); //ֻҪƥ��ʧ�ܣ���ô�Ͳ�����ƥ����
	printf("buf:%s\n", buf); //buf:abc
}


/*
* %[aBc]  ƥ��a��B��c��һԱ��̰����
*/
void test04()
{
	char* str = "aABbcde";
	char buf[1024] = { 0 };
	sscanf(str, "%[aAb]", buf);  //ֻҪƥ��ʧ�ܣ���ô�Ͳ�����ƥ����
	printf("buf:%s\n", buf);     //buf:aA
}


/*
* %[^a]  ƥ���a�������ַ���̰����
*/
void test05()
{
	char* str = "aABbcde";
	char buf[1024] = { 0 };
	//ƥ���c����ĸ
	sscanf(str, "%[^c]", buf);
	printf("buf:%s\n", buf); //buf:aABb
}


/*
* %[^a-z]  ��ʾ��ȡ��a-z����������ַ�
*/
void test06()
{
	char* str = "aABbcde12345";
	char buf[1024] = { 0 };
	//ƥ���0-9����������ַ�
	sscanf(str, "%[^0-9]", buf);  //ֻҪƥ��ʧ�ܣ���ô�Ͳ�����ƥ����
	printf("buf:%s\n", buf);      //buf:aABbcde
}


//��ϰ1
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

//��ϰ2
void test08()
{
	char* str = "abcde#12uiop@0plju";
	char buf[1024] = { 0 };
	sscanf(str, "%*[^#]#%[^@]", buf);
	printf("buf:%s\n", buf); //buf:12uiop
}

//��ϰ3 �Ѹ����ַ���Ϊ: helloworld@itcast.cn,�����ʵ��helloworld�����itcast.cn�����
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
�밴���������. . .
*/