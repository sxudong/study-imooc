#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
1 ��ϵ���������
	1.1	�Զ����������� �����ڲ��� �Ƚ� == �� =
	1.2	����Ҫ���� == �� =
*/


/*
*  == ��ϵ���������
*/
class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}

	bool operator== ( Person & p){
		//�Ƚ϶�������ֺ�����
		if (this->m_Name == p.m_Name && this->m_Age == p.m_Age)
			return true;

		return false;
	}

	bool operator!= ( Person & p){
		//�Ƚ϶�������ֺ�����
		if (this->m_Name == p.m_Name && this->m_Age == p.m_Age)
			return false;

		return true;
	}
};

void test01()
{
	Person p1("С��", 10);
	Person p2("Сǿ", 15);
	Person p3("Сǿ", 15);

	//ϵͳ�Դ���==��ϵ�����
	//int a = 10;
	//int b = 10;
	//if (a == b ){
	//	cout << "a b���" << endl;
	//}

	//�����Զ��� == ���غ���
	if ( p1 == p2)
		cout << "p1 �� p2 ���" << endl;
	else
		cout << "p1 �� p2 �����" << endl;

	if (p2 == p3)
		cout << "p2 �� p3 ���" << endl;
	else
		cout << "p2 �� p3 �����" << endl;

	//�����Զ��� != ���غ���
	if (p1 != p2)
		cout << "p1 �� p2 �����" << endl;
	else
		cout << "p1 �� p2 ���" << endl;
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1 �� p2 �����
p2 �� p3 ���
p1 �� p2 �����
�밴���������. . .
*/