#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

class Person
{
public:
	Person()
	{
		cout << "Ĭ�Ϲ��캯������" << endl;
	}

	Person(int a)
	{
		cout << "�вι��캯������" << endl;
	}

	Person(const Person & p )
	{
		m_Age = p.m_Age;
		cout << "�������캯������" << endl;
	}

	~Person()
	{
		cout << "������������" << endl;
	}

	int m_Age;

};


/*
* ����������õ�ʱ��
*/
//1���á��Ѿ������õĶ���������ʼ���µĶ���
void test01()
{
	Person p1;     //Ĭ�Ϲ��캯������
	p1.m_Age = 10;

	Person p2(p1); //�������캯������
}


//2���ԡ�ֵ���ݡ��ķ�ʽ����������������ֵ
void doWork(Person p1) // Person p1 = Person(p) //�������캯������
{

}

void test02()
{
	Person p;     //Ĭ�Ϲ��캯������
	p.m_Age = 10;

	doWork(p);
}


//3����ֵ��ʽ���ؾֲ�����
Person doWork2()
{
	Person p1;  //Ĭ�Ϲ��캯������
	return p1;  //�������캯������
}

void test03()
{
	Person p = doWork2();
}

//test03()��Release����ģʽ�£��õı�������������Ż����Ż���ʲô����
//��Debugģʽ�»���ԭ����4�����ݡ�
/*
    Person p; ������Ĭ�Ϲ���
	doWork2(p);

	void doWork2(Person & p)
	{
		Person p1 //����Ĭ�Ϲ���
	}

	�Ż������:
	Ĭ�Ϲ��캯������
    ������������
*/


int main(){

	test01();
	cout << "-------------" << endl;
	test02();
	cout << "-------------" << endl;
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Ĭ�Ϲ��캯������
�������캯������
������������
������������
-------------
Ĭ�Ϲ��캯������
�������캯������
������������
������������
-------------
Ĭ�Ϲ��캯������
�������캯������
������������
������������
�밴���������. . .
*/