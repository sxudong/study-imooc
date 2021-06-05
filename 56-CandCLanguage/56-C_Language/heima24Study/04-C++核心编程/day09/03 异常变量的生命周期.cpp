#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 �쳣������������
	5.1	��� MyException e����࿪��һ������, ���ÿ�������
	5.2	��� MyExcepiton * e�� �� new��ǰ�ͷŶ��� new �Լ�����delete
	5.3	�Ƽ� MyException & e  ����д�����Ҿ�һ�����ݡ�
*/


/*
* �Զ����쳣��
*/
class MyException
{
public:
	int m_A;

	MyException(){
		cout << "MyException��Ĭ�Ϲ���" << endl;
	}

	MyException(const MyException & e){
		cout << "MyException�Ŀ�������" << endl;
	}

	~MyException(){
		cout << "MyException����������" << endl;
	}

	void printError(){
		this->m_A = 100;
		cout << "error"  << m_A<< endl;
	}
};

void doWork1()
{
	throw MyException();
}

void doWork2()
{
	throw & MyException();
}

void doWork3()
{
	throw new MyException();
}


void test01()
{
	try{
		doWork1();
    }catch (MyException e){ //�������죬MyException e����࿪��һ������
		cout << "�����쳣" << endl;
	}
}
/* Output:
MyException��Ĭ�Ϲ���
MyException�Ŀ�������
�����쳣
MyException����������
MyException����������
*/


/*
* �Ƽ�����
*/
void test02()
{
	try {
		doWork1();
	}catch (MyException & e){ //���Ч��
		cout << "�����쳣" << endl;
	}
}
/* Output:
MyException��Ĭ�Ϲ���
�����쳣
MyException����������
*/

void test03()
{
	try {
		doWork2();
	}catch (MyException * e) {
		//e->printError(); //�ò����ˣ�e�Ѿ�����ǰ�ɵ���
		//e->printError();
		//e->printError(); //�������ȷ�ģ�ָ��Ƿ��ڴ�ռ䣬��Ӧ����ô��

		cout << "�����쳣" << endl;
	}
}
/* Output:
MyException��Ĭ�Ϲ���
MyException����������
�����쳣
*/


void test04()
{
	try {
		doWork3();
	}catch (MyException * e) {
		cout << "�����쳣" << endl;
		delete e; //���Ծ� �ͷŶ���
	}
}
/* ��Ҫ�ֶ���delete���ͷţ��Ż���á������������ˡ�
MyException��Ĭ�Ϲ���
�����쳣
MyException����������
*/


int main(){
	test01();
	cout << "------------------" << endl;
	test02();
	cout << "------------------" << endl;
	test03();
	cout << "------------------" << endl;
	test04();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
MyException��Ĭ�Ϲ���
MyException�Ŀ�������
�����쳣
MyException����������
MyException����������
------------------
MyException��Ĭ�Ϲ���
�����쳣
MyException����������
------------------
MyException��Ĭ�Ϲ���
MyException����������
�����쳣
------------------
MyException��Ĭ�Ϲ���
�����쳣
MyException����������
�밴���������. . .
*/