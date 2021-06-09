/*
�����类�������Ҫ����
�Ա�����������������꣩���������
�ͻ���ͨ���������������顣
*/

#include <iostream>
using namespace std;

/*
subject�����������ɫ����
��ʵ�������������Ĺ�ͬ�ӿڡ�
RealSubject����ʵ�����ɫ����
�����˴����ɫ���������ʵ����
Proxy�����������ɫ����
���ж���ʵ�����ɫ�����ã������ɫͨ���ڽ��ͻ��˵��ô��ݸ������������֮ǰ����֮��ִ��ĳЩ�����������ǵ���������ʵ�Ķ���

��ʾ��a�а���b�ࣻa��b��ʵ��Э����protocol

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
		cout << "ʵ�������....\n";
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
		cout << "Double11 ���� ���" << endl;
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
		cout << "Double11 ���� ���" << endl;
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
