#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 =�Ⱥ� ��ֵ���������
	5.1	ϵͳĬ�ϸ����ṩ ��ֵ�����д�� �Ǽ�ֵ����
	5.2	�������������ָ�������ָ�룬�Ϳ��ܳ��֡���ǳ������������
	5.3	����Ҫ���� = �����
	5.4	�������ʽ��� return*this
*/


//һ����Ĭ�ϴ��� Ĭ�Ϲ��졢�������������� operator=��ֵ����� ���м򵥵�ֵ����
class Person
{
public:

	Person(int a)
	{
		this->m_A = a;
	}

	int m_A;
};

void test01()
{
	Person p1(10);

	Person p2(0);

	p2 = p1; //��ֵ������ϵͳĬ�ϵĸ�ֵ���㣩

	cout << "p2 ��m_A" << p2.m_A <<endl;
}


class Person2
{
public:

	char* pName;

	Person2(char * name)
	{
		this->pName = new char[strlen(name) + 1];
		strcpy(this->pName, name);
	}

	/*
	* ���� = ��ֵ�����
	*/
	Person2 & operator= ( const Person2 & p) //����ֵ���ã����õı�����ָ�룩
	{
		//�ж����ԭ���Ѿ������������ݡ������ͷ�
		if (this->pName != NULL){
			delete[] this->pName;
			this->pName = NULL;
		}
		//���¿����ѿռ�
		this->pName = new char[strlen(p.pName) + 1];
		strcpy(this->pName, p.pName);

		return *this; //���ر���
	}

	//Person2����������
	~Person2()
	{
		if (this->pName != NULL){
			delete[] this->pName;
			this->pName = NULL;
		}
	}
};

void test02()
{
	Person2 p1("����");
	Person2 p2("��ʣ");
	//p2 = p1;

	Person2 p3("");
	p3 = p2 = p1; //���á�=�Ⱥš��������������ǳ������������Ҫ����=�Ⱥ��������

	cout << p2.pName << endl;
	cout << p3.pName << endl;

	//C++ϵͳĬ�ϵĸ�ֵ�����
	//int a = 10;
	//int b = 20;
	//int c;
	//c = a = b; //����20
	//cout << a << " " << b << " " << c << endl;

}

int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p2 ��m_A10
----------------
����
����
�밴���������. . .
*/