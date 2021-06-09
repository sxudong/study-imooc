#include "mywidget.h"   //包含头文件
#include <QApplication> //包含QApplication头文件 应用程序

//程序入口 argc命令行变量的数量 argv命令行变量数组
int main(int argc, char *argv[])
{
    //a 应用程序对象，对于Qt项目必须有应用程序对象，而且有且仅有一个
    QApplication a(argc, argv);
    //创建一个MyWidget对象 w  MyWidget基类 QWidget
    MyWidget w;
    //创建出的窗口对象并不会直接显示，默认是不会弹出的，需要调用show方法
    w.show();

    //a.exec()进入消息循环机制,阻塞状态
    return a.exec();
//    while(true)
//    {
//        if(点击叉子)
//            break;
//    }
}
