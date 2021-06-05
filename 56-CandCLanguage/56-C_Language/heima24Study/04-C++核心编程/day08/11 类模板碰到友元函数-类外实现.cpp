#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
9 ��ģ��������Ԫ����
	9.3	��Ԫ����������ʵ�֡�
	9.4	friend void printPerson<>(Person<T1, T2> &p); //û��<> ��ͨ����; ��������<> ģ�庯������
	9.5	�ñ��������� ���� ���ҿ������Person����
*/


/*
* �ñ��������� Person�� ����
* �ñ�������ǰ���� printPerson ����
*/
template<class T1, class T2> class Person;
template<class T1, class T2> void printPerson(Person<T1, T2> & p);


/*
* ��ģ��
*/
template<class T1, class T2> //�൱�ڡ�Java�����ࡱָ����ķ��Ͳ����б�
class Person
{
	//1.��Ԫ����������ʵ�֡�������printPerson�����<>�ղ����б����߱��������ǡ�ģ�庯����������
	//2.������Ҫ�ñ��������� Person�� ���� �� printPerson ����
	friend void printPerson<>(Person<T1, T2> & p); //��ͨ���� ����

private:
	T1 m_Name;
	T2 m_Age;

public:
	Person(T1 name, T2 age){
		this->m_Name = name;
		this->m_Age = age;
	}
};

/*
* ����ʵ��
*/
template<class T1 ,class T2> //�൱�ڡ�Java���ͷ�����ָ����ķ��Ͳ����б�
void printPerson(Person<T1, T2> & p)
{
	cout << "������" << p.m_Name << "  ���䣺 " << p.m_Age << endl;
}

void test01()
{
	Person<string, int> p("Tom", 10);
	printPerson(p);
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������Tom  ���䣺 10
�밴���������. . .
*/