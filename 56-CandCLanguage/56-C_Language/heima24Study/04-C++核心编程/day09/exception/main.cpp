#include "mainwindow.h"
#include <QApplication>
#include <QDebug>

/*
* 必需QT下运行
*/

/*
4 异常的接口声明
	4.1	如果想抛出特定的类型异常 ，可以利用异常的接口声明
	4.2	void func() throw ( int) 只能抛出 int类型
	4.3	throw() 不抛出任何类型异常
*/

//异常的接口声明
void func1() throw(int) //throw(int)只能抛出int类型异常
{
    throw 1;
}

void func2() throw(int) //throw(int)只能抛出int类型异常
{
    throw 3.14; //指定你抛出int，你抛出double，catch(int)以下就别想执行了,程序会终止掉,挂掉。
}

void func3() throw() //throw()不抛出任何类型异常
{
    throw 3.14;      //程序会终止掉，挂掉
}

void func3() throw(double) //除了int，也可以char,double
{
    throw 3.14;
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();

    try{
        func1();
    }catch(int){
        qDebug() << "int类型异常捕获";
    }catch(...){
        qDebug() << "其他类型异常捕获";
    }

    return a.exec();
}
