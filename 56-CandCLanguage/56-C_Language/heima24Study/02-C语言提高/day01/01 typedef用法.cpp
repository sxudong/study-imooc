#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
 C������#if 0 ��#end if
 ��Ԥ����ָ���Щָ����Ԥ����ʱִ�еģ�ΪԤ
 �������xxxΪ�棬����A���ٱ���B��0Ϊ�ٲ����롣
*/
#if 0
struct Person
{
	char name[64];
	int age;
};

//����Ĵ��룬���Ժϳ�Ϊһ�����д�����£�
typedef struct Person myPerson;

#endif

//����Ĵ��룬��һ��д�������£�
typedef struct Person
{
	char name[64];
	int age;
}myPerson;

void test01()
{
	myPerson p;
}


typedef char* PCHAR;

void test02()
{
	//char* p1, * p2;
	PCHAR p1, p2;

	//��ӡ��������
	cout << typeid(p1).name() << endl; //char *
	cout << typeid(p2).name() << endl; //char *
}

//�����ڳ������ֲ��
//typedef long long mytype_t;
typedef int mytype_t; //ƽ̨��֧�֣�ȫ����Ϊint����


void test03()
{
	mytype_t a;

}


int main() {

	//��ӡ��������
	test02();

	system("pause");
	return EXIT_SUCCESS;
}