#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
9 �̳��е�ͬ������
	9.1	��Ա���� ֱ�ӵ����ȵ������࣬�������ø��࣬��Ҫ������
	9.2	��Ա���� ֱ�ӵ����ȵ������࣬��������а汾���ᡰ�����ء���������ʾ�������������ȥ����
*/


class Base
{
public:
	int m_A;

	Base()
	{
		m_A = 100;
	}

	void fun()
	{
		cout << "Base func����" << endl;
	}

	void fun(int a)
	{
		cout << "Base func (int a)����" << endl;
	}
};

class Son : public Base
{
public:
	int m_A;

	Son()
	{
		m_A = 200;
	}

	void fun()
	{
		cout << "Son func����" << endl;
	}
};

void test01()
{
	Son s1;
	cout << s1.m_A << endl; //200

	/*
	* ����� ������ ��m_A
	* �������򣨸������ƣ�
	*/
	cout << s1.Base::m_A << endl; //100

	s1.fun(); //Son func����

	//���ø����func
	s1.Base::fun(10); //Base func (int a)����

}


/*
* ���ۣ�
* �������͸���ӵ��ͬ���ġ��������͡����ԡ�������Ḳ�Ǹ���ĳ�Ա�𣿲��ᡣ
* ��������븸��ġ���Ա�������ơ���ͬ�������Ѹ�������е�ͬ���汾�������ء�����
* ����ø���ķ���������ӡ������򡱡�
*/
int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
200
100
Son func����
Base func (int a)����
�밴���������. . .
*/