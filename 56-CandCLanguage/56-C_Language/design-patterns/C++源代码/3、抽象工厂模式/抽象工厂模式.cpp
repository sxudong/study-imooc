#include <iostream>
using namespace std;

// 抽象水果
class Fruit
{
public:
	virtual void sayName() = 0;
};

// 抽象工厂
class AbstractFactory
{
public:
	virtual Fruit * createBanana() = 0;
	virtual Fruit * createApple() = 0;
};




class NorthBanana : public Fruit
{
public:
	void sayName(){
		cout << "我是北方香蕉" << endl;
	}
};

class NorthApple : public Fruit
{
public:
	void sayName(){
		cout << "我是北方苹果" << endl;
	}
};

class SouthBanana : public Fruit
{
public:
	void sayName(){
		cout << "我是南方香蕉" << endl;
	}
};

class SouthApple : public Fruit
{
public:
	void sayName(){
		cout << "我是南方苹果" << endl;
	}
};

//  北方工厂
class NorthFactory :  public AbstractFactory
{
public:
	Fruit *createBanana() {
		return new NorthBanana();
	}
	Fruit *createApple() {
		return new NorthApple();
	}
};

//  南方工厂
class SouthFactory : public  AbstractFactory
{
public:
	Fruit *createBanana() {
		return new SouthBanana();
	}
	Fruit *createApple() {
		return new SouthApple();
	}
};

int main(){

	Fruit * fr = nullptr;
	AbstractFactory *af = nullptr;
	
	// 对南方工厂的调用输出
	af = new SouthFactory();
	fr = af->createApple();
	fr->sayName();
	fr = af->createBanana();
	fr->sayName();

	// 对北方工厂多调用输出
	af = new NorthFactory();
	fr = af->createApple();
	fr->sayName();
	fr = af->createBanana();
	fr->sayName();

	delete fr;
	delete af;

	system("pause");
	return 0;
}