/*
出版社被代理对象，要卖书
淘宝、当当网（网上书店），代理对象
客户端通过当当网进行买书。
*/

#include <iostream>
using namespace std;

/*
subject（抽象主题角色）：
真实主题与代理主题的共同接口。
RealSubject（真实主题角色）：
定义了代理角色所代表的真实对象。
Proxy（代理主题角色）：
含有对真实主题角色的引用，代理角色通常在将客户端调用传递给真是主题对象之前或者之后执行某些操作，而不是单纯返回真实的对象。

提示：a中包含b类；a、b类实现协议类protocol

*/

class  Subject
{
public:
	virtual void SaleBook() = 0;
protected:
private:
};


class  RealSubject : public Subject
{
public:
	virtual void SaleBook()
	{
		cout << "实体店买书....\n";
	}
protected:
private:
};

class  ProxyTaoBao : public Subject
{
public:
	virtual void SaleBook()
	{
		//
		Double11();
		RealSubject rs;
		rs.SaleBook();
		Double11();
	}
	void Double11()
	{
		cout << "Double11 打折 半价" << endl;
	}
protected:
private:
};


class  ProxyTaoBao2 : public Subject
{
public:
	void SetRealSubject(RealSubject *rs)
	{
		m_s = rs;
	}
	virtual void SaleBook()
	{
		Double11();
		m_s->SaleBook();
	}
	void Double11()
	{
		cout << "Double11 打折 半价" << endl;
	}
protected:
private:
	RealSubject *m_s;
};

void main()
{
	ProxyTaoBao *ptb = new ProxyTaoBao;
	ptb->SaleBook();
	delete ptb;
	return;
}
