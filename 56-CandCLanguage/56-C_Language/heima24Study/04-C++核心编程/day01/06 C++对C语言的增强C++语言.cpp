#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
* 1��ȫ�ֱ��������ǿ
*/
//int a;
int a = 10;

/*
* 2�����������ǿ ,����������ǿ,����ֵ�����ǿ,�������ò��������ǿ
*/
int getRectS(int w, int h)
{
	return w*h;
}
void test02()
{
	getRectS(10, 10);
}


/*
* 3������ת�������ǿ
*/
void test03()
{
	char * p = (char*) malloc(sizeof(64)); //malloc����ֵ��void*
}


/*
* 4��struct ��ǿ
*/
struct Person
{
	int m_Age;
	void plusAge(){ m_Age++; }; //c++��struct���ԼӺ���
};

void test04()
{
	Person p1; //ʹ��ʱ����Բ��ӡ�struct���ؼ���
	p1.m_Age = 10;
	p1.plusAge();
	cout << p1.m_Age << endl; //11
}

/*
* 5�� bool������ǿ C������û��bool����
*/
bool flag = true; //ֻ������ true���� �棨��0��  false ����٣�0��

void test05()
{
	cout << sizeof(bool) << endl; //1

	flag = 100;
	//bool���� ��0��ֵ תΪ 1  ��0��תΪ0
	cout << flag << endl; //1
}

/*
* 6����Ŀ�������ǿ
*/
void test06()
{
	int a = 10;
	int b = 20;

	cout << "ret = " << (a < b ? a : b) << endl; //ret = 10

	a < b ? a : b = 100; //b = 100  C++�з��ص��Ǳ���
	cout << "a = " << a << endl; //a = 10
	cout << "b = " << b << endl; //b = 20

	(a < b ? a : b) = 100;
	cout << "a = " << a << endl; //a = 100
	cout << "b = " << b << endl; //b = 20
}


/*
* 7�� const��ǿ
* C�����У�const���εı�������α�������������ǻ�����ڴ��
* C++�У�const��������ڴ�,const int m_B = 20;
*/
const int m_A = 10; //�յ������������Ը�
void test07()
{
	const int m_B = 20; //�����ġ�������
	//m_B = 100;  //����������

	/*
	* ����������ʱ����һ���ڴ�ռ�
	*   int tmp = m_B //tmp���ڴ�
	*   int *p = (int *) &tmp  //*pָ�������ʱ�ǿ�ռ�
	*   ��ʱ�ռ俴����
	*/
	int * p = (int *) &m_B;
	*p = 200;
	cout << "*p = " << *p << endl;   //*p = 200
	cout << "m_B = " << m_B << endl; //m_B = 20

	int arr[m_B]; //���Գ�ʼ������
}


int main(){

	test04();
	cout << "------------------" << endl;
	test05();
	cout << "------------------" << endl;
	test06();
	cout << "------------------" << endl;
	test07();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
11
------------------
1
1
------------------
ret = 10
a = 10
b = 20
a = 100
b = 20
------------------
*p = 200
m_B = 20
�밴���������. . .
*/