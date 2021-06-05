#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
1 �Ӻ����������
	1.1	��������Զ����������� ���� + ���㣬��ô����Ҫ���� + �����
	1.2	�ڳ�Ա���� ���� ȫ�ֺ����� ��дһ�� + ������ĺ���
	1.3	������ operator+ () {}
	1.4	��������� Ҳ�����ṩ����汾
*/

/*
int a = 10;
int b = 10;
int c = a + b;     //���������������ͣ�������֪��������㣨+��

Person p1(1, 1);
Person p2(1, 1);

Person p3 = p1 + p2 //��������֪�����������Person���ͽ������㣬�Զ���Ӻ�����
p3.m_A = 2, p3.m_B = 2
*/


class Person
{
public:
	Person(){};
	Person(int a, int b) :m_A(a), m_B(b) //����ʼ���б���ʼ������
	{}

	/*
	* +�����������
	* ��Ա����   ��Ԫ
	* �޲κ���   һԪ����һ��Ĭ��this������
	*/
	/*
	Person operator+ ( Person & p) //��Ԫ����Ա����Ҫ���һ��1����Ϊ��������͵͵��һ����Person * this����Ϊ������
	{
		Person tmp;
		tmp.m_A = this->m_A + p.m_A;
		tmp.m_B = this->m_B + p.m_B;
		return tmp;
	}
	*/

	int m_A;
	int m_B;
};

/*
* ���á�ȫ�ֺ��������� +�� �����������
* ����һ�����Ӻš��������������� operator+ ���ɱ�������ȡ�ġ�
*/
Person operator+ ( Person & p1, Person & p2) //ȫ�ֺ�����2���������ǡ���Ԫ��  p1 + p2
{
	Person tmp;
	tmp.m_A = p1.m_A + p2.m_A;
	tmp.m_B = p1.m_B + p2.m_B;
	return tmp;
}

//�Ӻ����������
Person operator+ (Person & p1, int a) //��Ԫ
{
	Person tmp;
	tmp.m_A = p1.m_A + a;
	tmp.m_B = p1.m_B + a;
	return tmp;
}


void test01()
{
	//����2������
	Person p1(10, 10);
	Person p2(10, 10);

	//Ҫ���㣬�����ṩ+�����������
	Person p3 = p1 + p2; // p1 + p2  ��ʲô���ʽת��ģ����ó�Ա����ת�䣺p1.operator+(p2),ȫ�ַ���ת�䣺operator+(p1,p2)
	Person p4 = p1 + 10; //+������������صİ汾
	cout << "p3 �� m_A: " << p3.m_A << "  m_B: " << p3.m_B << endl;
	cout << "p4 �� m_A: " << p4.m_A << "  m_B: " << p4.m_B << endl;

	//operator+(p1, p2);

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p3 �� m_A: 20  m_B: 20
p4 �� m_A: 20  m_B: 20
�밴���������. . .
*/