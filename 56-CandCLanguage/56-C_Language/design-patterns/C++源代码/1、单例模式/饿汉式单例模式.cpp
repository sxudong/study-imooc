#include<iostream>
using namespace std;

// 饿汉式
class Singelton{
private:
	Singelton(){	// 单例模式的特色构造函数在private中
		cout<< "单例构造函数"<<endl;
	}
public:
	static Singelton *getInstance(){
		return mySig;
	}
	static Singelton *freeInstance(){
		if(mySig != nullptr){
			delete mySig;
			mySig = nullptr; // 指针被free了后，指针里还是有值的，这时候是野指针了
		}
		return mySig;
	}
protected:
private:
	static Singelton *mySig;	
};

Singelton* Singelton::mySig = new Singelton();;	// 直接给出

int main(){
	Singelton *p1 = Singelton::getInstance();
	Singelton *p2 = Singelton::getInstance();
	if(p1 == p2){
		cout<< "是同一个对象"<<endl;
	}else{
		cout<< "不是同一个对象"<<endl;
	}
	Singelton::freeInstance();

	return 0;
}