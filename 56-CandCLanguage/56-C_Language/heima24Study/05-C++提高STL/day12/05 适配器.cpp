#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
#include <vector>
#include <algorithm>
#include <functional>
#include <string>
using namespace std;


/*
* �ܽ᣺bind1st �� bind2nd ����?
*   bind1st�����������󶨡�Ϊ����������ĵ�һ��������
*   bind2nd�����������󶨡�Ϊ����������ĵڶ���������
*   bind1st �� bind2nd ���ڽ�����Ԫ��������תΪ��һԪ�������󡱡�
* 
* ������⣺��ʵ���ǰ�֮������������һ����bind�󶨵Ĺ̶���ֵ����һ�����ǹ̶��ģ�����һ���ǹ̶��ľͳ�һԪ���ˡ�
*/


/*
* ����������
* 
* ����������������ڱ���������ʱ����ϣ���������е�ֵȫ������100֮����ʾ��������ô����
*   ����ֱ�Ӹ���������󶨲��� ����׶ξͻᱨ��
*   for_each(v.begin(), v.end(), bind2nd(myprint(),100));
*   ���������ʹ�ð�������,��Ҫ�����Լ��ĺ�������̳�binary_function ���� unary_function
*   �������Ǻ���������һԪ�������� ���Ƕ�Ԫ��������
*/


/*
* ��һ�� �� ���� bind2nd
*   �̳��� binary_function<��������1 ����������2 ������ֵ����>
*   ��const���� operator()
*/
class MyPrint : public binary_function<int,int,void>
{
public:
	//()��д
	void operator()(int v ,int start) const{
		cout << "v = "<< v << " start = "<< start << " v+start = "<< v  + start<< endl;
	}
};

void test01()
{
	vector<int> v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	cout << "��������ʼֵ" << endl;

	int num;
	cin >> num;

	//bind1st �ǽ���������󶨵���һ������
	//bind2nd �ǽ���������󶨵��ڶ�������
	//��Ա����������
	//for_each(v.begin(), v.end(), bind2nd( MyPrint(),num) ); //�����鵽 operator()(int v ,int start)�ڶ������� start ��
	for_each(v.begin(), v.end(), bind1st(MyPrint(), num));    //�����鵽 operator()(int v ,int start)��һ������ v ��
}
/* Output:
��������ʼֵ
5
v = 5 start = 0 v+start = 5
v = 5 start = 1 v+start = 6
v = 5 start = 2 v+start = 7
v = 5 start = 3 v+start = 8
v = 5 start = 4 v+start = 9
v = 5 start = 5 v+start = 10
v = 5 start = 6 v+start = 11
v = 5 start = 7 v+start = 12
v = 5 start = 8 v+start = 13
v = 5 start = 9 v+start = 14
*/


/*
* ��ν�� not1() not2()
* not1 �ǹ���һ����ν�ʽ�����෴����һԪ��������
* not2 �ǹ���һ����ν�ʽ�����෴���Ķ�Ԫ��������
*/

/*
* һԪȡ��������  not1
*   �̳� unary_function <��������1������ֵ����>
*   const����
*/
class GreaterThenFive : public unary_function<int,bool>
{
public:
	//()��д
	bool operator()(int v) const{
		return v > 5;
	}
};


//ȡ��������
void test02()
{
	//һԪȡ��
	vector<int> v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	//���Ҵ���5������
	//vector<int>::iterator pos1 =  find_if(v.begin(), v.end(), GreaterThenFive()); //���ص�һ��С��5������
	//if (pos1 != v.end())
	//	cout << "�ҵ�����5������Ϊ " << *pos1 << endl; //�ҵ�С��5������Ϊ 6
	//else
	//	cout << "δ�ҵ�" << endl;

	//�����Ϊ ��С��5������
	//vector<int>::iterator pos1 =  find_if(v.begin(), v.end(), not1( GreaterThenFive())); //GreaterThenFive()����5��not1 һԪ����ȡ������С��5
	//if (pos1 != v.end())
	//	cout << "�ҵ�С��5������Ϊ " << *pos1 << endl; //�ҵ�С��5������Ϊ 0  //��һ��С��5������0
	//else
	//	cout << "δ�ҵ�" << endl;

	//�����Ϊ ��С��5������
	vector<int>::iterator pos = find_if(v.begin(), v.end(), not1(bind2nd(greater<int>(),5) )); //greater�ڽ��������� ���ڣ�ȡ������С��5����less�ڽ��������� С�ڣ�
	if (pos != v.end())
		cout << "�ҵ�С��5������Ϊ " << *pos << endl; //�ҵ�С��5������Ϊ 0 //��һ��С��5������0
	else
		cout << "δ�ҵ�" << endl;

	//vector<int>::iterator pos = find_if(v.begin(), v.end(), not1(bind2nd(less<int>(), 5))); //less�ڽ��������� С�ڣ�not1 һԪ����ȡ�����Ǵ���5
	//if (pos != v.end())
	//	cout << "�ҵ�����5������Ϊ " << *pos << endl; //�ҵ�����5������Ϊ 5 // >= 5, ������5
	//else
	//	cout << "δ�ҵ�" << endl;
}



void MyPrint03(int v,int start) {
	cout << v + start << endl;
}

/*
* ����ָ�������� ptr_fun()
*/
void test03()
{
	vector<int> v;
	for (int i = 0; i < 10; i++)
		v.push_back(i);

	//������ָ�� ����Ϊ ��������
	//ptr_fun( )��һ����ͨ�ĺ���ָ������ɺ�������
	for_each(v.begin(), v.end(), bind2nd( ptr_fun( MyPrint03) ,100 ));
}
/* Output:
100
101
102
103
104
105
106
107
108
109
*/



/*
* ��Ա���������� mem_fun_ref
*/
class Person
{
public:
	string m_Name;
	int m_Age;

	Person(string name, int age){
		this->m_Name = name;
		this->m_Age = age;
	}

	void showPerson(){
		cout << "��Ա�����У������� " << m_Name << " ���䣺" << m_Age << endl;
	}

	void plusAge(){
		this->m_Age = this->m_Age + 100;
	}
};

void MyPrintPerson( Person & p){
	cout << "������ " << p.m_Name << " ���䣺" << p.m_Age << endl;
}

void test04()
{
	vector<Person>v;

	Person p1("aaa", 10);
	Person p2("bbb", 15);
	Person p3("ccc", 18);
	Person p4("ddd", 40);

	v.push_back(p1);
	v.push_back(p2);
	v.push_back(p3);
	v.push_back(p4);

	//��Ա����������
	//���� mem_fun_ref ��Person�ڲ���Ա��������
	for_each(v.begin(), v.end(), mem_fun_ref(&Person::showPerson));
	for_each(v.begin(), v.end(), mem_fun_ref(&Person::plusAge));    //�����100
	for_each(v.begin(), v.end(), mem_fun_ref(&Person::showPerson));
}
/* Output:
��Ա�����У������� aaa ���䣺10
��Ա�����У������� bbb ���䣺15
��Ա�����У������� ccc ���䣺18
��Ա�����У������� ddd ���䣺40
��Ա�����У������� aaa ���䣺110
��Ա�����У������� bbb ���䣺115
��Ա�����У������� ccc ���䣺118
��Ա�����У������� ddd ���䣺140
*/


int main(){
	test01();
	cout << "---------------" << endl;
	test02();
	cout << "---------------" << endl;
	test03();
	cout << "---------------" << endl;
	test04();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
��������ʼֵ
5
v = 5 start = 0 v+start = 5
v = 5 start = 1 v+start = 6
v = 5 start = 2 v+start = 7
v = 5 start = 3 v+start = 8
v = 5 start = 4 v+start = 9
v = 5 start = 5 v+start = 10
v = 5 start = 6 v+start = 11
v = 5 start = 7 v+start = 12
v = 5 start = 8 v+start = 13
v = 5 start = 9 v+start = 14
---------------
�ҵ�С��5������Ϊ 0
---------------
100
101
102
103
104
105
106
107
108
109
---------------
��Ա�����У������� aaa ���䣺10
��Ա�����У������� bbb ���䣺15
��Ա�����У������� ccc ���䣺18
��Ա�����У������� ddd ���䣺40
��Ա�����У������� aaa ���䣺110
��Ա�����У������� bbb ���䣺115
��Ա�����У������� ccc ���䣺118
��Ա�����У������� ddd ���䣺140
�밴���������. . .
*/