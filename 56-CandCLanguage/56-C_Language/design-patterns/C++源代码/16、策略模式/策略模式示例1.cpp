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
		cout << "Des ����" << endl;
	}
};

class AES : public Strategy
{
public:
	virtual void SymEncrypt()
	{
		cout << "AES ����" << endl;
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


//�㷨��ʵ�� �� �ͻ��˵�ʹ�� �����
//ʹ���㷨�仯������Ӱ��ͻ���
void main()
{
	/* �����Ͽ���ԭ��
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