#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
8 ��������
    8.1	ʹ�ó��� �����β�Ϊֻ��
    8.2	const int &a = 10;������ڴ�
*/


void test01()
{
	//int &ref = 10; //err �����˲��Ϸ����ڴ棬������
	const int &ref = 10; //����const�� ������������ʽΪ�� int tmp = 10; const int &ref = tmp;

	//ref = 10; //err

	//�ƹ����������ȥ�޸���
	int * p = (int*) &ref;
	*p = 1000;

	cout << "ref = " << ref << endl; //ref = 1000

}

/*
* ��������ʹ�ó��� ���������β�
*/
void showValue(const int &val)
{
	//val += 1000; //���ֻ������ʾ���ݣ������޸����ݣ���ô����const��������β�
	cout << "val = " << val << endl; //val = 10
}

void test02()
{
	int a = 10;
	showValue(a);
}

int main(){
	test01();
	test02();
	system("pause");
	return EXIT_SUCCESS;
}