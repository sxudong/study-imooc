#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
2 ����ģʽ���� �C ��ϯ
	2.1	Ŀ�� Ϊ��������ֻ��һ��ʵ����ʵ������Ҫ�Լ��ͷ�
	2.2	�� Ĭ�Ϲ���  �� �������� ˽�л�
	2.3	�ڲ�ά��һ�� ����ָ��
	2.4	˽�л�Ψһָ��
	2.5	�����ṩ getInstance�������������ָ��
*/


/*
* ������ϯ��
* ����:����ģʽ  Ϊ�˴������еĶ��󣬲��ұ�ֻ֤��һ������ʵ��
*/
class ChairMan
{
//1.���캯�� ����˽�л�
private:
	ChairMan()
	{
		cout << "����������ϯ" << endl;
	}
	//�������� ˽�л�
	ChairMan(const ChairMan &c)
	{}

public:
	//�ṩ��get������������ϯ,��ȡʵ����
	static ChairMan* getInstance()
	{
		return singleMan;
	}

//public:
private:
	static ChairMan * singleMan; //˽�о�̬��Ա����������

};
ChairMan * ChairMan::singleMan = new ChairMan; //��̬��Ա����ʵ����

void test01()
{
	//������˽�л����������ⲿ������������ǾͲ��ǵ��������ˡ�
	/*
	ChairMan c1; //ջ�ϴ���
	ChairMan * c2 = new ChairMan; //���ϴ���
	ChairMan * c3 = new ChairMan;
	*/

	//singleMan˽�л����������ⲿ����޸�
	/*
	ChairMan * cm = ChairMan::singleMan; //err
	ChairMan * cm2 = ChairMan::singleMan;
	*/
	//ChairMan::singleMan = NULL; //˽�о�̬��ԱҲ���ܸ�ֵ


	ChairMan * cm1 = ChairMan::getInstance();
	ChairMan * cm2 = ChairMan::getInstance();

	if (cm1 == cm2)
		cout << "cm1 �� cm2��ͬ" << endl; //cm1 �� cm2��ͬ
	else
		cout << "cm1 �� cm2����ͬ" << endl;

	//�������캯��˽�л�����ֹ�ⲿ����
	/*
	ChairMan * cm3 = new ChairMan(*cm2); //err  ���캯����˽�л���,���ܴ�������
	if (cm3 == cm2)
		cout << "cm3 �� cm2��ͬ" << endl;
	else
		cout << "cm3 �� cm2����ͬ" << endl;
    */

}

int main(){

	//��������ϯ���ڱ���׶ξ��Ѿ������˶���
	cout << "main����" << endl; //��ϯ��������main����
	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
����������ϯ
main����
cm1 �� cm2��ͬ
�밴���������. . .
*/