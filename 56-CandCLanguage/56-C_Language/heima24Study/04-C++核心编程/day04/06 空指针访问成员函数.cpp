#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
6 ��ָ����ʳ�Ա����
	6.1	�����Ա����û���õ�this����ô��ָ�����ֱ�ӷ���
	6.2	�����Ա�����õ�thisָ�룬��Ҫע�⣬���Լ�if�жϣ����thisΪNULL��return
*/


class Person
{
public:

	void show()
	{
		cout << "Person show" << endl;
	}

	void showAge() //void showAge(Person * this)
	{
		//��ֹ��ָ��ȥ���ʳ�Ա��������������ҵ�
		if (this == NULL)
			return;

		cout << this->m_Age << endl; // NULL -> m_Age
	}

	int m_Age;
};

void test01()
{
	Person * p = NULL;
	p->show();    //Person show
	p->showAge(); //this == NULL �����ˣ�û�д�ӡ��
}

int main(){
	test01();

	system("pause");
	return EXIT_SUCCESS;
}