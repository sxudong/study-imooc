#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
6 ����ģ�������̳�
	6.1	���������ģ���࣬������������߱����� �����е�T������ʲô����
	6.2	��������ߣ���ô�޷������ڴ棬���벻��
	6.3	���ò����б�class Child : public Base<int>
*/


/*
* ��ģ��
*/
template <class T> //�൱��Java������ָ����ķ��Ͳ���
class Base
{
public:
	T m_A; //double����
};

/*
* child�̳��� base�������base�е�T�����ͣ�����T�޷������ڴ�
*/
class Child : public Base<int> //���������д����
{

};

/*
* child2 Ҳ��ģ����
*/
template<class T1, class T2>   //�൱��Java������ָ����ķ��Ͳ����б�
class Child2 : public Base<T2> //���������û��д�������û���ָ����
{
public:
	T1 m_B; //int����

	Child2(){
		cout << typeid(T1).name() << endl;
		cout << typeid(T2).name() << endl;
	}
};

void test01()
{
	Child2<int, double>child; //�������û�ָ������
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
int
double
�밴���������. . .
*/