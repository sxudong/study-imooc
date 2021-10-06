#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
3 多态案例 – 计算器案例
	3.1	早期方法 是不利于扩展
	3.2	开发有原则《开闭原则》  --  对扩展开放,对修改关闭。
	3.3	利用多态实现 -> 利于后期扩展，结构性非常好，可读性高，效率比C语言稍微低，发生多态内部结构复杂。

4 抽象类 和 纯虚函数
	4.1	“纯虚函数”写法  virtual void func() = 0;
	4.2	抽象类型
	4.3	抽象类 不可以实例化对象
	4.4	如果类 继承了抽象类， 必须重写抽象类中的纯虚函数
*/



class Calculator
{
private:
	int val1;
	int val2;

public:

	void setv1(int v)
	{
		this->val1 = v;
	}

	void setv2(int v)
	{
		this->val2 = v;
	}

	int getResult(string oper)
	{
		if (oper == "+")
			return val1 + val2;
		else if (oper == "-")
			return val1 - val2;
	}
};

void test01()
{
	Calculator cal;
	cal.setv1(10);
	cal.setv2(10);
	cout << cal.getResult("+") << endl; //20
	cout << cal.getResult("-") << endl; //0
}


/*
* 真正的开发中，有个开发原则《开闭原则》：对扩展开放，对修改关闭。
*/



/*
* 利用多态实现计算器
*/
class abstractCalculator
{
public:
	int val1;
	int val2;

public:

	/*
	* 虚函数
	*/
	//virtual int getResult(){ return 0; };

	/*
	* 纯虚函数
	*
	* 如果父类中有了“纯虚函数”子类继承父类，就必须要实现 纯虚函数。类似 Java 中的 interface接口类
	* 如果父类中 有了“纯虚函数”，这个父类就无法实例化对象了。
	* 这个类有了纯虚函数，通常又称为“抽象类”
	*/
	virtual int getResult() = 0; //加“virtual”关键字，类似Java抽象类的 adstract 关键字

	void setv1(int v)
	{
		this->val1 = v;
	}

	void setv2(int v)
	{
		this->val2 = v;
	}
};

/*
* 如果父类中有了“纯虚函数 ”，子类继承 -> 父类，就必须要实现“纯虚函数”
*/
class A : public abstractCalculator
{
public:
	//实现父类的“虚拟函数”
	virtual int getResult() //“virtual”关键字可写可不写
	{
		return 0;
	}
};

/*
* 加法计算器
*/
class PlusCalculator : public abstractCalculator
{
public:
	//实现父类的“虚拟函数”
	virtual int getResult() //“virtual”关键字可写可不写
	{
		return val1 + val2;
	};
};


/*
* 减法计算器
*/
class SubCalculator : public abstractCalculator
{
public:
	//实现父类的“虚拟函数”
	virtual int getResult() //“virtual”关键字可写可不写
	{
		return val1 - val2;
	};
};


/*
* 乘法计算器
*/
class ChengCalculator :public abstractCalculator
{
public:
	//实现父类的“虚拟函数”
	virtual int getResult()
	{
		return val1 * val2;
	};

};


void test02()
{
	abstractCalculator * abc ;
	//加法计算器
	abc =  new PlusCalculator;

	abc->setv1(10);
	abc->setv2(20);

	cout << abc->getResult() << endl; //30

	delete abc; //析构abc

	//减法计算器
	abc = new SubCalculator;
	abc->setv1(10);
	abc->setv2(20);
	cout << abc->getResult() << endl; //-10

	delete abc; //析构abc

	//乘法计算器
	abc = new ChengCalculator;
	abc->setv1(10);
	abc->setv2(20);
	cout << abc->getResult() << endl; //200


	/*
	* 如果父类有了“纯虚函数”，不能实例化对象了。
	*/
	/* error
	abstractCalculator aaa;
	abstractCalculator * abc = new abstractCalculator;
	*/

}

int main(){

	test01();
	cout << "--------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
20
0
--------------
30
-10
200
请按任意键继续. . .
*/