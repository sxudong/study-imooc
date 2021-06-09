#include <iostream>
using namespace std;

// ˮ��������
class Fruit
{
public:
	virtual void sayname() = 0;
};

// �㽶ʵ����
class Banana : public Fruit
{
public:
	void sayname() {
		cout << "�����㽶" << endl;
	}
};

// ƻ��ʵ����
class Apple : public Fruit
{
public:
	void sayname() {
		cout << "����ƻ��" << endl;
	}
};
/**********************************************/
// ����²�Ʒ
class Peach : public Fruit
{
public:
	void sayname() {
		cout << "��������" << endl;
	}
};

// ���󹤳�
class AbFactory
{
public:
	virtual Fruit *createProduct() = 0;
};

// ����Ĺ���������˵�㽶����
class BanFactory : public AbFactory
{
public:
	Fruit *createProduct(){
		return new Banana();
	}
};
/********************************************/
// �����²�Ʒ��ͬʱҲҪ�����µĹ���
// ����Ĺ���������˵�㽶����
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

	// ���㽶
	af = new BanFactory();
	fr = af->createProduct();
	fr->sayname();

	// ���ϲ�������
	//AbFactory *af = new BanFactory();
	//Fruit *fr = af->createProduct();
	//fr->sayname();
	delete fr;
	delete af;


	// ������Ʒ���Ե���
	AbFactory *fp = new PeachFactory();
	Fruit *frp = fp->createProduct();
	frp->sayname();

	delete fp;
	delete frp;

	return 0;
}