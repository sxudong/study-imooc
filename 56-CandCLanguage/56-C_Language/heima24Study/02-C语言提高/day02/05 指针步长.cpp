#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<stddef.h> //����ƫ������ͷ�ļ�


/*
* ָ�벽����ָ�����+1 Ҫ����������ֽ�
* ָ������ͣ�����������ָ��Ĳ����������������õ�ʱ��Ӹ�����ַ��ʼȡ���ʹ�С���ֽ���
*/

//1��ָ��Ĳ������� ָ��+1֮����Ծ���ֽ���
void test01()
{
	char* p = NULL;
	printf("%d\n", p);     //0
	printf("%d\n", p + 1); //1

	printf("----------------\n");

	double* p2 = NULL;
	printf("%d\n", p2);     //0
	printf("%d\n", p2 + 1); //8

	printf("----------------\n");

}

//2�������õ�ʱ�򣬽�����ֽ�����
void test02()
{
	char buf[1024] = { 0 };
	int a = 100;

	//��a�ĵ�ַ������buf+1������sizeof���ֽ�,Ҳ���ǰ�&a������buf�����1�±괦��
	memcpy(buf + 1, &a, sizeof(int));


	char* p = buf;
	//p3�ĵ�ַ�������׵�ַ��+1 �����±������һλ����ӡ�Ľ���պ�����һ��������������100.
	printf("%d\n", *(int*)(p + 1)); //100

}

//������ϰ���Զ�������������ϰ
struct Person
{
	int a;        //  0 ~ 3
	char b;       //  4 ~ 7
	char buf[64]; //  8 ~ 71
	int d;        // 72 ~ 75
};

void test03()
{
	struct Person p = { 10, 'a', "hello world!", 100 };
	//char b;

	//�׵�ַ
	printf("�׵�ַ��ֵΪ��%d\n", *(int*)((char*)&p)); //10

	printf("----------------\n");

	// b��Ա��ƫ����
	printf("b���Ե�ƫ������%d\n", offsetof(struct Person, b)); //4
	printf("b���Ե�ֵΪ��%s\n", (char*)&p + offsetof(struct Person, b)); //a  #����Ƚ����⣬Qt������������ǡ�a��,VS������������ǡ�ahello world!��

	printf("----------------\n");

	printf("buf���Ե�ƫ������%d\n", offsetof(struct Person, buf)); //8
	printf("buf���Ե�ֵΪ��%s\n", (char*)&p + offsetof(struct Person, buf)); //hello world!

	printf("----------------\n");

	printf("d���Ե�ƫ������%d\n", offsetof(struct Person, d)); //72
	printf("d���Ե�ֵΪ��%d\n", *(int*)((char*)&p + offsetof(struct Person, d))); //100
}
/* Output:
�׵�ַ��ֵΪ��10
----------------
b���Ե�ƫ������4
b���Ե�ֵΪ��a
----------------
buf���Ե�ƫ������8
buf���Ե�ֵΪ��hello world!
----------------
d���Ե�ƫ������72
d���Ե�ֵΪ��100
*/


int main() {

	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}