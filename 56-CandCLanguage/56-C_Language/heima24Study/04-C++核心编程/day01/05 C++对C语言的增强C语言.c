#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

/*�ο���06 C++��C���Ե���ǿC++����.cpp������*/

/*
* 1��ȫ�ֱ��������ǿ
*/
int a;
int a = 10; //C++�л���������¶�����

/*
* 2�����������ǿ
*/
int getRectS(w, h) //ûreturn����ֵ��C++�м���ǲ��������
{
}
void test02()
{
	getRectS(10, 10, 10); //�������Ҫ2������������3������C++�м�ⲻ��
}

/*
* 3������ת�������ǿ
*/
void test03()
{
	char * p = malloc(sizeof(64)); //malloc����ֵ��void*
}

/*
* 4��struct ��ǿ
*/
struct Person
{
	int m_Age;
	//void plusAge(); //c������struct�����ԼӺ���
};
void test04()
{
	struct Person p1; //ʹ��ʱ��������struct�ؼ���
}

/*
* 5�� bool������ǿ  C������û��bool����
*/
//bool flag;

/*
* 6����Ŀ�������ǿ
*/
void test06()
{
	int a = 10;
	int b = 20;

	printf("ret = %d \n", a > b ? a : b); //ret = 20

	//a > b ? a : b = 100; //C���Է��ص���ֵ��20 = 100 ��

	//C��������ģ��C++д
	*(a > b ? &a : &b) = 100;
	printf("a = %d ,b = %d \n", a, b); //a = 10, b = 100

}

/*
* 7�� const��ǿ
* C�����У�const���εı�������α�������������ǻ�����ڴ��
* C++�У�const��������ڴ�,const int m_B = 20;
*/
const int m_A = 10; //�ܵ������������Ը�
void test07()
{

	//m_A = 100; //�������������޸�

	const int m_B = 20; //α����
	//m_B = 100; //�������������޸�

	//�ƹ��������޸ĵ���
	int * p = (int *) &m_B;
	*p = 200;
	printf("*p = %d , m_B = %d \n", *p, m_B); //*p = 200 , m_B = 200

	//int arr[m_B]; //�����Գ�ʼ������

}



int main(){

	test06();

	test07();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
ret = 20
a = 10, b = 100
* p = 200, m_B = 200
�밴���������. . .
*/