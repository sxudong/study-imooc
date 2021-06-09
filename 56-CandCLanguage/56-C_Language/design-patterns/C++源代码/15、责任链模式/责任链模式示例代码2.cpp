#include <iostream>
using namespace std;
#include <string>

// ����Ʊ��
class Bill
{
public:
	Bill(){}
	Bill(int iId, string iName, double iAccount){
		id = iId;
		name = iName;
		account = iAccount;
	}
	double getAccount(){
		return this->account;
	}
	void print(){
		printf("\nID:\t%d\n", id);
		printf("Name:\t%s\n", name.c_str());
		printf("Account:\t%f\n", account);
	}
private:
	int id;
	string name;
	double account;
};
// ��������
class Approver
{
public:
	Approver(){}
	Approver(string iName){
		setName(iName);
	}
	// ����ϼ�
	void setSuperior(Approver *iSuperior){
		this->superior = iSuperior;
	}
	// ��������
	virtual void handleRequest(Bill*) = 0;
	string getName(){
		return name;
	}
	void setName(string iName){
		name = iName;
	}
protected:
	Approver *superior;
private:
	string name;
};
// ���崦���ߣ��鳤
class GroupLeader :public Approver
{
public:
	GroupLeader(){}
	GroupLeader(string iName){
		setName(iName);
	}
	// ��������
	void handleRequest(Bill *bill){
		if (bill->getAccount() < 10){
			printf("�鳤 %s �����˸�Ʊ�ݣ�Ʊ����Ϣ��", this->getName().c_str());
			bill->print();
		}
		else{
			printf("�鳤��Ȩ����ת���ϼ�����\n");
			this->superior->handleRequest(bill);
		}
	}
};
// ���崦���ߣ�����
class Head :public Approver
{
public:
	Head(){}
	Head(string iName){
		setName(iName);
	}
	// ��������
	void handleRequest(Bill *bill){
		if (bill->getAccount() >= 10 && bill->getAccount()<30){
			printf("���� %s �����˸�Ʊ�ݣ�Ʊ����Ϣ��", this->getName().c_str());
			bill->print();
		}
		else{
			printf("������Ȩ����ת���ϼ�����\n");
			this->superior->handleRequest(bill);
		}
	}
};
// ���崦���ߣ�����
class Manager :public Approver
{
public:
	Manager(){}
	Manager(string iName){
		setName(iName);
	}
	// ��������
	void handleRequest(Bill *bill){
		if (bill->getAccount() >= 30 && bill->getAccount()<60){
			printf("���� %s �����˸�Ʊ�ݣ�Ʊ����Ϣ��", this->getName().c_str());
			bill->print();
		}
		else{
			printf("������Ȩ����ת���ϼ�����\n");
			this->superior->handleRequest(bill);
		}
	}
};
// ���崦���ߣ��ϰ�
class Boss :public Approver
{
public:
	Boss(){}
	Boss(string iName){
		setName(iName);
	}
	// ��������
	void handleRequest(Bill *bill){
		printf("�ϰ� %s �����˸�Ʊ�ݣ�Ʊ����Ϣ��", this->getName().c_str());
		bill->print();
	}
};

int main()
{
	// �������ߣ��鳤�����磬���ܣ��ϰ�
	Approver *zuzhang, *bingge, *chunzong, *laoban;

	zuzhang = new GroupLeader("����");
	bingge = new Head("����");
	chunzong = new Manager("����");
	laoban = new Boss("���ϰ�");

	zuzhang->setSuperior(bingge);
	bingge->setSuperior(chunzong);
	chunzong->setSuperior(laoban);

	// ����������
	Bill *bill1 = new Bill(1, "Jungle", 8);
	Bill *bill2 = new Bill(2, "Lucy", 14.4);
	Bill *bill3 = new Bill(3, "Jack", 32.9);
	Bill *bill4 = new Bill(4, "Tom", 89);

	// ȫ���Ƚ����鳤����
	zuzhang->handleRequest(bill1); printf("\n");
	zuzhang->handleRequest(bill2); printf("\n");
	zuzhang->handleRequest(bill3); printf("\n");
	zuzhang->handleRequest(bill4);

	printf("\n\n");
	system("pause");
	return 0;
}
