#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include "MyString.h"
using namespace std;


/*
4 ǿ��ѵ�� ���� �ַ�����װ
	4.1	cout ���� �Զ�����ַ���
	4.2	cin ���û������ַ�������
	4.3	���� = �����
	4.4	���� + �����
	4.5	���� [] �����
	4.6	���� == �����
*/


//���� MyString
void test01()
{
	MyString str = "abc";

	//����ȫ�ֺ��� << �������������
	cout << str << endl; //abc

	/*
	cout << "������str�µ����ݣ�" << endl;

	cin >> str;  //cin���� ����ȫ�ֺ��� >> �������������

	cout << "������Ϊ��" << str << endl;
	*/

	MyString str2(str);

	MyString str3 = "aaaaaa";

	str3 = str2;    //���ó�Ա���� ���� = �����
	str3 = "aaaa";  //���ó�Ա���� ���� = �����

	cout << "str3 = " << str3 << endl;  //str3 = aaaa

	str3[0] = 'w'; //���ó�Ա���� ���� [] �����

	cout << "str3 ��һ��λ��Ϊ = " << str3[0] << endl; //str3 ��һ��λ��Ϊ = w


	MyString str4 = "";
	//���ó�Ա���� ���� + �����
	str4 = str2 + str3; //�ַ���ƴ��
	cout << "str4 Ϊ " << str4 << endl;


	//���ó�Ա���� ���� == �����
	if (str3 == str4)
		cout << "str3 �� str4���" << endl;
	else
		cout << "str3 �� str4�����" << endl;

	/* ϵͳ�Դ����������������
	int a = 10;
	cin >> a; //cin����
	cout << "a = " << a << endl;
	*/

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
abc
str3 = aaaa
str3 ��һ��λ��Ϊ = w
str4 Ϊ abcwaaa
str3 �� str4�����
�밴���������. . .
*/