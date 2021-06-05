#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
6 �쳣�Ķ�̬ʹ��
	6.1	���ö�̬��ʵ�� printError ͬһ���ӿڵ���
	6.2	�׳���ͬ�Ĵ��������ʾ��ͬ����
*/


/*
* �쳣����
*/
class BaseException
{
public:
	virtual void printError(){

	}
};

//�����쳣
class  NullPointerException : public BaseException
{
public:
	virtual void printError(){
		cout << "��ָ���쳣" << endl;
	}
};

//�����쳣
class OutofRangeException : public BaseException
{
public:
	virtual void printError(){
		cout << "Խ���쳣" << endl;
	}
};


void doWork1()
{
	throw NullPointerException(); //��ָ���쳣
}

void doWork2()
{
	throw OutofRangeException();   //Խ���쳣
}


void test01()
{
	try{
		doWork1();
	}catch (BaseException & e){ //������̬������������쳣
		e.printError();
	}
}

void test02()
{
	try {
		doWork2();
	}
	catch (BaseException & e){ //������̬������������쳣
		e.printError();
	}
}


int main(){

	test01();
	cout << "------------------" << endl;
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��ָ���쳣
------------------
Խ���쳣
�밴���������. . .
*/