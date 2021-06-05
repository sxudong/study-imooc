#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include <string>


/*
8 ��д�Լ����쳣��
	8.1	�Լ����쳣�� ��Ҫ�̳��� exception
	8.2	��д  ������   what����
	8.3	�ڲ�ά���Դ�����Ϣ �ַ���
	8.4	����ʱ���� ������Ϣ�ַ�����what��������ַ���
	8.5	string ת��char *���ӡ�.c_str()��
*/


/*
* �Լ���д���쳣��
*
* exception ϵͳ�ṩ�ġ��쳣���ࡱ�������ڵ��ࡣ
* ���Ҫ֪����д��Щ�������Ҽ���ת�����塱�ҵ� virtual �麯����д��
*/
class MyOutOfRangeException : public exception //
{

public:
	string m_ErrorInfo;

	MyOutOfRangeException(string errorInfo){
		this->m_ErrorInfo = errorInfo;
	}

	//��д��������
	virtual ~MyOutOfRangeException( ){

	}
	//��дwhat()����
	virtual const char *  what() const{
		//���� ������Ϣ
		//string ת��char *���ӡ�.c_str()��
		return this->m_ErrorInfo.c_str();
	}
};

class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;
		//���������
		if (age < 0 || age > 200)
			throw MyOutOfRangeException( string("���Լ�������Խ���쳣"));
	}
};

void test01()
{
	try{
		Person p("����", 300);
	}catch ( MyOutOfRangeException & e ){
		cout << e.what() << endl; //��ӡ������Ϣ
	}
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
���Լ�������Խ���쳣
�밴���������. . .
*/