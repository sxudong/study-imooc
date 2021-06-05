#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
9 ��ģ��������Ԫ����
	9.1	��Ԫ����������ʵ�֡�
	9.2	friend void printPerson(Person<T1, T2> &p)
*/


/*
* ��ģ��
*/
template<class T1 ,class T2>  //�൱�ڡ�Java�����ࡱָ����ķ��Ͳ����б�
class Person
{
	/*
	* ��Ԫ��������ʵ�֣�Ĭ����ȫ�ֺ�����
	*/
	friend void printPerson( Person<T1 ,T2> & p ){
		cout << "������" << p.m_Name << "  ���䣺 " << p.m_Age << endl;
	}

private:
	T1 m_Name;
	T2 m_Age;

public:
	Person(T1 name, T2 age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}

	//void printPerson() {
	//	cout << "������" << this->m_Name << "  ���䣺 " << this->m_Age << endl;
	//}
};

void test01()
{
	Person<string, int> p("Tom", 10);
	//p.printPerson();
	printPerson(p); //ȫ�ֺ���ֱ�ӷ�����������������
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