#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;


/*
2 �����������������
	2.1	()�º���  ����() ������������
	2.2	MyAdd()��������
*/


/*
* ()����
*/
class MyPrint
{
public:
	//()���������
	void operator() (string text)
	{
		cout << text << endl;
	}
};

void test01()
{
	MyPrint myPrint;
	//�º�����������һ������������������Ϊ���ƺ���������һ���࣬�������С��º�������
	myPrint("hello world1111"); // hello world1111
}


class MyAdd
{
public:
	//()���������
	int operator() (int v1,int v2)
	{
		return v1 + v2;
	}
};

void test02()
{
	MyAdd myAdd;
	cout << myAdd(1, 1) << endl;   //2

	//��������
	cout << MyAdd()(1, 1) << endl; //2
}



int main(){

	test01();
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
hello world1111
2
2
�밴���������. . .
*/