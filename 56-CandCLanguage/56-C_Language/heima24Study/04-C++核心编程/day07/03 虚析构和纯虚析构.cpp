#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
5 虚析构和纯虚析构
	5.1	虚析构
		5.1.1 virtual ~类名() {}
		5.1.2 解决问题： 通过父类指针指向子类对象释放时候不干净导致的问题
	5.2	纯虚析构函数
		5.2.1 写法  virtual ~类名() = 0
		5.2.2 类内声明  类外实现
		5.2.3 如果出现了纯虚析构函数，这个类也算抽象类，不可以实例化对象
*/


class Animal
{
public:

	virtual void speak(){
		cout << "动物在说话" << endl;
	}

	/*
	* “普通析构”是不会调用子类的析构的，所以可能会导致释放不干净，
	* 利用“虚析构”来解决这个问题。
	*/

	/*
	* 虚析构
	*/
	//virtual ~Animal()
	//{
	//	cout << "Animal的析构调用" << endl;
	//}


	/*
	* 纯虚析构
	*
	* 纯虚析构，需要声明，还需要实现，类内声明，类外实现。
	* 如果函数中出现了 纯虚析构函数，那么这个类也算抽象类。抽象类 -> 不可实例化对象。
	*/
	virtual ~Animal() = 0;
};

/*
* “纯虚析构函数”实现
*/
Animal::~Animal()
{
	cout << "Animal的纯虚析构调用" << endl;
}


void func()
{
    //如果出现纯虚析构，类也算抽象类，不能实例化对象
	//Animal an;                     //err
	//Animal * animal = new Animal;  //err
}


class Cat : public Animal
{
public:
	char* m_Name;

	//构造函数
	Cat(const char * name){
		this->m_Name = new char[strlen(name) + 1]; //开辟堆空间
		strcpy(this->m_Name, name);                //复制值
	}

	virtual void speak(){
		cout << "小猫在说话" << endl;
	}

	~Cat(){
		cout << "Cat的析构调用" << endl;
		if (this->m_Name != NULL){
			delete[] this->m_Name; //释放堆内存
			this->m_Name = NULL;   //指向空指针
		}
	}
};


void test01()
{
	Animal * animal = new Cat("TOM");
	animal->speak();

	delete animal; //析构animal
}


int main(){

	test01();

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
小猫在说话
Cat的析构调用
Animal的纯虚析构调用
请按任意键继续. . .
*/