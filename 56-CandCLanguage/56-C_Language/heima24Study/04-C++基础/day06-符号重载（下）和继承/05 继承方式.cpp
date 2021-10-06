#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/* Output:
6 继承方式
	6.1	不管公有继承 保护 还是私有 基类中的私有属性 ，都不可以继承下去
	6.2	公有继承
		6.2.1	父类中的protected 在子类中是 protected
		6.2.2	父类中的public 在子类中是 public
	6.3	保护继承
		6.3.1	父类中的protected 在子类中是 protected
		6.3.2	父类中的public 在子类中是 protected
	6.4	私有继承
		6.4.1	父类中的protected 在子类中是 private
		6.4.2	父类中的public 在子类中是 private
*/


class Base1
{
public:
	int m_A = 10;
protected:
	int m_B = 20;
private:
	int m_C = 30;
};

//公有继承
class Son1 : public Base1
{
public:
	void func()
	{
		//cout << m_C << endl; //基类中私有的属性 不可继承
		cout << m_A << endl;   //基类中公有的属性 可继承，还是“public”
		cout << m_B << endl;   //基类中保护的属性 可继承，还是“protected”类外访问不到
	}

};

void myFunc()
{
	Son1 s1;
	s1.m_A;
	//s1.m_B; //err 不能访问，继承下来依然是受保护的

	s1.func();
}

////////////////////////////////////////保护继承////////////////////////////////////////

class Base2
{
public:
	int m_A = 10;
protected:
	int m_B = 20;
private:
	int m_C = 30;
};

class Son2 : protected Base2
{
public:
	void func()
	{
		//cout << m_C << endl; //基类中“私有的属性” 不可继承
		cout << m_A << endl;   //基类中“公有的属性” 可继承，还是“protected”
		cout << m_B << endl;   //基类中“保护的属性” 可继承，还是“protected”
	}

};
void myFunc2()
{
	Son2 s;
	//s.m_A; //err 不可访问，继续下来变成“受保护的”
	//s.m_B; //err 不可访问，继续下来依然“受保护的”

	s.func();
}


////////////////////////////////////////私有继承////////////////////////////////////////
class Base3
{
public:
	int m_A = 10;
protected:
	int m_B = 20;
private:
	int m_C = 30;
};

class Son3 : private Base3
{
public:
	void func()
	{
		//cout << m_C << endl; //基类中“私有的属性” 不可继承
		cout << m_A << endl;   //基类中“公有的属性” 可继承，还是“private”
		cout << m_B << endl;   //基类中“保护的属性” 可继承，还是“private”
	}

};

class GrandSon3 : public Son3
{
public:
	void myFunc()
	{
		//cout << m_A << endl; //err 孙子类中 访问不到 m_A，因为在Son3中m_A已经是私有属性了
	}
};


int main(){
	myFunc();
	cout << "------------------" << endl;
	myFunc2();

	Son3 son3;
	//son3.m_A; //err 不可访问，继承下来变成“私有属性”
	//son3.m_B; //err 不可访问，继承下来变成“私有属性”
	//son3.m_C; //err 不可访问，不可继承 “私有属性”

	system("pause");
	return EXIT_SUCCESS;
}