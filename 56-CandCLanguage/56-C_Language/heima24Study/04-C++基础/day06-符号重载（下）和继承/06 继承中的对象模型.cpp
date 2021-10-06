#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
7 继承中的对象模型
	7.1	子类会继承父类中所有的内容 ，包括了 私有属性
	7.2	只是我们访问不到，编译器给隐藏了
	7.3	cl /d1 reportSingleClassLayout类名 文件名
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
* 子类中 会继承父类的私有成员，只是被编译给隐藏起来，访问不到私有成员
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