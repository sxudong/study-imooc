#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

const double pi = 3.14;

// 1.���һ���࣬��Բ���ܳ�
//   �ܳ���ʽ  2 * pi * r
class Circle //class��������һ���� ������������������
{
public: //����Ȩ��
	//�뾶  ��Ա����
	int m_R;

	//���ð뾶�ĳ�Ա����
	//��Ա���� �����޸ĳ�Ա����
	void setR(int r){
		m_R = r;
	}

    //��Բ���ܳ�
	//��������д���� ���� ��Ա����
	double calculateZC(){
		return 2 * pi * m_R;
	}

};

void test01()
{
	//ͨ���� ������һ��Բ
	Circle c1; //Բ �����󣩣��൱��Java��new��һ������

	//c1.m_R = 10; //��������������а뾶�ĸ�ֵ
	//ͨ����Ա���� ��Ӹ�Բ���ð뾶
	c1.setR(10);

	//���c1���ܳ�
	cout << "c1���ܳ�Ϊ�� " << c1.calculateZC() << endl; //c1���ܳ�Ϊ�� 62.8
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}