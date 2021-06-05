#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
3 ǰ�� ���� ++ ���������
	3.1	�Լ�ʵ��int���� MyInteger
	3.2	�ڲ�ά����int����
	3.3	MyInteger myInt
	3.4	myInt++ ����  ++myInt  ǰ��
	3.5	����++����� operator++() ǰ��   operator++(int) ����
	3.6	ǰ������ ��++ �󷵻����� �������� �ȱ���סԭ��ֵ  �ڲ�++ ������ʱ����
	3.7	��ϰ  �Լ�ʵ�ֵݼ����������--
*/



class MyInteger
{
	friend ostream & operator<< (ostream & cout, MyInteger & myInt);

public:
	MyInteger()
	{
		m_Num = 0;
	};

	//ǰ��++ ����
	MyInteger & operator++()
	{
		this->m_Num++;
		return *this;
	}

	//����++ ����
	MyInteger operator++(int)
	{
		//�ȱ���Ŀǰ����
		MyInteger tmp = *this;
		m_Num++;
		return tmp;
	}

	int m_Num;
};

/*
* << �������غ���
* ��һ��������cout  �ڶ���������MyInteger
*/
ostream & operator<< ( ostream & cout ,MyInteger & myInt)
{
	cout << myInt.m_Num;
	return cout;
}

void test01()
{
	MyInteger myInt;
	// ǰ��++

	cout << ++(++myInt) << endl; //2   0 + 1 + 1 = 2
	cout << myInt << endl;       //2

	//����++
	cout << myInt++ << endl; //2
	cout << myInt << endl;   //3
}

int main(){

	test01();

	int a = 10;
	cout << ++(++a) << endl; //12
	cout << a << endl;       //12

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
2
2
2
3
12
12
�밴���������. . .
*/