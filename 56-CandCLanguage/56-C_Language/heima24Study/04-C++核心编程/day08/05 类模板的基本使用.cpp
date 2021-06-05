#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
4 ��ģ��
	4.1	д��template <T��> ����������
	4.2	�뺯��ģ�����𣬿�����Ĭ�����Ͳ���
	4.3	����ģ����Խ����Զ������Ƶ�������ģ�岻����
	4.4	��ģ���еĳ�Ա���� һ��ʼ���ᴴ������������������ʱ��ȥ����
*/


/*
* ��ģ��
*/
template <class NameType, class AgeType = int> //��ģ������С�Ĭ�����͡�������Java������ķ��Ͳ����б�
class Person
{
public:
	NameType m_Name;
	AgeType m_Age;

	Person(NameType name, AgeType age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}

	void showPerson()
	{
		cout << "������" << this->m_Name << " ���䣺 " << this->m_Age << endl;
	}
};


void test01()
{
	//����ģ�塱��֧�֡��Զ������Ƶ���
	//Person p("�����", 100); //err

	//��ʾָ������
	Person<string, int> p("�����", 100);
	p.showPerson();
}


class Person1
{
public:
	void showPerson1()
	{
		cout << "Person1�ĵ���" << endl;
	}
};

class Person2
{
public:
	void showPerson2()
	{
		cout << "Person2�ĵ���" << endl;
	}
};



template<class T> //ģ���ࣨ����Java�ķ����ࣩ
class myClass
{
public:
	T obj;
	void func1()
	{
		obj.showPerson1();
	}
	void func2()
	{
		obj.showPerson2();
	}
};

/*
* ���ۣ�����ģ�塱�г�Ա���� һ��ʼ���ᴴ������������������ʱ��ȥ����
*/
void test02()
{
	myClass<Person1> m;

	m.func1();

	//m.func2(); //Person1û��func2()����
}


int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
����������� ���䣺 100
----------------
Person1�ĵ���
�밴���������. . .
*/