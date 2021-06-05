#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
* 1��const�����ڴ� ȡ��ַ����䡰��ʱ�ڴ桱
* 2��extern ������Ҳ���const�������䡰�ڴ桱
*/
void test01()
{
	const int m_A = 10;
	int * p = (int*) &m_A; //����䡰��ʱ�ڴ桱

	*p = 1000;

	//�����޸�
	cout << "m_A = " << m_A << endl; //10
}

/*
* 3���á���ͨ��������ʼ�� const �ı���
*/
void test02()
{
	int a = 10; //��ͨ����
	const int b = a; //����䡰�ڴ桱����ͨ������ַ��ֵ��const int b��

	int * p = (int *) &b;
	*p = 1000;

	//�޸����ڴ�ֵ
	cout << "b = " << b << endl; //1000

}

/*
* 4�� �Զ�����������  ��constҲ����䡰�ڴ桱
*/
struct Person
{
	string m_Name; //����
	int m_Age;
};

void test03()
{
	const Person p1 = {"bbb", 20}; //��constҲ����䡰�ڴ桱
	//p1.m_Name = "aaa"; //����const�������޸�

	//�ƹ��������������޸ģ�ֻҪ�������ڴ�Ķ������޸�
	Person * p = (Person*) &p1;
	p->m_Name = "��������";
	(*p).m_Age = 18;

	cout << "������ " << p1.m_Name << " ���䣺 " << p1.m_Age << endl; //������ �������� ���䣺 18

}

int main(){

	test01();

	cout << "--------------" << endl;

	test02();

	cout << "--------------"<< endl;

	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
m_A = 10
--------------
b = 1000
--------------
������ �������� ���䣺 18
�밴���������. . .
*/