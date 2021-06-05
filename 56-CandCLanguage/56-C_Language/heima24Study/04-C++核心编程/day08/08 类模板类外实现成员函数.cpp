#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>


/*
7 ��ģ��ġ�����ʵ��"��Ա����
	template < class T1, class T2>
	7.1	Person<T1, T2>::Person(T1 name, T2 age)
*/


/*
* ��ģ��
*/
template<class T1 ,class T2> //�൱�ڡ�Java�����ࡱָ����ķ��Ͳ����б�
class Person
{
public:
	T1 m_Name;
	T2 m_Age;

	Person(T1 name, T2  age); //����ʵ��
	void showPerson();        //����ʵ��
};

/*
* ������ʵ�֡���Ա������Person�๹�캯����
*/
template <class T1, class T2> //�൱�ڡ�Java���ͷ�����ָ����ķ��Ͳ����б�
Person<T1, T2>::Person(T1 name, T2 age)
{
	this->m_Name = name;
	this->m_Age = age;
}

template <class T1, class T2> //�൱�ڡ�Java���ͷ�����ָ����ķ��Ͳ�����
void Person<T1, T2>::showPerson()
{
	cout << "������" << this->m_Name << "  ���䣺  " << this->m_Age << endl;
}

void test01()
{
	Person <string ,int> p1("Mt", 100);
	p1.showPerson();
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������Mt  ���䣺  100
�밴���������. . .
*/