#include <iostream>
using namespace std;

// 水果抽象类
class Fruit
{
public:
	virtual void sayname() = 0;
};

// 香蕉实例类
class Banana : public Fruit
{
public:
	void sayname() {
		cout << "我是香蕉" << endl;
	}
};

// 苹果实例类
class Apple : public Fruit
{
public:
	void sayname() {
		cout << "我是苹果" << endl;
	}
};
/**********************************************/
// 添加新产品
class Peach : public Fruit
{
public:
	void sayname() {
		cout << "我是桃子" << endl;
	}
};

// 抽象工厂
class AbFactory
{
public:
	virtual Fruit *createProduct() = 0;
};

// 具体的工厂，比如说香蕉工厂
class BanFactory : public AbFactory
{
public:
	Fruit *createProduct(){
		return new Banana();
	}
};
/********************************************/
// 增加新产品的同时也要增加新的工厂
// 具体的工厂，比如说香蕉工厂
class PeachFactory : public AbFactory
{
public:
	Fruit *createProduct(){
		return new Peach();
	}
};


int main(){
	AbFactory *af = nullptr;
	Fruit *fr = nullptr;

	// 吃香蕉
	af = new BanFactory();
	fr = af->createProduct();
	fr->sayname();

	// 以上操作等于
	//AbFactory *af = new BanFactory();
	//Fruit *fr = af->createProduct();
	//fr->sayname();
	delete fr;
	delete af;


	// 新增产品测试调用
	AbFactory *fp = new PeachFactory();
	Fruit *frp = fp->createProduct();
	frp->sayname();

	delete fp;
	delete frp;

	return 0;
}