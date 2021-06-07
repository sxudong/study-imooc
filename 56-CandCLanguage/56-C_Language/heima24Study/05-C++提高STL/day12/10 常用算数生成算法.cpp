/*
* 4.7 �������������㷨
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
using namespace std;
#include <algorithm> //����ʹ
#include <numeric>   //��ʹ
#include <iterator>


/*
* accumulate�㷨 
*   ��������Ԫ���ۼ��ܺ�
* 
* @param beg  ������ʼ������
* @param end  ��������������
* @param value  �ۼ�ֵ
*/
void test01()
{
	vector<int> v;
	for (int i = 0; i <= 100;i++)
		v.push_back(i);

	//0~100�ۻ���  5050
	//����������  ��ʼ�ۼ�ֵ
	int sum = accumulate(v.begin(), v.end(), 0);
	cout << "�ܺ�Ϊ��" << sum << endl; //5050
}


/*
* fill�㷨 
*   �����������Ԫ��
* 
* @param beg  ������ʼ������
* @param end  ��������������
* @param value  ���Ԫ��
*/
void test02()
{
	vector<int> v;
	v.resize(10);

	//���
	fill(v.begin(), v.end(), 1000);

	copy(v.begin(), v.end(), ostream_iterator<int>(cout, " "));
	cout << endl;
}

int main(){
	test01();
	cout << "---------------" << endl;
	test02();
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�ܺ�Ϊ��5050
---------------
1000 1000 1000 1000 1000 1000 1000 1000 1000 1000
�밴���������. . .
*/