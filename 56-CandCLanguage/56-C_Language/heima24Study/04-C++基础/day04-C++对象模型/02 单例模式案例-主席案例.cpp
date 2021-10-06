#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
2 单例模式案例 – 主席
	2.1	目的 为了让类中只有一个实例，实例不需要自己释放
	2.2	将 默认构造  和 拷贝构造 私有化
	2.3	内部维护一个 对象指针
	2.4	私有化唯一指针
	2.5	对外提供 getInstance方法来访问这个指针
*/


/*
* 创建主席类
* 需求:单例模式  为了创建类中的对象，并且保证只有一个对象实例
*/
class ChairMan
{
//1.构造函数 进行私有化
private:
	ChairMan()
	{
		cout << "创建国家主席" << endl;
	}
	//拷贝构造 私有化
	ChairMan(const ChairMan &c)
	{}

public:
	//提供“get方法”访问主席,获取实例。
	static ChairMan* getInstance()
	{
		return singleMan;
	}

//public:
private:
	static ChairMan * singleMan; //私有静态成员，类内声明

};
ChairMan * ChairMan::singleMan = new ChairMan; //静态成员类外实例化

void test01()
{
	//构造器私有化，不能让外部创建多个对象，那就不是单例对象了。
	/*
	ChairMan c1; //栈上创建
	ChairMan * c2 = new ChairMan; //堆上创建
	ChairMan * c3 = new ChairMan;
	*/

	//singleMan私有化，不能让外部随便修改
	/*
	ChairMan * cm = ChairMan::singleMan; //err
	ChairMan * cm2 = ChairMan::singleMan;
	*/
	//ChairMan::singleMan = NULL; //私有静态成员也不能赋值


	ChairMan * cm1 = ChairMan::getInstance();
	ChairMan * cm2 = ChairMan::getInstance();

	if (cm1 == cm2)
		cout << "cm1 与 cm2相同" << endl; //cm1 与 cm2相同
	else
		cout << "cm1 与 cm2不相同" << endl;

	//拷贝构造函数私有化，防止外部拷贝
	/*
	ChairMan * cm3 = new ChairMan(*cm2); //err  构造函数是私有化的,不能创建对象
	if (cm3 == cm2)
		cout << "cm3 与 cm2相同" << endl;
	else
		cout << "cm3 与 cm2不相同" << endl;
    */

}

int main(){

	//“国家主席”在编译阶段就已经创建了对象
	cout << "main调用" << endl; //主席创建先于main调用
	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
创建国家主席
main调用
cm1 与 cm2相同
请按任意键继续. . .
*/