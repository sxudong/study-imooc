#include "mywidget.h"
#include <QPushButton>
#include "mybutton.h"
#include <QDebug>
//命名规范 以及 快捷键
// 类名 首字母大写 单词与单词之间 首字母大写
// 函数、变量  首字母小写 单词与单词之间 首字母大写
// 快捷键
// 运行  ctrl + R
// 编译  ctrl + B
// 查找  ctrl + F
// 帮助文档 F1
// 字体缩放  ctrl + 鼠标滚轮
// 自动对齐  ctrl + i
// 整行移动 ctrl+ shift + ↑ 或者 ↓
// 同名之间的 .h .cpp切换  F4
// 帮助文档 第一种 ： F1  第二种 ：左侧按钮  第三种：C:\Qt\Qt5.6.0\5.6\mingw49_32\bin
// 注释快捷键  ctrl + /
MyWidget::MyWidget(QWidget *parent)
    : QWidget(parent) //初始化列表
{
    //按钮
    QPushButton * btn = new QPushButton;
    //btn->show(); //show用顶层方式弹出，如果想在MyWidget窗口中显示，就需要依赖MyWidget窗口
    //设置父亲
    btn->setParent(this);

    //设置文字
    btn->setText("德玛西亚"); //将char* 隐式类型转为QString

    //创建按钮第二种方式  窗口会按照 btn2大小进行显示
    QPushButton * btn2 = new QPushButton("第二按钮",this);
    //重置窗口大小
    resize(600,400);

    //移动第二个按钮
    btn2->move(100,100);


    //按钮是否可以 重置大小resize？ 可以
    btn2->resize(50,50);


    //重置窗口标题
    setWindowTitle("Qt第一个窗口");

    //设置固定窗口大小
    setFixedSize(600,400);

    //一定程度下 简化了内存回收机制
    //创建自己的按钮
    MyButton * myBtn = new MyButton;
    myBtn->setText("我的按钮");
    myBtn->move(200,200);
    myBtn->setParent(this);

    //Qt坐标系
    //x为右侧正向  y 以 下侧为正向


    //点击 myBtn 关闭窗口
    //参数1  信号的发送者  参数2  发送的信号 参数3 信号的接受者 参数4 处理的槽函数
    //connect(myBtn,&MyButton::clicked , this , &MyWidget::close);
    connect(myBtn,&QPushButton::clicked , this , &QWidget::close);

}

MyWidget::~MyWidget()
{
    qDebug() << "MyWidget析构了！";
}
