#define _CRT_SECURE_NO_WARNINGS
#include<iostream>
using namespace std;


/*
2 异常
	2.1	try 试图执行 try {}中的内容
	2.2	在可能出现异常的地方 抛出异常  throw
	2.3	try下面 catch捕获异常
	2.4	catch (捕获类型)  …代表 所有其他类型
	2.5	如果不想处理异常，继续向上抛出  throw
	2.6	如果没有任何处理异常的地方，那么成员调用terminate函数，中断程序
	2.7	自定义异常类，可以抛出自定义的对象，捕获自定义的异常

3 栈解旋
	3.1	从try开始  到 throw 抛出异常之前  所有栈上的对象 都会被释放 这个过程称为栈解旋
	3.2	栈上对象构造顺序与析构顺序相反

4 异常的接口声明 --> 测试代码在QT项目“exception”中
	4.1	如果想抛出特定的类型异常 ，可以利用异常的接口声明
	4.2	void func() throw ( int) 只能抛出 int类型
	4.3	throw() 不抛出任何类型异常

*/


/*
* 自定义异常类
* （day09 06.对自定义异常进行捕获_.mp4）
*/
class myException
{
public:
	void printError(){
		cout << "自定义的异常" << endl;
	}
};

class Person
{
public:
	Person(){
		cout << "Person构造" << endl;
	}

	~Person(){
		cout << "Person析构" << endl;
	}

};


//C语言早期的做法
int A_MyDivide(int a, int b) {
	if (b == 0) {
		return -1; //早期如果返回-1，无法区分到底是结果还是异常
	}
	return a / b;
}


/*
* 除法运算
*/
int myDevide(int a ,int b)
{
	if (b == 0){

		//如果b是异常，抛出异常
		//throw 1;    //抛出 int 类型异常
		//throw 3.14; //抛出 double 类型异常  异常必须处理，如果不处理 就挂掉
		//throw 'a';

		/*
		* 栈解旋
		* 从try开始  到 throw 抛出异常之前，所有栈上的对象都会被释放，这个过程称为“栈解旋”。
		* 构造和析构顺序相反
		*/
		Person p1;
		Person p2;

		throw myException(); //匿名对象
		/* 栈解旋:从 try 开始 到 throw 抛出异常之前，所有栈上的对象都会被释放。
		  Person构造
		  Person构造
		  Person析构
		  Person析构
		  自定义的异常
		*/
	}
	return a / b;
}



void test01()
{
	int a = 10;
	int b = 0;

	//int ret = myDevide(a, b); //早期如果返回-1 无法区分到底是结果还是异常

	//C++中异常处理

	try{ //试一试
		myDevide(a, b);
	}catch(int){ //捕获异常
		cout << "int类型异常捕获" << endl;
	}catch(double){
		//如果不想处理这个异常 ，可以继续向上抛出
		throw;
		cout << "double类型异常捕获" << endl;
	}catch (myException e){
		e.printError();
	}catch (...){ // “...”其它异常
		cout << "其他类型异常捕获" << endl;
	}
}


int main(){

	try{
		test01();
    //}catch (double){ //处理test01()抛出的 double 异常
	}catch (char){     //如果异常都没有处理，那么成员 terminate 函数，使程序中断
		cout << "main 函数中 double类型异常捕获" << endl;
	}catch (...){
		cout << "main函数中 其他类型异常捕获" << endl;
	}

	system("pause");
	return EXIT_SUCCESS;
}
/* Output:
Person构造
Person构造
Person析构
Person析构
自定义的异常
请按任意键继续. . .
*/