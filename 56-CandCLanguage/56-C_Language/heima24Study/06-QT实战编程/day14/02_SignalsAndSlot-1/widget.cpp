#include "widget.h"

//需求： 创建两个类 Teacher 类  Student 类
// 下课后 老师Teacher zt  会发出一个信号   饿了
// 学生响应信号Student st  处理信号的槽函数  请客吃饭


Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    zt = new Teacher(this); //成员变量
    st = new Student(this);

    //连接 老师和学生
    connect(zt,&Teacher::hungry,st , &Student::treat );

    //下课
    classIsOver();

}

void Widget::classIsOver()
{
    //触发老师饿了的信号
    //老师饿了的信号属于自定义信号，触发自定义信号关键字  emit
    emit zt->hungry();
}


Widget::~Widget()
{

}
