#include <iostream>
using namespace std;

// ������
class Operation
{
public:
	double dNumberA;
	double dNumberB;

	virtual double getResult() = 0;
};

// �ӷ���
class AddOp : public Operation
{
public:
	virtual double getResult(){
		cout << "���Ǽӷ�";
		return dNumberA + dNumberB;
	}
};
// ������
class SubOp : public Operation
{
public:
	virtual double getResult(){
		cout << "���Ǽ���";
		return dNumberA - dNumberB;
	}
};
// �˷���
class MulOp : public Operation
{
public:
	virtual double getResult(){
		cout << "���ǳ˷�";
		return dNumberA * dNumberB;
	}
};
// ������
class DivOp : public Operation
{
public:
	virtual double getResult(){
		cout << "���ǳ���";
		return dNumberA / dNumberB;
	}
};

// ���㴴��������
class CalculatorFactory
{
public:
	// ��Ϊû�д�������ʹ�ã�����ֱ��ʹ�þ�̬��Ա
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