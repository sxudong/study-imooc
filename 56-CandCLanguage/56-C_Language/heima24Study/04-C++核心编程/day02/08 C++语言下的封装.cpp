#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;

/*
7 C++语言的封装
    7.1	将属性和行为作为一个整体，来表示生活中具体的事物
    7.2	有访问权限
    7.3	class 和struct唯一区别 默认权限不同
        7.3.1	class默认是private
        7.3.2	struct 默认是public
    7.4	public 是类内类外都可以访问到
    7.5	protected 类内可以，类外不可以
    7.6	private 类内可以，类外不可以
*/


struct Person
{
	char mName[64];
	int mAge;

	void PersonEat() //struct中可以有函数方法
	{
		cout <<  mName <<"吃人饭" << endl;
	}
};

struct Dog
{
	char mName[64];
	int mAge;

	void DogEat()
	{
		cout << mName << "吃狗粮" << endl;
	}
};

/*
* C++中的封装
    严格“类型转换检测”， 让“属性”和“行为”绑定到一起。
*   1 “属性”和“行为”作为一个整体来表示生活中的事物。
*   2 控制权限
*          public：公有权限
*       protected：保护权限
*         private：私有权限
*/
void test01()
{
	Person p1;
	strcpy(p1.mName, "老王");
	p1.PersonEat(); //老王吃人饭

	Dog p2;
	strcpy(p2.mName, "大黄");
	p2.DogEat(); //大黄吃狗粮
}



/*
* struct 和 class 是一个意思
* 唯一的不同：默认权限 ，struct是“public”，但是class默认权限是“private”。
*/
class Animal
{
private:
	int mAge;
	//如果我不声明权限，默认的权限是 private
	void eat(){
		mAge = 100;
	};

public: //如果不标注为public，默认是private
	int mHeight;

protected: //保护权限 类内部可以访问 ，(当前类的子类可以访问) , 类外部不可以访问
	int mWeight;

	void setWeight(){
		mWeight = 100;
	};
};

/*
* 所谓私有权限 就是私有成员(属性、函数) 在类内部可以访问，类外部不可以方法
* 公共权限 ，在类内部和类外部都可以访问
*/
void test02()
{
	Animal an;
	//an.eat(); //err 私有方法
	//an.mAge;  //err 私有属性不可以访问到

	an.mHeight = 100; //公有权限在类外部可以访问到
	cout << an.mHeight << endl; //100

	//an.mWeight = 100; //err 保护权限 在类外不可访问到
}


/*
* public    类内 类外 都可以访问
* protected 类内可以访问 类外 不可以访问 （子类可以方法）
* private   类内可以访问 类外 不可以访问  （子类不可以方法）
*/


struct Pig
{
private:
	int mAge;
	//如果我不声明权限，默认的权限是 private
	void eat() {
		mAge = 100;
	};

	//公共权限
public:
	char name[64];
	int age;

	void PigEat()
	{
		printf("%s在吃杂粮\n", name);
	}

};

void test03() {
	Pig p;
	strcpy(p.name, "天蓬元帅");
	p.PigEat(); //天蓬元帅在吃杂粮

	//p.eat();  //err  私有方法不可以调用
}

int main(){
	test01();
	test02();
	test03();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
老王吃人饭
大黄吃狗粮
100
天蓬元帅在吃杂粮
请按任意键继续. . .
*/