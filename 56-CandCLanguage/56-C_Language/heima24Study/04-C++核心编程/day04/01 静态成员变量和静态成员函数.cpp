#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
1 ��̬��Ա�����;�̬��Ա����
	1.1	��̬��Ա����
		1.1.1 ����׶η����ڴ�
		1.1.2 ���ж���������
		1.1.3 ͨ��������ʡ�ͨ����������
		1.1.4 ��Ȩ�޿���
		1.1.5 �������� �����ʼ��

	1.2	��̬��Ա����
		1.2.1 ���Է��ʾ�̬��Ա�����������Է�����ͨ��Ա����
		1.2.2 ��ͨ��Ա���� �����Է���
		1.2.3 ��̬��Ա����Ҳ��Ȩ��
		1.2.4 ����ͨ��������ʣ�Ҳ����ͨ���������з���
*/


class Person
{
public:
	Person()
	{
		//m_Age = 10; //Person::m_Age������ù��캯�������Բ����ڡ����ڲ�"��ʼ����̬���ݡ�
	}

	/*
	* ����static���ǡ���̬��Ա���������Ṳ������
	* ��̬��Ա�������ڡ����ڡ������������⡱���г�ʼ��
	*
	*/
	static int m_Age;

	int m_A; //����̬��Ա������Ҳ����Ȩ�޵�

	/*
	* ��̬��Ա����
	*/
	static void func()
	{
		//m_A = 10;  //�����Է��ʡ���ͨ��Ա������
		m_Age = 100; //���Է��ʡ���̬��Ա������
		cout << "func���� m_Age = " << m_Age << endl;
	};

	/*
	* ��ͨ��Ա����
	*/
	void myFunc()
	{
		m_A = 100;   //���Է��ʡ���ͨ��Ա������
		m_Age = 100; //Ҳ���Է��ʡ���̬��Ա������
	}

private:
	static int m_other; //˽��Ȩ�� �����ⲻ�ܷ���

	static void func2()
	{
		cout << "func2����" << endl;
	}
};

//�����ʼ������ʼ��ʱ����static
int  Person::m_Age = 0;
int  Person::m_other = 10;

void test01()
{
	//1 ͨ�������������
	Person p1;
	p1.m_Age = 10;

	Person p2;
	p2.m_Age = 20;

	cout << "p1 = " << p1.m_Age << endl; //10 ���� 20�� 20
	cout << "p2 = " << p2.m_Age << endl; //20
	//��������

	//2 ͨ��������������
	cout << "ͨ����������Age��" << Person::m_Age << endl; //ͨ����������Age��20
	//cout << "other = " << Person::m_other << endl; //error ˽��Ȩ���������޷�����

	//��̬��Ա��������
	p1.func();
	p2.func();
	Person::func();

	//����̬��Ա������Ҳ����Ȩ�޵�
	//Person::func2(); //error

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
p1 = 20
p2 = 20
ͨ����������Age��20
func���� m_Age = 100
func���� m_Age = 100
func���� m_Age = 100
�밴���������. . .
*/