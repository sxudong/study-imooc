#include <iostream>
using namespace std;

// ����ˮ��
class Fruit
{
public:
	virtual void sayName() = 0;
};

// ���󹤳�
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
		cout << "���Ǳ����㽶" << endl;
	}
};

class NorthApple : public Fruit
{
public:
	void sayName(){
		cout << "���Ǳ���ƻ��" << endl;
	}
};

class SouthBanana : public Fruit
{
public:
	void sayName(){
		cout << "�����Ϸ��㽶" << endl;
	}
};

class SouthApple : public Fruit
{
public:
	void sayName(){
		cout << "�����Ϸ�ƻ��" << endl;
	}
};

//  ��������
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

//  �Ϸ�����
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
	
	// ���Ϸ������ĵ������
	af = new SouthFactory();
	fr = af->createApple();
	fr->sayName();
	fr = af->createBanana();
	fr->sayName();

	// �Ա���������������
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