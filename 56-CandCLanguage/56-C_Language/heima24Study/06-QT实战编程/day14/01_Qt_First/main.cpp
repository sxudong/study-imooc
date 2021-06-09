#include "mywidget.h"
#include <QApplication> //包含头文件 应用程序

// 程序入口 argc命令行变量数量  argv命令行变量数组
int main(int argc, char *argv[])
{
    //应用程序对象  a ，Qt中  有且仅有一个 应用程序对象
    QApplication a(argc, argv);
    //创建 MyWidget对象 w   MyWidget基类 QWidget
    MyWidget w;
    //窗口默认是不会弹出的，如果想弹出 调用 show方法
    w.show();

    //a.exec()进入消息循环机制 pause
    return a.exec();

//    while(1)
//    {
//        if(点击叉子)
//        {
//            break;
//        }
//    }
}
