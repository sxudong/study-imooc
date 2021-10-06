#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
 C语言中#if 0 和#end if
 是预处理指令，这些指令是预编译时执行的，为预
 编译如果xxx为真，编译A，假编译B，0为假不编译。
*/
#if 0
struct Person
{
	char name[64];
	int age;
};

//上面的代码，可以合成为一句代码写，如下：
typedef struct Person myPerson;

#endif

//上面的代码，另一种写法，如下：
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

	//打印数据类型
	cout << typeid(p1).name() << endl; //char *
	cout << typeid(p2).name() << endl; //char *
}

//有利于程序的移植性
//typedef long long mytype_t;
typedef int mytype_t; //平台不支持，全部改为int类型


void test03()
{
	mytype_t a;

}


int main() {

	//打印数据类型
	test02();

	system("pause");
	return EXIT_SUCCESS;
}