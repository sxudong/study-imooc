#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <string>
using namespace std;

//��������
void test01()
{
	//��һ��
	pair<string, int> p(string("Tom"), 100);

	//ȡֵ
	cout << "������" << p.first << endl;   //Tom
	cout << "���䣺 " << p.second << endl; //100

	//�ڶ��ִ���
	pair<string, int> p2 = make_pair("Jerry", 200);
	cout << "������" << p2.first << endl;   //Jerry
	cout << "���䣺 " << p2.second << endl; //200
}


int main(){
	test01();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
������Tom
���䣺 100
������Jerry
���䣺 200
�밴���������. . .
*/