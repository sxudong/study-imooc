#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

namespace KingGlory
{
	int sunwukongId = 10;
}

void test01()
{
	int sunwukongId = 20;

	//using ����  ע��������������
	//д��using������  �������д���˵���Ժ󿴵���sunwukongId ����KingGlory�µ�
	//����  ���������оͽ�ԭ��
	//������
	//using KingGlory::sunwukongId;  //err

	cout << sunwukongId << endl;
}

//using����ָ��
namespace LOL
{
	int sunwukongId = 30;
}

void test02()
{
	//int sunwukongId = 20;
	//using����ָ��
	using namespace KingGlory; //��������ҫ����
	using namespace LOL;//��LOL����
	//����򿪶�����䣬ҲҪ�������������
	cout << LOL::sunwukongId << endl;
}


int main(){

	test01();
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
30
�밴���������. . .
*/