#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;



/*
1 类型转换
	1.1	静态转换 static_cast
	1.2	使用方式  static_cast<目标类型>（原始数据）
	1.3	可以进行基础数据类型转换
	1.4	父与子类型转换
	1.5	没有父子关系的自定义类型不可以转换
	1.6	动态转换 dynamic_cast
	1.7	不可以转换基础数据类型
	1.8	父子之间可以转换
		1.8.1 父转子 不可以
		1.8.2 子转父 可以
		1.8.3 发生多态 都可以
	1.9	常量转换 const_cast
	1.10 不能对非指针或者非引用进行转换
	1.11 重新解释转换 reinterpret_cast
		1.11.1	最不安全，最鸡肋 不推荐
*/



/*
* 静态转换 static_cast
* 基础类型
*
* static_cast使用：static_cast<目标类型>(原始对象)
*/
void test01()
{
	char a = 'a';

	//把一个char类型转换为double类型
	//“尖括号<>”里面写要转变的类型
	double d = static_cast<double>(a);

	cout << "d = " << d <<endl; // d = 97
}

/*
* 静态转换 static_cast —— 父子之间转换
*/
class Base{};
class Child : public Base{};
class Other{};

void test02()
{
	Base * base = NULL;
	Child * child = NULL;

	//把 base 转为 Child* 类型 向下 不安全
	Child * child2 = static_cast<Child*>(base);

	//把child 转为 Base*  向上  安全
	Base * base2 = static_cast<Base*>(child);

	//转other类型 转换无效，它们之间没有父子关系到。
	//Other * other = static_cast<Other*>(base);
}



/*
* 动态转换 dynamic_cast
* 在进行下行转换时，dynamic_cast 具有类型检查的功能，比static_cast更安全；
*/
void test03()
{
	//基础类型不可以转换
	char c = 'a';

	//dynamic_cast非常严格，“失去精度”或者不安全都不可以转换
	//double d = dynamic_cast<double>(c);

}

class Base2
{
	virtual void func(){};
};

class Child2 : public Base2
{
	virtual void func(){};
};

class Other2{};

void test04()
{
	Base2 * base = NULL;
	Child2 * child = NULL;

	// base 转 Child2 * 不安全
	//Child2 * child2 = dynamic_cast<Child2*>(base);

	// child 转 Base2 *  安全
	Base2* base2 = dynamic_cast<Base2*>(child);

	//发生多态的情况
	// dynamic_cast 如果发生了多态，那么可以让基类转为派生类，向下转换
	Base2 * base3 = new Child2; //父类指向子类
	Child2 * child3 = dynamic_cast<Child2*>(base3); //父类指向子类转子类
}


/*
* 常量转换  const_cast
*/
void test05()
{
	/*
	* 指针
	*/
	const int * p = NULL;
	int * newp = const_cast<int *>(p); //取出const

	int * p2 = NULL;
	const int * newP2 = const_cast<const int *>(p2);


	//不能对“非指针”或“非引用”的变量进行转换
	//const int a = 10;
	//int b = const_cast<int>(a);

	/*
	* 引用
	*/
	int num = 10;
	int &numRef = num;

	const int &numRef2 = static_cast<const int &>(numRef);
}

/*
* 重新解释转换  reinterpret_cast
* 基本百分之百用不到它。
*/
void test06()
{
	int a = 10;
	int * p = reinterpret_cast<int *>(a);

	Base * base = NULL;
	Other * other = reinterpret_cast<Other*>(base);

	//最不安全 ，不推荐
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}