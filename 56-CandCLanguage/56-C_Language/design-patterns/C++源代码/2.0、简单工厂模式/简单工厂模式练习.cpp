#include <iostream>
using namespace std;

// 抽象类
class Operation
{
public:
	double dNumberA;
	double dNumberB;

	virtual double getResult() = 0;
};

// 加法类
class AddOp : public Operation
{
public:
	virtual double getResult(){
		cout << "这是加法";
		return dNumberA + dNumberB;
	}
};
// 减法类
class SubOp : public Operation
{
public:
	virtual double getResult(){
		cout << "这是减法";
		return dNumberA - dNumberB;
	}
};
// 乘法类
class MulOp : public Operation
{
public:
	virtual double getResult(){
		cout << "这是乘法";
		return dNumberA * dNumberB;
	}
};
// 除法类
class DivOp : public Operation
{
public:
	virtual double getResult(){
		cout << "这是除法";
		return dNumberA / dNumberB;
	}
};

// 运算创建工厂；
class CalculatorFactory
{
public:
	// 因为没有创建对象使用，所以直接使用静态成员
	static Operation *createOp(const char p){
		switch (p)
		{
		case '+':
			return new AddOp();
		case '-':
			return new SubOp();
		case '*':
			return new MulOp();
		case '/':
			return new DivOp();
		default:
			return nullptr;
			break;
		}
	}
};

void main()
{
	Operation *op = CalculatorFactory::createOp('*');
	op->dNumberA = 10;
	op->dNumberB = 20;
	cout << op->getResult() << endl;
	delete op;
	system("pause");
}