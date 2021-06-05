#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
6.2	����3�ִ��ݷ�ʽ
    6.2.1 ֵ����
    6.2.2 ��ַ����
    6.2.3 ���ô���
*/


/*
* ֵ����
*/
void mySwap(int a, int b)
{
	int tmp = a;
	a = b;
	b = tmp;

	cout << "mySwap::a = " << a << endl; //mySwap::a = 20
	cout << "mySwap::b = " << b << endl; //mySwap::b = 10
}

void test01()
{
	int a = 10;
	int b = 20;
	mySwap(a, b); //ֵ����

	cout << "a = " << a << endl; //a = 10
	cout << "b = " << b << endl; //b = 20
}


/*
* ��ַ����
*/
void mySwap2(int * a, int * b)
{
	int tmp = *a;
	*a = *b;
	*b = tmp;
}


void test02()
{
	int a = 10;
	int b = 20;
	mySwap2(&a, &b);

	cout << "a = " << a << endl; //a = 20
	cout << "b = " << b << endl; //b = 10
}


/*
* ���ô��� ���ƴ���ַ
*/
void mySwap3(int &a, int &b)  //&a = a &b = b
{
	int tmp = a;
	a = b;
	b = tmp;
}


void test03()
{
	int a = 10;
	int b = 20;
	mySwap3(a, b);

	cout << "a = " << a << endl; //a = 20
	cout << "b = " << b << endl; //b = 10
}


/*
* ���õ�ע������
*   1�� ���ñ�����һ��Ϸ����ڴ�ռ�
*   2����Ҫ���ؾֲ�����������
*/
int& doWork()
{
	int a = 10; //�ֲ�����
	return a;   //���ؾֲ���������
}


void test04()
{
	//int &a = 10; //err ���ñ�����һ��Ϸ����ڴ�ռ�

	int &ret = doWork();
	cout << "ret = " << ret << endl; //10  ��һ��10�Ǳ����������Ż�
	cout << "ret = " << ret << endl; //ret = 254642568
	cout << "ret = " << ret << endl; //ret = 254642568
	cout << "ret = " << ret << endl; //ret = 254642568
	cout << "ret = " << ret << endl; //ret = 254642568
}


int& doWork2()
{
	static int a = 10; //��̬����
	return a;          //��������
}

void test05()
{

	int &ret = doWork2();
	cout << "ret = " << ret << endl; //ret = 10
	cout << "ret = " << ret << endl; //ret = 10

	/*
	* ��������ķ���ֵ�ǡ����á�����ô����������ÿ�����Ϊ����ֵ��
	*/
	doWork2() = 1000; //�൱��д�� a = 1000;
	cout << "ret = " << ret << endl;
}

int main(){

	test01();
	cout << "--------------" << endl;
	test02();
	cout << "--------------" << endl;
	test03();
	cout << "--------------" << endl;
	test04();
	cout << "--------------" << endl;
	test05();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
mySwap::a = 20
mySwap::b = 10
a = 10
b = 20
--------------
a = 20
b = 10
--------------
a = 20
b = 10
--------------
ret = 10
ret = 254642568
ret = 254642568
ret = 254642568
ret = 254642568
--------------
ret = 1000
�밴���������. . .
*/