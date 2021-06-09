#include<iostream>
using namespace std;

// ����ʽ
class Singelton{
private:
	Singelton(){	// ����ģʽ����ɫ���캯����private��
		cout<< "�������캯��"<<endl;
	}
public:
	static Singelton *getInstance(){
		if(mySig == nullptr){
			mySig = new Singelton();
		}
		return mySig;
	}
	static Singelton *freeInstance(){
		if(mySig != nullptr){
			delete mySig;
			mySig = nullptr; // ָ�뱻free�˺�ָ���ﻹ����ֵ�ģ���ʱ����Ұָ����
		}
		return mySig;
	}
protected:
private:
	static Singelton *mySig;	
};

Singelton* Singelton::mySig = nullptr;	// ��̬������ʼ��

int main(){
	Singelton *p1 = Singelton::getInstance();
	Singelton *p2 = Singelton::getInstance();
	if(p1 == p2){
		cout<< "��ͬһ������"<<endl;
	}else{
		cout<< "����ͬһ������"<<endl;
	}
	Singelton::freeInstance();

	return 0;
}