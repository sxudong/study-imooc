#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
1 静态联编和动态联编
	1.1	多态分类
		1.1.1 静态多态 -> 函数重载
		1.1.2 动态多态 -> 虚函数（要有继承关系）
	1.2	静态联编
		1.2.1 地址早绑定，编译阶段绑定好地址
	1.3	动态联编
		1.3.1 地址晚绑定，运行时候绑定好地址
	1.4	多态
		1.4.1 “父类的引用”或指针指向“子类对象”

2 多态原理解析
	2.1	当父类中有了“虚函数”后，内部结构就发生了改变
	2.2	内部多了一个 vfprt
		2.2.1 virtual  function pointer 虚函数表指针
		2.2.2 指向 vftable  虚函数表
	2.3	父类中结构  vfptr     &Animal::speak
	2.4	子类中 进行继承 会继承 vfptr  vftable
	2.5	构造函数中 会将“虚函数表指针”指向自己的“虚函数表”
	2.6	如果发生了重写，会替换掉虚函数表中的原有的speak，改为 &Cat::speak
	2.7	深入剖析，内部到底如何调用
	2.8	((void(*)())  (*(int*)*(int*)animal))();
	2.9	猫吃鱼的函数调用（编译器的调用）
*/


/*
 Animal内部结构
   vfptr 内部有这么个指针
   virtual function pointer
   虚函数表指针
*/

/* 动物类
G:\VisualStudioWorkSpace> cl / d1 reportSingleClassLayoutAnimal test.cpp

class Animal    size(4) :
	+-- -
 0  | {vfptr}        //虚函数表指针
    + -- -

Animal::$vftable@ :  //虚函数表
	| &Animal_meta
	| 0
  0 | &Animal::speak
  1 | &Animal::eat

Animal::speak this adjustor: 0
Animal::eat this adjustor : 0
*/


class Animal
{
public:
    /*
    * 父类的“虚拟函数”
    */
	virtual void speak() //加“virtual”关键字，类似Java抽象类的 adstract 关键字
	{
		cout << "动物在说话" << endl;
	}

	virtual void eat()  //加“virtual”关键字
	{
		cout << "动物在吃饭" << endl;
	}

};

class Cat : public Animal
{
public:
	void speak()
	{
		cout << "小猫在说话" << endl;
	}

	void eat()
	{
		cout << "小猫在吃鱼" << endl;
	}
};



/*
* 调用 doSpeak ，speak 函数的地址早就绑定好了，早绑定 ——“静态联编”，编译阶段就确定好了地址。
* 如果想调用猫的speak，不能提前绑定好函数的地址了，所以需要在“运行时候”再去确定函数地址。
* “动态联编”写法 doSpeak 方法改为“虚函数”,在父类上声明虚函数，发生了多态。
* “父类的引用” 或者 指针指向“子类对象”。
*/
void doSpeak(Animal & animal) //Animal & animal = cat //“父类的引用”指向“子类”
{
	animal.speak();
}


/*
* 如果发生了继承的关系，编译器允许进行类型转换
*/
void test01()
{
	Cat cat;
	doSpeak(cat); //小猫在说话
}

/* 猫类
G:\VisualStudioWorkSpace> cl / d1 reportSingleClassLayoutCat test.cpp

class _s__CatchableType size(28) :
	+-- -
  0 | properties
  4 | pType
  8 | _PMD thisDisplacement
 20 | sizeOrOffset
 24 | copyFunction
	+ -- -

	class _s__CatchableTypeArray    size(4) :
	+-- -
  0 | nCatchableTypes
  4 | arrayOfCatchableTypes
	+ -- -

	class Cat       size(4) :
	+-- -
  0 | +-- - (base class Animal)
  0 | | {vfptr}    //虚函数表指针
	| +-- -
	+-- -

Cat::$vftable@:    //虚函数表
	| &Cat_meta
	| 0
  0 | &Cat::speak  //如果Cat重写speak，这里就会是父类的 &Animal::speak
  1 | &Cat::eat

Cat::speak this adjustor: 0
Cat::eat this adjustor : 0
*/

void test02()
{
	//cout << sizeof(Animal) << endl;
	//父类指针指向子类对象 多态
	Animal * animal = new Cat;

	//animal->speak(); //小猫在说话

	//根据上面Cat的“虚函数表”偏移找到“函数地址”
	// *(int*) *(int*) animal //函数地址
	((void(*)()) (*(int*) *(int*) animal))(); //这个不是给人看的，这个是机器内部操作的

	// *((int*) *(int*) animal + 1) //猫吃鱼的地址
	((void(*)()) (*((int*) *(int*) animal + 1)))();
}

int main(){

	test01();
	cout << "--------------" << endl;
	test02();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
小猫在说话
--------------
小猫在说话
小猫在吃鱼
请按任意键继续. . .
*/