#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;
#include "game1.h"
#include "game2.h"

/*
3 namespace �����ռ�
    3.1	��; ������Ƴ�ͻ����
    3.2	������ȫ��������������
    3.3	�����ռ��¿��Է��� �������������ṹ�塢�࡭
    3.4	�����ռ����Ƕ�������ռ�
    3.5	�����ռ��ǿ��ŵģ�������ʱ�����µĳ�Ա
    3.6	���������ռ� static
    3.7	���������
*/


/*
* namespace�����ռ���Ҫ��; �������"������ͻ"������
*/
void test01()
{
	LOL::goAtk();
	KingGlory::goAtk();
}


//1�������ռ���,���Էź������������ṹ�塢��
namespace A
{
	void func();  //����
	int m_A = 20; //����

	struct Person //�ṹ��
	{
	};

	class Animal{}; //��

	namespace B
	{
		int m_A = 10;
	}
}
//2�������ռ���붨����ȫ����������
//3�������ռ����Ƕ�������ռ�

void test02()
{
	cout << "������B�µ�m_AΪ�� " << A::B::m_A << endl;
}

//4�������ռ��ǿ��ŵģ�������ʱ��ԭ�ȵ������ռ��������
namespace A  //��A�����ռ�������������ռ�A���С��ϲ���
{
	int m_B = 1000;
}

void test03()
{
	cout << "A::�µ�m_AΪ" << A::m_A << " m_BΪ�� " << A::m_B << endl; //A::�µ�m_AΪ20 m_BΪ�� 1000
}


//5�����������������ռ�
//��д�����������ռ䣬�൱��д�� static int m_C ; static int m_D;
//ֻ���ڵ�ǰ�ļ���ʹ��
namespace
{
	int m_C = 0;
	int m_D = 0;
}


//6�������ռ���ԡ��������
namespace veryLongName
{
	int m_A = 30;
}

void test04()
{
	//�����
	namespace veryShortName = veryLongName;
	cout << veryLongName::m_A << endl;  //30
	cout << veryShortName::m_A << endl; //30
}


int main(){

	test02();

	test03();

	test04();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������B�µ�m_AΪ�� 10
A::�µ�m_AΪ20 m_BΪ�� 1000
30
30
�밴���������. . .
*/