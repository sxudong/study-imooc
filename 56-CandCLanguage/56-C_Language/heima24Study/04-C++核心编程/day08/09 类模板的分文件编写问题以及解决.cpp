#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;
//#include "Person.cpp"  //����#include "Person.h"ͷ�ļ��ᱨ�������޷����С�
#include "Person.hpp"


/*
8 ��ģ��ķ��ļ���д�����Լ����
	8.1.h.cpp �ֱ�д���������͡�ʵ�֡�
	8.2	�������ڡ���ģ��ĳ�Ա���������н׶β�ȥ���������°�����.h��ͷ�ļ������ᴴ��������ʵ�֣��޷������ⲿ���
	8.3	�������������.cpp�ļ����磺#include "Person.cpp" �����Ƽ���
	8.4	��Ҫ���С����ļ�����д��д����ͬһ���ļ����У�����������ʵ�֣���׺����Ϊ��.hpp����
	8.5	Լ���׳ɵ�
*/


/*
* ���飺ģ�塰��Ҫ�����ļ���д����д��һ�����м��ɣ����ڽ��С��������͡�ʵ�֡���
* ���Ѻ�׺����Ϊ��.hpp��Լ���׳ɡ�
*/
int main(){

	Person<string, int> p("��˽�", 10);
	p.showPerson();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��������˽�  ���䣺  10
�밴���������. . .
*/