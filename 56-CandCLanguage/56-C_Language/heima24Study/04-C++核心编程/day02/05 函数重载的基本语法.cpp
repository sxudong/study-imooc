#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
* ��������
* C++�� �������ƿ����ظ�
* ������ͬһ��������,����������ͬ
* �����Ĳ��� ������ͬ ���� ���Ͳ�ͬ  ���� ˳��ͬ
*/
void func()
{
	cout << "�޲�����func" << endl;
}

void func(int a )
{
	cout << "�в�����func(int a)" << endl;
}

void func(double  a)
{
	cout << "�в�����func(double a)" << endl;
}

void func(double  a , int b)
{
	cout << "�в�����func(double a ,int b)" << endl;
}

void func(int a, double b)
{
	cout << "�в�����func(int a ,double b)" << endl;
}

/*
* ������ֵ��������Ϊ�������ص������𣿣��� ���� ������
*/
//int func(int a, double b) //int���ͷ���ֵ
//{
//	cout << "�в�����func(int a ,double b)" << endl;
//	return 1;
//}

void test01()
{
	func(1.1);     //�в�����func(double a)
	func(1.1,3);   //�в�����func(double a ,int b)
	func(1, 3.14); //�в�����func(int a ,double b)
}


/*
* ���������� �����ˡ�Ĭ�ϲ�����ʱ��Ҫע��������������
*/
void func2(int a,int b = 10)
{

}
void func2(int a)
{

}

void test02()
{
	//func2(10);  //err ����������

}

/*
* ���õ����ذ汾
*/
void func3(int &a) //���ñ���Ҫ���Ϸ����ڴ�ռ�
{
	cout << " int &a" << endl;
}
void func3(const int& a)  //constҲ�ǿ�����Ϊ�����ء�������  int tmp = 10; const int &a = tmp;
{
	cout << "const int &a" << endl;
}


void test03()
{
	int a = 10;
	func3(a);
	//func3(10); //err ���������������ϡ�const���󣬱������Ų�������
	func3(10); //const int &a
}


int main(){
	test01();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}