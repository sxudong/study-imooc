#define _CRT_SECURE_NO_WARNINGS //��ͳ�ĺ���C++�ϲ�֧�֣���printf()��strcpy()�����ᱨC4996����ȫ��
#include<iostream>
using namespace std;

/*
2 ::˫ð�������������
    2.1	ȫ�������� ֱ�Ӽӣ���
*/


int atk = 200; //ȫ�ֱ���
void test01()
{
	int atk = 100; //�ֲ�����

	cout << "������Ϊ �� " << atk << endl; //100
	//˫ð�š��������������  :: ��д��������ǡ�ȫ��������
	cout << "ȫ�ֹ�����Ϊ �� " << ::atk << endl; //200
}

int main(){
	test01();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������Ϊ �� 100
ȫ�ֹ�����Ϊ �� 200
�밴���������. . .
*/