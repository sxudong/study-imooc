#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
11 ��̳еĸ����Լ�����
	11.1 class A : public B1, public B2, ��.
	11.2 ��������������
	11.3 �������������⣬����Ҫͨ������������������
*/


class Base1
{
public:
	int m_A;

	Base1()
	{
		m_A = 10;
	}
};


class Base2
{
public:
	int m_A;

	Base2()
	{
		m_A = 20;
	}
};


/*
* ��̳�
*/
class Son : public Base1, public Base2
{
public:
	int m_C;
	int m_D;
};


/*
* ��̳��к����������������ԡ�
*/
void test01()
{
	cout << sizeof(Son) << endl; //16

	Son s1;
	//s1.m_A; //err ������

	//���ڡ������ԡ���ô�죿��ʾ�ļӡ�����������
	cout << s1.Base1::m_A << endl; //10
	cout << s1.Base2::m_A << endl; //20
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
16
10
20
�밴���������. . .
*/