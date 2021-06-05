#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
2 �������� �����ȱ������
    2.1	��������һ�����飬���Ϲؼ��֣���������һ��������������
    2.2	���ӹؼ��֣�Ҳ���������͵���ĸ����inline
    2.3	��Ա���� Ĭ�ϼ��Ϲؼ���
    2.4	�����������˹ؼ��֣�����ʵ��ҲҪ��inline�ؼ���
*/


//����һ���ӷ�
//#define  MyAdd(x,y) x + y
#define  MyAdd(x,y) ((x)+(y))

void test01()
{
	int ret = MyAdd(10, 20) * 20; //Ԥ�ڽ�� 600 ((10)+(20))*20

	cout << "ret = " << ret << endl; //ret = 600
}


#define MyCompare(a,b)  ((a) < (b)) ? (a) :(b)

inline void mycompare(int a, int b) //c++��������������(inline function).
{
	int ret = a < b ? a : b;
	cout << "ret :::::  " << ret << endl;
}

//1 ��������ע������
// ���ڲ��ĳ�Ա���� Ĭ��ǰ���ӡ�inline���ؼ���
inline void func();     //������������
inline void func() { }; //�������ʵ��ʱ��û�мӡ�inline���ؼ��� ����ô���������Ȼ������������

void test02()
{
	int a = 10;
	int b = 20;

	//int ret =  MyCompare(++a, b); // Ԥ�ڽ�� 11    ((++a) < (b)) ? (++a):(b)

	//cout << "ret = " << ret << endl; //ret = 12

	mycompare(++a, b); //ret :::::  11

}

/*
* 3 �꺯��Ҳû��������
*/

int main() {

	test01();

	test02();

	system("pause");
	return EXIT_SUCCESS;
}