#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
8 �̳��еĹ��������˳��
	8.1	���ഴ������ʱ���ȵ��ø���Ĺ��죬Ȼ�����������
	8.2	����˳���빹��˳���෴
	8.3	�����ǲ���̳и���Ĺ��캯������������
	8.4	�������ݣ����������û�к���Ĭ�Ϲ��죬��ô����������ó�ʼ���б�ķ�ʽ
*/


class Base
{
public:
	int m_A;

	Base()
	{
		m_A = 10;
		cout << "BaseĬ�Ϲ��캯������" << endl;
	}

	~Base()
	{
		cout << "Base��������������" << endl;
	}
};


/*
* �����ࡱ��̳С����ࡱ�ĳ�Ա���ԣ���Ա������
* ���ǡ����ࡱ����̳С����ࡱ���캯�� �� ����������
* ֻ�и����Լ�֪���������������Լ������ԣ������಻֪����
*/
class Son : public Base
{
public:
	Son()
	{
		cout << "SonĬ�Ϲ��캯������" << endl;
	}

	~Son()
	{
		cout << "Son��������������" << endl;
	}
};

void test01()
{
	//Base b1;
	Son s1;
}
/* Output:
BaseĬ�Ϲ��캯������
SonĬ�Ϲ��캯������
Son��������������
Base��������������
*/


class Base2
{
public:
	int m_A;

	Base2(int a)
	{
		this->m_A = a;
		cout << "Base2�вι��캯������ "<< this->m_A << endl;
	}
};

class Son2 : public Base2
{
public:
	/*
	* ���á���ʼ���б�ʽ����ʾ���� �вι���
	* ����Java��Super()���ø��๹��
	*/
	Son2(int a ) : Base2(a)
	{
		cout << "Son2�вι��캯������ "<< this->m_A << endl;
	}
};

void test02()
{
	Son2 s2(1000);
}
/* Output:
Base2�вι��캯������ 1000
Son2�вι��캯������ 1000
*/

int main(){

	//test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}