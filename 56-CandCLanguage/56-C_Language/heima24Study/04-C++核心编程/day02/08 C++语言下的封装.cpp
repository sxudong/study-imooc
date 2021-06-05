#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
7 C++���Եķ�װ
    7.1	�����Ժ���Ϊ��Ϊһ�����壬����ʾ�����о��������
    7.2	�з���Ȩ��
    7.3	class ��structΨһ���� Ĭ��Ȩ�޲�ͬ
        7.3.1	classĬ����private
        7.3.2	struct Ĭ����public
    7.4	public ���������ⶼ���Է��ʵ�
    7.5	protected ���ڿ��ԣ����ⲻ����
    7.6	private ���ڿ��ԣ����ⲻ����
*/


struct Person
{
	char mName[64];
	int mAge;

	void PersonEat() //struct�п����к�������
	{
		cout <<  mName <<"���˷�" << endl;
	}
};

struct Dog
{
	char mName[64];
	int mAge;

	void DogEat()
	{
		cout << mName << "�Թ���" << endl;
	}
};

/*
* C++�еķ�װ
    �ϸ�����ת����⡱�� �á����ԡ��͡���Ϊ���󶨵�һ��
*   1 �����ԡ��͡���Ϊ����Ϊһ����������ʾ�����е����
*   2 ����Ȩ��
*          public������Ȩ��
*       protected������Ȩ��
*         private��˽��Ȩ��
*/
void test01()
{
	Person p1;
	strcpy(p1.mName, "����");
	p1.PersonEat(); //�������˷�

	Dog p2;
	strcpy(p2.mName, "���");
	p2.DogEat(); //��ƳԹ���
}



/*
* struct �� class ��һ����˼
* Ψһ�Ĳ�ͬ��Ĭ��Ȩ�� ��struct�ǡ�public��������classĬ��Ȩ���ǡ�private����
*/
class Animal
{
private:
	int mAge;
	//����Ҳ�����Ȩ�ޣ�Ĭ�ϵ�Ȩ���� private
	void eat(){
		mAge = 100;
	};

public: //�������עΪpublic��Ĭ����private
	int mHeight;

protected: //����Ȩ�� ���ڲ����Է��� ��(��ǰ���������Է���) , ���ⲿ�����Է���
	int mWeight;

	void setWeight(){
		mWeight = 100;
	};
};

/*
* ��ν˽��Ȩ�� ����˽�г�Ա(���ԡ�����) �����ڲ����Է��ʣ����ⲿ�����Է���
* ����Ȩ�� �������ڲ������ⲿ�����Է���
*/
void test02()
{
	Animal an;
	//an.eat(); //err ˽�з���
	//an.mAge;  //err ˽�����Բ����Է��ʵ�

	an.mHeight = 100; //����Ȩ�������ⲿ���Է��ʵ�
	cout << an.mHeight << endl; //100

	//an.mWeight = 100; //err ����Ȩ�� �����ⲻ�ɷ��ʵ�
}


/*
* public    ���� ���� �����Է���
* protected ���ڿ��Է��� ���� �����Է��� ��������Է�����
* private   ���ڿ��Է��� ���� �����Է���  �����಻���Է�����
*/


struct Pig
{
private:
	int mAge;
	//����Ҳ�����Ȩ�ޣ�Ĭ�ϵ�Ȩ���� private
	void eat() {
		mAge = 100;
	};

	//����Ȩ��
public:
	char name[64];
	int age;

	void PigEat()
	{
		printf("%s�ڳ�����\n", name);
	}

};

void test03() {
	Pig p;
	strcpy(p.name, "����Ԫ˧");
	p.PigEat(); //����Ԫ˧�ڳ�����

	//p.eat();  //err  ˽�з��������Ե���
}

int main(){
	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
�������˷�
��ƳԹ���
100
����Ԫ˧�ڳ�����
�밴���������. . .
*/