#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
5 ��ģ���������Ĳ���
	5.1	���ַ�ʽ
		5.1.1 ��ʾָ������
		5.1.2 ����ģ�廯
		5.1.3 ����ģ�廯
	5.2	�鿴��������
		5.2.1 cout << typeid(T).name() << endl;
*/


/*
* ��ģ��
*/
template <class NameType, class AgeType = int> //��ģ�������Ĭ�����ͣ�����Java�ķ����ࣩ
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

/*
* 1 ָ����������
*/
void doWork(Person<string ,int> & p )
{
	p.showPerson();
}

void test01()
{
	Person<string, int> p("MT",10);
	doWork(p);
}

/*
* 2 ����ģ�廯
*   ��Person�����������������ģ�廯��
*/
template<class T1 ,class T2>
void doWork2(Person<T1, T2> & p)
{
	//��β鿴���ͣ�����typeid��ӡ������
	cout << typeid(T1).name() << endl;
	cout << typeid(T2).name() << endl;
	p.showPerson();
}

void test02()
{
	Person <string, int> p("����", 18);

	doWork2(p);
}


/*
* 3 ����ģ�廯
*   ������Person���������ģ�廯��
*/
template<class T>
void doWork3(T & p)
{
	cout << typeid(T).name() << endl;
	p.showPerson();
}

void test03()
{
	Person <string, int> p("����", 18);

	doWork3(p);
}



int main(){

	test01();
	cout << "--------------------" << endl;
	test02();
	cout << "--------------------" << endl;
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/*
������MT ���䣺 10
--------------------
class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > int
���������� ���䣺 18
--------------------
class Person<class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> >,int>
���������� ���䣺 18
�밴���������. . .
*/