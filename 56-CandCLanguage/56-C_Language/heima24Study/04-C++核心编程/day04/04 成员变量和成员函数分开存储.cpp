#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
4 C++����ģ�ͳ�̽
	4.1	��Ա�����ͳ�Ա�����Ƿֿ��洢��
	4.2	����Ĵ�С 1
	4.3	ֻ�зǾ�̬��Ա���Բ����ڶ�������
*/


class Person
{
public:
	/*
	* ���ۣ��Ǿ�̬��Ա�����������ڶ������ϡ�
	*/
	int m_A;                //�Ǿ�̬��Ա���������ڶ�������   4���ֽ�
	//void func(Person* this) {}; �������ڵ�func()ʱ��͵͵���ϡ�Person* this��������������ͨ��Ա�������涼�����ôһ��ָ�롣
	void func() {};        //�Ǿ�̬��Ա�����������ڶ�������
	static int m_B;         //��̬��Ա�����������ڶ�������
	static void  func2() {}; //��̬��Ա�����������ڶ�������
	double m_C;             //ռ16���ֽ�                     8���ֽ�   ʹ��#pragma pack(1)�޸Ķ��뷽ʽΪ1���ֽڣ���ӡ����12���ֽ���
};


void test01()
{
	//Person����Ĵ�СΪ��1����ÿ����ʵ���Ķ��󡱶��ж�һ�޶��ĵ�ַ��charά�������ַ��
	cout << "sizo of (Person) = " << sizeof(Person) << endl; //sizo of (Person) = 16

	// Person p[10]  p[0] p[1] //ÿ����ʵ���Ķ��󡱶��ж�һ�޶��ĵ�ַ
}


void test02()
{
	/*
	* ��thisָ�롱ָ�򱻵��õĳ�Ա���������Ķ���
	*/

	Person p1;
	p1.func(); //��������͵͵����һ����thisָ�롱Person * const this

	Person p2;
	p2.func(); //�൱�ڰ�p2��ָ����Ϊ�����ӽ�func()�У�Person * this �����this��ָ��p2��˵����˭������this��ָ��˭��
}

int main() {
	test01();

	system("pause");
	return EXIT_SUCCESS;
}