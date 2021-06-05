#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

struct Person
{
	int m_Age;
};

void allocatMemory(Person ** p) // **p �����Person����  *p �����ָ��   p ָ���ָ��
{
	*p = (Person *) malloc(sizeof(Person));

	(*p)->m_Age = 100;
}

void test01()
{
	Person * p = NULL;
	allocatMemory(&p);
	cout <<  "p�����䣺 " <<p->m_Age << endl; //p�����䣺 100
}


/*
* ����ָ�����ÿ��ٿռ�
*/
void allocatMemoryByRef(Person* &p)
{
	p = (Person*) malloc(sizeof(Person));
	p->m_Age = 1000;
}

void test02()
{
	Person * p = NULL;
	allocatMemoryByRef(p);
	cout << "p�����䣺" << p->m_Age << endl; //p�����䣺1000
}


int main(){

	test01();
	cout << "--------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/*
p�����䣺 100
--------------
p�����䣺1000
�밴���������. . .
*/