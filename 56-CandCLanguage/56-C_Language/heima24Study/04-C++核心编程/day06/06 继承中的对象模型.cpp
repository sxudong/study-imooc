#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
7 �̳��еĶ���ģ��
	7.1	�����̳и��������е����� �������� ˽������
	7.2	ֻ�����Ƿ��ʲ�������������������
	7.3	cl /d1 reportSingleClassLayout���� �ļ���
*/


class Base
{
public:
	int m_A;
protected:
	int m_B;
private:
	int m_C;
};

/*
* ������ ��̳и����˽�г�Ա��ֻ�Ǳ�������������������ʲ���˽�г�Ա
*/
class Son : public Base
{
public:
	int m_D;
};

void test01()
{
	cout << sizeof(Son) << endl; //16

}

int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}