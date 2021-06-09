#include "mywidget.h"
#include<QPushButton>
#include "mybutton.h" //使用自己的按钮
#include <QDebug>

//命名规范
//类名 首字母大写、单词与单词之间 首字母大写
//函数、变量名称首字母小写  单词与单词之间首字母大写

//帮助文档的查看方式
//第一种 f1查看
//第二种 左侧的按钮
//第三种 exe程序 D:\Qt\Qt5.8.0\Tools\QtCreator\bin
//第四种 开始菜单中的“Qt助手”软件

//快捷键
//编译+运行 ctrl +r
//编译  ctrl+b
//帮助文档 f1
//字体大小 ctrl + 鼠标滚轮
//自动对齐  ctrl + i
//同名的.h 和.cpp之间的切换 F4
//注释 ctrl+ /
//查找关键字 ctrl +f
//整行移动 ctrl + shift +↑ 或者↓


MyWidget::MyWidget(QWidget *parent)
    : QWidget(parent) //初始化列表
{
    //按钮
    QPushButton * btn =new QPushButton;

    // btn->show();
    //btn应该依赖于主窗口
    btn->setParent(this);
    //显示文字
    btn->setText("德玛"); //将char* 隐式类型转为QString

    //第二种创建方式  窗口会按照 btn2大小进行显示
    QPushButton * btn2 = new QPushButton("德玛西亚",this);
    //移动窗口
    btn2->move(100,100);
    //重置窗口大小
    resize(960,640);

    //btn可不可以 resize? 可以
    btn2->resize(50,50);

    //设置“窗口标题名称”
    this->setWindowTitle("德玛西亚万岁");

    //设置固定窗口大小
    //this->setFixedSize(600,400);

    //一定程序下，简化了内存回收机制

    //对象树
    MyButton * myBtn = new MyButton(); //创建自己的按钮
    myBtn->setParent(this);
    myBtn->move(200,200);
    myBtn->setText("我的按钮");

    //窗体的坐标系
    //左上角为 0 0 点
    // x 以右侧为正方向  y 以下侧为正方向

    //需求: 点击“我的按钮” ，关闭窗口
    //连接信号槽的关键字 connect
    //4个参数:
    //参数1 信号发送者
    //参数2 发送的信号（信号地址）
    //参数3 信号的接受者
    //参数4 处理的槽函数（函数地址）
    //参数2 和参数4 需要的都是函数地址
    //connect(myBtn,&MyButton::clicked,this,&MyWidget::close);
    connect(myBtn,&QPushButton::clicked,this,&MyWidget::close);

}

MyWidget::~MyWidget()
{
    qDebug("MyWidget析构了！");
}
