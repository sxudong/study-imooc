#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
10 �̳��о�̬��Ա�Ĵ���
	10.1 ���ƷǾ�̬��Ա��������
	10.2 �������ʸ����еĳ�Ա���������򼴿�
*/


class Base
{
public:
	static int m_A;

	static void func()
	{
		cout << "base fun()" << endl;
	}

	static void func(int a)
	{
		cout << "base fun(int)" << endl;
	}
};
int Base::m_A = 10;


class Son : public Base
{
public:
	static int m_A;

	static void func()
	{
		cout << "son fun()" << endl;
	}
};
int Son::m_A = 20;


/*
* ��̬��Ա���ԣ�������Լ̳�����
*/
void test01()
{
	cout << Son::m_A << endl;
	//���ʸ����m_A
	cout << Base::m_A << endl;

	Son::func();
	//���� ������ͬ���ĺ���
	Son::Base::func();
	Son::Base::func(10);
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
10
son fun()
base fun()
base fun(int)
�밴���������. . .
*/