#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/* Output:
6 �̳з�ʽ
	6.1	���ܹ��м̳� ���� ����˽�� �����е�˽������ ���������Լ̳���ȥ
	6.2	���м̳�
		6.2.1	�����е�protected ���������� protected
		6.2.2	�����е�public ���������� public
	6.3	�����̳�
		6.3.1	�����е�protected ���������� protected
		6.3.2	�����е�public ���������� protected
	6.4	˽�м̳�
		6.4.1	�����е�protected ���������� private
		6.4.2	�����е�public ���������� private
*/


class Base1
{
public:
	int m_A = 10;
protected:
	int m_B = 20;
private:
	int m_C = 30;
};

//���м̳�
class Son1 : public Base1
{
public:
	void func()
	{
		//cout << m_C << endl; //������˽�е����� ���ɼ̳�
		cout << m_A << endl;   //�����й��е����� �ɼ̳У����ǡ�public��
		cout << m_B << endl;   //�����б��������� �ɼ̳У����ǡ�protected��������ʲ���
	}

};

void myFunc()
{
	Son1 s1;
	s1.m_A;
	//s1.m_B; //err ���ܷ��ʣ��̳�������Ȼ���ܱ�����

	s1.func();
}

////////////////////////////////////////�����̳�////////////////////////////////////////

class Base2
{
public:
	int m_A = 10;
protected:
	int m_B = 20;
private:
	int m_C = 30;
};

class Son2 : protected Base2
{
public:
	void func()
	{
		//cout << m_C << endl; //�����С�˽�е����ԡ� ���ɼ̳�
		cout << m_A << endl;   //�����С����е����ԡ� �ɼ̳У����ǡ�protected��
		cout << m_B << endl;   //�����С����������ԡ� �ɼ̳У����ǡ�protected��
	}

};
void myFunc2()
{
	Son2 s;
	//s.m_A; //err ���ɷ��ʣ�����������ɡ��ܱ����ġ�
	//s.m_B; //err ���ɷ��ʣ�����������Ȼ���ܱ����ġ�

	s.func();
}


////////////////////////////////////////˽�м̳�////////////////////////////////////////
class Base3
{
public:
	int m_A = 10;
protected:
	int m_B = 20;
private:
	int m_C = 30;
};

class Son3 : private Base3
{
public:
	void func()
	{
		//cout << m_C << endl; //�����С�˽�е����ԡ� ���ɼ̳�
		cout << m_A << endl;   //�����С����е����ԡ� �ɼ̳У����ǡ�private��
		cout << m_B << endl;   //�����С����������ԡ� �ɼ̳У����ǡ�private��
	}

};

class GrandSon3 : public Son3
{
public:
	void myFunc()
	{
		//cout << m_A << endl; //err �������� ���ʲ��� m_A����Ϊ��Son3��m_A�Ѿ���˽��������
	}
};


int main(){
	myFunc();
	cout << "------------------" << endl;
	myFunc2();

	Son3 son3;
	//son3.m_A; //err ���ɷ��ʣ��̳�������ɡ�˽�����ԡ�
	//son3.m_B; //err ���ɷ��ʣ��̳�������ɡ�˽�����ԡ�
	//son3.m_C; //err ���ɷ��ʣ����ɼ̳� ��˽�����ԡ�

	system("pause");
	return EXIT_SUCCESS;
}