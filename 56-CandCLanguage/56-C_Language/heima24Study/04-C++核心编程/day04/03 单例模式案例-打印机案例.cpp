#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

/*
3 ����ģʽ���� �C ��ӡ������
	3.1	������ϯ����
	3.2	�ṩ��ӡ����
	3.3	�ṩͳ�ƴ�ӡ��������
*/


class Printer
{
private:
	Printer(){ m_Count = 0; };
	Printer(const Printer& p);

public:
	static Printer* getInstance()
	{
		return singlePrinter;
	}

	void printText(string text)
	{
		cout << text << endl;
		m_Count++;
		cout << "��ӡ��ʹ���˴���Ϊ�� " << m_Count << endl;
	}

private:
	static Printer* singlePrinter;
	int m_Count;
};
Printer* Printer::singlePrinter = new Printer;

void test01()
{
	//�õ���ӡ��
	Printer * printer =  Printer::getInstance();

	printer->printText("��ְ����");
	printer->printText("��ְ����");
	printer->printText("��н����");
	printer->printText("��������");
	printer->printText("��������");
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��ְ����
��ӡ��ʹ���˴���Ϊ�� 1
��ְ����
��ӡ��ʹ���˴���Ϊ�� 2
��н����
��ӡ��ʹ���˴���Ϊ�� 3
��������
��ӡ��ʹ���˴���Ϊ�� 4
��������
��ӡ��ʹ���˴���Ϊ�� 5
�밴���������. . .
*/