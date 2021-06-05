#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "MyArray.hpp"
#include <string>


/*
* ��c++���� �ڶ����֡�1.8 ��ģ���Ӧ�� ���� �����װ
*/

//���int��������
void printIntArray( MyArray<int> & array ) //���õı�����ָ��
{
	for (int i = 0; i < array.getSize();i++)
		cout << array[i] << endl;
}

class Person
{
public:
	string m_Name;
	int m_Age;

	Person(){}; //Ĭ�Ϲ���

	Person(string name, int age){
		this->m_Name = name;
		this->m_Age = age;
	}
};



//���Person��������
void printPersonArray( MyArray<Person> & array )
{
	for (int  i = 0; i < array.getSize(); i++)
		cout << "������ " << array[i].m_Name << " ���䣺 " << array[i].m_Age << endl;
}



int main(){

	//����int��������
	MyArray<int> arr(10);
	for (int i = 0; i < 10;i++)
		arr.push_Back(i + 100);

	printIntArray(arr);

	Person p1("MT", 10);
	Person p2("����", 12);
	Person p3("ɵ��", 14);
	Person p4("����", 15);

	//����Person��������
	MyArray<Person> arr2(10);
	arr2.push_Back(p1);
	arr2.push_Back(p2);
	arr2.push_Back(p3);
	arr2.push_Back(p4);

	printPersonArray(arr2);

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
100
101
102
103
104
105
106
107
108
109
������ MT ���䣺 10
������ ���� ���䣺 12
������ ɵ�� ���䣺 14
������ ���� ���䣺 15
�밴���������. . .
*/