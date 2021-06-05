#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
7 ������ ������
	7.1	������  void func() const {} ������
	7.2	������ ������thisָ��  const Type* const this
	7.3	������ �����޸�thisָ��ִ�е�ֵ
	7.4	������ �ڶ���ǰ ���� const���� const Person p1
	7.5	������ �����Ե�����ͨ�ĳ�Ա����
	7.6	������ ���Ե��ó�����
	7.7	��mutable���εĹؼ������ڳ����������޸ĵ�
*/


class Person
{
public :
	Person()
	{
		//�������޸�����
		//this ��Զִ�б���
		//Person * const this ָ���ָ�򲻿����޸�
		this->m_A = 0;
		this->m_B = 0;
	}

	/*
	* �����������������޸�ָ��ָ���ֵ
	*/
	void showInfo() const
	{
		//this->m_A = 1000; //err ������ �������޸�ָ��ָ���ֵ
		this->m_B = 1000;   //mutable���εı���������������Ҳ�����޸�

		// const Person * const this
		cout << "m_A = " << this->m_A << endl; //m_A = 0
		cout << "m_B = " << this->m_B << endl; //m_B = 1000
	}

	void show2()
	{
		m_A = 100;
	}

	void show3() const
	{
		//m_A = 100; //err ������ �������޸�ָ��ָ���ֵ
	}

	int m_A;
	mutable int m_B; //�����ǡ����������һ���ִ��Ҫ�޸�

};

void test01()
{

	Person p1;
	p1.showInfo();

	/*
	* �������󡱲������޸�����
	*/
	const Person p2;
	cout << p2.m_A << endl; //0
	//p2.show2();  //������ �����Ե��á���ͨ��Ա������
	p2.show3();    //������ ���Ե��á���������
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}