#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
7 指针的引用
    7.1	用一级指针引用 可以代替二级指针
*/


struct Person
{
	int m_Age;
};

void allocatMemory(Person ** p) // **p 具体的Person对象  *p 对象的指针   p 指针的指针
{
	*p = (Person *) malloc(sizeof(Person));

	(*p)->m_Age = 100;
}

void test01()
{
	Person * p = NULL;
	allocatMemory(&p);
	cout <<  "p的年龄： " <<p->m_Age << endl; //p的年龄： 100
}


/*
* 利用指针引用开辟空间
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
	cout << "p的年龄：" << p->m_Age << endl; //p的年龄：1000
}


int main(){

	test01();
	cout << "--------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/*
p的年龄： 100
--------------
p的年龄：1000
请按任意键继续. . .
*/