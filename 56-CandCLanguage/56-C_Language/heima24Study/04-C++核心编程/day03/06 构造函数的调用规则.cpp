#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
6 ���캯���ĵ��ù���
    6.1	����ṩ���вεĹ��죬��ôϵͳ�Ͳ����ṩĬ�ϵĹ����ˣ����ǻ��ṩ��������
    6.2	����ṩ�˿������캯������ôϵͳ�Ͳ����ṩ�����Ĺ��캯����
*/


/*
* ϵͳĬ�ϸ�һ�����ṩ 3������  Ĭ�Ϲ��� �� �������� �� ��������
*/
class MyClass
{
public:
	//MyClass()
	//{
	//	cout << "Ĭ�Ϲ��캯��" << endl;
	//}

	MyClass(int a)
	{
		cout << "�вι��캯��" << endl;
	}

	//MyClass(const MyClass& m)
	//{
	//}
	int m_A;

};


/*
* 1.�������ṩ�ˡ��вι��캯��������ôϵͳ�͡����ᡱ�ٸ������ṩĬ�Ϲ��캯����
* ���� ϵͳ�����ṩĬ�Ͽ������캯�� , ���м򵥵�ֵ����
*/
void test01()
{
	MyClass c1(1);
	c1.m_A = 10;
	MyClass c2(c1); //����ϵͳ��Ĭ�Ͽ������족����ӡ��10��֤���ɹ����á�Ĭ�Ͽ������족
	cout << c2.m_A << endl; //10
}

/*
* 2.�������ṩ�ˡ��������족����ôϵͳ�͡����ᡱ�ṩ����������
*/
class MyClass2
{
public:
	MyClass2()
	{
		cout << "Ĭ�Ϲ��캯��" << endl;
	}

	//MyClass2(int a)
	//{
	//	cout << "�вι��캯��" << endl;
	//}

	MyClass2(const MyClass& m) //��������
	{
	}

	int m_A;
};

void test02()
{
	//�ṩ�ˡ��������족����Ҫ�ֶ��ṩ���޲ι��족������������ᱨ��
	MyClass2 c1;
}


int main(){
	test01();
	cout << "-------------" << endl;
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�вι��캯��
10
-------------
Ĭ�Ϲ��캯��
�밴���������. . .
*/
