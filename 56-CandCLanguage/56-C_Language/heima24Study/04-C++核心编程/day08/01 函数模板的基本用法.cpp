#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;



/*
1 ����ģ�����ʹ��
	1.1	template < class / typename  T> ���߱����������Ĵ��������T��Ҫ����
	1.2	mySwap(T & a  T & b) ����Ҳ��Ҫ���룬���Ͳ�����
	1.3	myswap��a, b�� �Զ������Ƶ�  ����a b������ ���滻T
	1.4	myswap<int>(a, b) ��ʾָ������
*/



/*
* ����int������������
*/
void mySwapInt( int & a, int & b)
{
	int tmp = a;
	a = b;
	b = tmp;
}

/*
* ����double����
*/
void mySwapDouble(double & a, double & b)
{
	double tmp = a;
	a = b;
	b = tmp;
}


/*
* ģ�弼�������Ͳ����������ͱ�̡�
*
* ���ͣ��߼��ַǳ�����
*/
template<class T> // ���߱���������������� T ��Ҫ����T��һ��ͨ�õ����ͣ�����Java�ķ��ͷ������������б�
void mySwap(T & a, T & b)
{
	T tmp = a;
	a = b;
	b = tmp;
}


/*
* template<typename T>  �ȼ��� template<class T>
* ����Ҫָ���� T �ſ���ʹ��
*/
template<typename T>
void mySwap2(T& a, T& b){
	T tmp = a;
	a = b;
	b = tmp;
}

void test01()
{
	int a = 10;
	int b = 20;
	char c1 = 'c';

	//mySwapInt(a, b);

	/*
	* 1 ���Զ������Ƶ��������в������Ͳſ����Ƶ�
	*/
	//mySwap(a, c1); //�Ƶ�������T�����Բ�������
	mySwap(a, b);

	/*
	* 2 ��ʾ�ġ�ָ�����͡�
	*   ָ�������ˣ����Ͳ���Ҫ�Ƶ��ˡ�
	*/
	mySwap<int>(a, b); //���÷��ͷ���

	cout << "a = " << a << endl; //10
	cout << "b = " << b << endl; //20

	double c = 3.14;
	double d = 1.1;
	//mySwapDouble(c, d);
	mySwap(c, d);     //���÷��ͷ���

	/*
	* ģ�����Ҫָ���� T �ſ���ʹ��
	* template<typename T>
	*/
	mySwap2<double>(c, d);

	cout << "c = " << c << endl; //3.14
	cout << "d = " << d << endl; //1.1
}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
a = 10
b = 20
c = 3.14
d = 1.1
�밴���������. . .
*/