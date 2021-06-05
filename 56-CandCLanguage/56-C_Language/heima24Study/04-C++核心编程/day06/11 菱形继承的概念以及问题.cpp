#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
12 ���μ̳������Լ����
	12.1 ����������������
	12.2 sheepTuo �ڲ��ṹ
		12.2.1 vbptr �����ָ��
		12.2.2 ָ��һ�� ������
		12.2.3 ͨ�����ҵ�ƫ����
		12.2.4 �ҵ����е�����
	12.3 �ڲ�����ԭ�� �����Բ����գ�
	    cl /d1 reportSingleClassLayoutSheepTuo test.cpp
*/


class Animal
{
public:
	int m_Age;
};

//����� Sheep (����)
class Sheep : virtual public Animal //�ӹؼ���virtual��䡰����ࡱ
{
};

//����� Tuo (����)
class Tuo : virtual public Animal  //�ӹؼ���virtual��䡰����ࡱ
{
};

//������
class SheepTuo : public Sheep, public Tuo
{

};


/*
* ���μ̳еĽ������ ���� ���á���̳С�
* ʹ�á���̳С��������ǡ�����ġ�һ�����ݣ�ֻ��һ��m_Age��
*/
void test01()
{
	SheepTuo st;
	st.Sheep::m_Age = 10;
	st.Tuo::m_Age = 20;

	cout << st.Sheep::m_Age << endl; //20
	cout << st.Tuo::m_Age << endl;   //20

	//����ֱ�ӷ��ʣ�ԭ���Ѿ�û�ж����ԵĿ����ˣ�ֻ��һ�� m_Age
	cout << st.m_Age << endl;        //20
}

//ͨ����ַ �ҵ� ƫ����
//�ڲ�����ԭ��
void test02()
{
	SheepTuo st;
	st.m_Age = 100;

    //��Ҫ������������ڲ�����ԭ��.png"ͼ����
    //�ο���C������ߡ�day02 06-ָ��ļ�Ӹ�ֵ.c
	cout << &st << endl;                               //st�ĵ�ַ 0
	cout << (int*) &st << endl;                        //ת��Ϊint *���ı����Ĳ������ҵ� 0 Sheep
	cout << *((int*) &st) << endl;                     //��*����ȡ��ʱ���ֵ Sheep�����
	cout << (int*) *(int*) &st<< endl;                 //���Ĳ����Ƕ���أ�����Ҫ��������int *
	cout << (int*) *(int*) &st + 1 << endl;            //��һ��1,����ƫ�Ƶ��������2��λ��
	cout << (int*) ((int*) *(int*) &st + 1) << endl;   //��1֮������������������㻹��Ҫ����ǿתΪint *
	cout << *(int*) ((int*) *(int*) &st + 1) << endl;  //�ټ� * ��ȡ��ֵ 8 �ˡ�

	//�ҵ�Sheep���򣩵�ƫ��������
	cout << *(int *)((int *)*(int *)&st + 1) << endl;  //8

	//�ҵ�Tuo���գ���ƫ����
	//(int*) &st        //�ҵ�0
	//(int*) &st + 1    //�ҵ�4 Tuo
	//*((int*) &st + 1) //��*����ȡ�������ֵTuo�����
	cout << *((int *)((int *)*((int *)&st + 1) + 1)) << endl; //4

	//���Age �������ҵ� m_Age��
	//(char *) &st  //����1��
	//(char *) &st + *(int *)((int *)*(int *) &st + 1)   //�������ƫ���� 8 ������0���λ�üӵ� 8��
	//((char *) &st + *(int *)((int *)*(int *) &st + 1)) //������
	//(Animal*) ((char *) &st + *(int *)((int *)*(int *) &st + 1))   //ǿתΪ(Animal*)
	//((Animal*) ((char *) &st + *(int *)((int *)*(int *) &st + 1))) //��������
	cout << ((Animal*)((char *)&st + *(int*)((int*)*(int *)&st + 1)))->m_Age << endl; //100

}

int main(){

	test01();
	cout << "----------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
20
20
----------------
00D8F7A0
00D8F7A0
3316528
00329B30
00329B34
00329B34
8
8
4
100
�밴���������. . .
*/