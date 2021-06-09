#include <iostream>
using namespace std;

//Symmetric encryption
class Strategy
{
public:
	virtual void SymEncrypt() = 0;
};

class Des : public Strategy
{
public:
	virtual void SymEncrypt()
	{
		cout << "Des 加密" << endl;
	}
};

class AES : public Strategy
{
public:
	virtual void SymEncrypt()
	{
		cout << "AES 加密" << endl;
	}
};


class Context
{
public:
	Context(Strategy *strategy)
	{
		p = strategy;
	}
	void Operator()
	{
		p->SymEncrypt();
	}
private:
	Strategy *p;
};


//算法的实现 和 客户端的使用 解耦合
//使得算法变化，不会影响客户端
void main()
{
	/* 不符合开闭原则
	Strategy *strategy = NULL;
	strategy = new AES;
	strategy->SymEncrypt();
	delete strategy;

	strategy = new Des;
	strategy->SymEncrypt();
	delete strategy;
	*/
	Strategy *strategy = NULL;
	Context *ctx = NULL;

	strategy = new AES;
	ctx = new Context(strategy);
	ctx->Operator();
	delete strategy;
	delete ctx;

	cout << "hello..." << endl;
	system("pause");
	return;
}