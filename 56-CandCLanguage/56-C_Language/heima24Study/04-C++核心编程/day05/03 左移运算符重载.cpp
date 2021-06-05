#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
2 �������������
	2.1	��Ҫ�������÷�������
	2.2	������������ �����������������
	2.3	cout << ֱ�Ӷ�Person�Զ����������� -> �������
	2.4	д��ȫ�ֺ����� ostream & operator<< (ostream & cout, Person & p1) {}
	2.5	�������ʱ������� p1��˽�г�Ա����ôȫ�ֺ���Ҫ��Person�ġ���Ԫ������
*/


class Person
{
	/*
	* ��ȫ�ֺ�������Ϊ�ҵĺ����� ���� ��Ԫ����
	*/
	friend ostream & operator << (ostream & cout, Person & p1);

public:
	Person(){}
	Person(int a, int b)
	{
		this->m_A = a;
		this->m_B = b;
	}

	/*
	//�����������������������д����Ա������
	void operator<<()
	{

	}
	*/

private:
	int m_A;
	int m_B;
};


//�������غ���
//��һ������ cout  �ڶ�������  p1
ostream & operator<< (ostream & cout , Person & p1 )
{
	//���� p1 ��˽�г�Ա��ȫ�ֺ���Ҫ��Person�ġ���Ԫ������
	cout << "m_A = " << p1.m_A << " m_B = " << p1.m_B;

	return cout;
}


void test01()
{
	Person p1(10, 10);

	cout << p1 << "helloworld" <<endl;
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
m_A = 10 m_B = 10helloworld
�밴���������. . .
*/