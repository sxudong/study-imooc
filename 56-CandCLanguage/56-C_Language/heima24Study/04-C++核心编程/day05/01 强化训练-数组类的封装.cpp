#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include "MyArray.h"
using namespace std;


void test01()
{
	//������������
	MyArray * array = new MyArray(30);
	//MyArray & arr = * array;
	//MyArray  * array2 = new MyArray(arr);  //new��ʽָ�����ÿ�������

	MyArray * array2 = new MyArray(* array); //new��ʽָ�����ÿ������졣MyArray & array = * array;  ������������ָ��
	MyArray array3 = * array;    //���캯�����صı���

	//MyArray * array4 = array; //���������һ��ָ�� ��arrayִ�еĵ�ַ��ͬ�����Բ�����ÿ�������

	delete array;
	//β�巨����
	for (int i = 0; i < 10;i++)
		array2->push_Back(i);

	//��ȡ���ݲ���
	for (int i = 0; i < 10;i++)
		cout << array2->getData(i) << endl;

	//����ֵ����
	array2->setData(0, 1000);

	//cout << (* array2)[0] << endl;
	cout << array2->getData(0) << endl;;

	//��ȡ�����С
	cout << "array2 �������СΪ�� " << array2->getSize() << endl;
	cout << "array3 �������СΪ�� " << array3.getSize() << endl;

	//��ȡ��������
	cout << "array2 ����������Ϊ�� " << array2->getCapacity() << endl;
	cout << "array3 ����������Ϊ�� " << array3.getCapacity() << endl;

	/*
	6 []���������
		6.1	������������������
		6.2	int& operator[](int index)
		6.3	return this->pAddress[index]
    */

	//��ȡ ���� ��������  �����[]�������úͷ���
	array3.push_Back(100000);          //�������в��������
	cout << array3.getData(0) << endl;
	cout << array3[0] << endl;         //����������[]����
	array3[0] = 100;                   //����������[]����
	cout << array3[0] << endl;         //����������[]����

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�����������
�����������
0
1
2
3
4
5
6
7
8
9
1000
array2 �������СΪ�� 10
array3 �������СΪ�� 0
array2 ����������Ϊ�� 30
array3 ����������Ϊ�� 30
100000
100000
100
�밴���������. . .
*/