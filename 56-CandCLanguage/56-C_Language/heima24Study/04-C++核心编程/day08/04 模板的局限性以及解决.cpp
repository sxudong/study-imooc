#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
3 ģ�������
	3.1	ģ�岻�ܽ�����е�����
	3.2	������ֲ��ܽ�������ͣ�����ͨ�������ؾ��廯���������
	3.3	template<> ����ֵ ������<��������>��������
*/


class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;
		this->m_Age = age;
	}
};



template<class T> //ģ�壨����Java���ͷ�����
bool myCompare( T & a , T & b )
{
	if ( a == b)
		return true;

	return false;
}


/*
* ͨ�������������廯���Զ����������ͣ�����������⡣
* ������廯�ܹ�����ƥ�䣬��ô��ѡ�񡰾��廯����
*
* �﷨��template<> ����ֵ  ������<��������>(����)
*/
template<> bool myCompare<Person>(Person & a, Person & b)
{
	if ( a.m_Age  == b.m_Age)
		return true;

	return false;
}


void test01()
{
	int a = 10;
	int b = 20;

	int ret = myCompare(a, b);

	cout << "ret = " << ret << endl; //0

	Person p1("Tom", 10);
	Person p2("Jerry", 10);

	int ret2 = myCompare(p1, p2);

	cout << "ret2 = " << ret2 << endl; //1

}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 0
ret2 = 1
�밴���������. . .
*/