#include "widget.h"
#include <QPushButton>


/*
* 需求：创建两个类  Teacher 类  Student 类
* 下课后 老师Teacher  zt  会发出一个信号    饿了
* 学生响应信号Student st  处理信号的槽函数  请客吃饭
*/
#include <QDebug>

Widget::Widget(QWidget *parent)
    : QWidget(parent)
{
    //zt和st是Widget的成员变量
    zt = new Teacher(this);
    st = new Student(this);

    //1.连接 老师和学生
    //connect(zt, &Teacher::hungry, st, &Student::treat);

    /*
    * 2.使用有参数 信号和槽连接
    * 当出现重载函数时，需要“函数指针”指向“执行函数地址”，然后将这两个地址扔到连接里面。
    */
//    void(Teacher:: *teaherSignal)(QString) = &Teacher::hungry;
//    void(Student:: *stSlot)(QString) = &Student::treat;
//    connect(zt, teaherSignal, st, stSlot);


    /*
    * 点击“按钮”才下课
    */
    QPushButton * btn = new QPushButton("下课", this);
    btn->move(100,0);
    /*
    * 触发无参 信号和槽
    * 信号“连接”信号
    */
    void(Teacher:: *noTeacherSignal)(void) = &Teacher::hungry; //无参函数地址
    void(Student:: *noStSlot)(void) =  &Student::treat;        //无参函数地址
    connect(btn, &QPushButton::clicked, zt, noTeacherSignal);  //信号连接信号
    //connect(btn,&QPushButton::clicked,this,&Widget::close);  //一个信号可以连接多个槽函数
    connect(zt, noTeacherSignal, st, noStSlot);                //信号连接槽

    /*
    * 断开信号和槽
    */
    //disconnect(zt,noTeacherSignal,st,noStSlot);

    /*
     * 信号和槽的拓展
     *  1 信号可以连接信号
     *  2 信号和槽可以断开 disconnect
     *  3 一个信号可以触发多个槽函数
     *  4 多个信号可以连接同一个槽函数
     *  5 信号和槽的参数必须一一对应,参数个数必须一一对应吗？不一定
     *    信号的参数个数 可以多余 槽函数的参数个数，反之不可以，但是必须类型一一对应
     */


    /*
    * Qt 4版本 信号和槽写法
    * 不推荐Qt4版本信号槽写法 ，原因：类型匹配不检测，运行时报错。
    * 优点： 参数类型 比较直观，发生重载也不用写函数指针
    * 不检测原因 SIGNAL和SLOT下 会把里面代码作为字符串处理
    * SIGNAL("hungry(QString)") SLOT("treat(QString)")
    */
    connect(zt, SIGNAL(hungry(QString)), st, SLOT(treat(QString))); //有参

    //下课
    classIsOver();

    //重置大小
    resize(600,400);

//----------------- Lambda表达式 -----------------

    QPushButton * btn2 = new QPushButton("aaaa",this);
    btn2->move(300,0);
    //[](){}    这是一个函数
    //[](){}()  函数调用加()
    //[=](){}() [=]代表值传递 [&]代表引用传递
    [=](){
        btn2->setText("bbbb");
    }();


    /*
     * mutable关键字
     * 用于“修改”值传递的“变量”进行修改。
     */
    QPushButton * myBtn1 = new QPushButton ("myBtn1",this);
    QPushButton * myBtn2 = new QPushButton ("myBtn2",this);
    myBtn2->move(100,100);

    int m = 10;
    connect(myBtn1, &QPushButton::clicked, this, [m] ()mutable { m = 100 + 10; qDebug() << m; }); //qDebug()打印，相当于cout
    connect(myBtn2, &QPushButton::clicked, this, [=] (){ qDebug() << m; });

    qDebug() << m;


    //返回值
    int ret = []()->int{return 10000;}();
    qDebug() <<"ret = " << ret;

    /*
     * 用到最频繁的 [=](){}
     */
    QPushButton * btn3 = new QPushButton ("btn3",this);
    btn3->move(200,0);
    //做信号槽连接  默认内部变量会进行锁状态，只读状态，如果进行写操作，就会挂掉
    connect(btn3, &QPushButton::clicked, this, [=]()
    {
        btn3->setText("DDDDDD");
    });


    //无参按钮调用 有参 请客吃饭
    QPushButton * btn4 = new QPushButton ("btn4",this);
    btn4->move(300,0);
    connect(btn4, &QPushButton::clicked, this, [=](){
       zt->hungry("宫保鸡丁1111");
    });


    //点击按钮，关闭窗口
    QPushButton * btn5 = new QPushButton ("btn5",this);
    btn5->move(400,0);
    //用Lambda表达式，当信号接收是“this”时，“this”也可以省略掉了
    connect(btn5, &QPushButton::clicked, [=](){
       this->close();
    });

}

void Widget::classIsOver()
{
    //触发老师饿了的信号
    //老师饿了的信号属于自定义信号，触发自定义信号关键字  emit
    //emit zt->hungry();        //触发无参信号

    emit zt->hungry("宫保鸡丁"); //触发有参的函数
}


Widget::~Widget()
{

}
