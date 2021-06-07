/*
* 4.3 ���ñ����㷨
*/
#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <algorithm>
#include <vector>
#include <functional>
using namespace std;


/*
* �����㷨 ��������Ԫ��
* 
* @param beg  ��ʼ������
* @param end  ����������
* @param _callback  �����ص����ߺ�������
* @return  ��������
*/

void myPrint(int v){ //��ͨ��������
	cout << v << endl;
}

struct myPrint01 //�� ��struct��class��һ���ģ�
{
	//()����
	void operator()(int v){
		cout << v << endl;
	}
};

void test01()
{
	vector<int> v;
	for (int i = 0; i < 10;i++)
		v.push_back(i);

	//for_each(v.begin(), v.end(), myPrint);
	for_each(v.begin(), v.end(), myPrint01());
}
/* Output:
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
*/


struct myPrint02
{
	int m_Count;

	//()����
	void operator()(int v){
		cout << v << endl;
		m_Count++;
	}
};

/*
* 2 for_each�з���ֵ
*/
void test02()
{
	vector<int>v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	myPrint02 print2 = for_each(v.begin(), v.end(), myPrint02());
	cout << print2.m_Count << endl;
}
/* Output:
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
10
*/


/*
* 3 for_each���԰󶨲����������
*/
struct myPrint03 : public binary_function<int,int,void>
{
	//��д operator()
	void operator()(int v ,int start) const{
		cout << v  + start << endl;
	}
};

void test03()
{
	vector<int>v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	for_each(v.begin(), v.end(), bind2nd(myPrint03(), 10000));
}
/* Output:
10000
10001
10002
10003
10004
10005
10006
10007
10008
10009
*/

/*
* transform�㷨 ��ָ����������Ԫ�ذ��˵���һ������
* ע�� : transform �����Ŀ�����������ڴ棬������Ҫ������ǰ������ڴ�
* 
* @param beg1  Դ������ʼ������
* @param end1  Դ��������������
* @param beg2  Ŀ��������ʼ������
* @param _cakkback  �ص��������ߺ�������
* @return  ����Ŀ������������
*/
class TransForm
{
public:
	//���� operator()
	int operator()(int val){
		return val + 10;
	}
};

void test04()
{
	vector<int> vSource; //ԭ����
	for (int i = 0; i < 10; i++)
		vSource.push_back(i);

	vector<int> vTarget; //Ŀ������
	vTarget.resize(vSource.size());

	transform(vSource.begin(), vSource.end(), vTarget.begin(), TransForm());

	for_each(vTarget.begin(), vTarget.end(), [](int val){ cout << val << " "; });
}
/* Output:
10 11 12 13 14 15 16 17 18 19
*/


/*
* transform �ڶ����÷� 
* ����������������Ӱ��˵�Ŀ������
*/
class TransForm2
{
public:
	//���� operator()
	int operator()(int val ,int val2){
		return val + val2;
	}
};

void test05()
{
	vector<int> v1;
	vector<int> v2;
	for (int i = 0; i < 10;i++){
		v1.push_back(100 + i);
		v2.push_back(200 + i);
	}

	vector<int> vTarget; //Ŀ������
	vTarget.resize(v1.size());
	transform(v1.begin(), v1.end(), v2.begin(), vTarget.begin(), TransForm2());

	// 300 302...
	for_each(vTarget.begin(), vTarget.end(), [](int val){ cout << val << " "; });
}
/* Output:
300 302 304 306 308 310 312 314 316 318
*/

int main(){

	test01();
	cout << "---------------" << endl;
	test02();
	cout << "---------------" << endl;
	test03();
	cout << "---------------" << endl;
	test04();
	cout << "---------------" << endl;
	test05();
	cout << endl;
	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
1
2
3
4
5
6
7
8
9
10
---------------
10000
10001
10002
10003
10004
10005
10006
10007
10008
10009
---------------
10 11 12 13 14 15 16 17 18 19 ---------------
300 302 304 306 308 310 312 314 316 318 
�밴���������. . .
*/