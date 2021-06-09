#include "widget.h"
#include "ui_widget.h"
#include <QDebug>
#include <QTimerEvent>
#include <QTimer>
#include <QMouseEvent>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    //启动定时器
    //定时器第一种方式
    id1 = startTimer(1000); //每1000毫秒调用一次timerEvent事件
    id2 = startTimer(2000);

    //定时器第二种方式
    QTimer * timer1 = new QTimer(this);
    //启动定时器对象
    timer1->start(500); //毫秒做单位
    //每隔0.5秒发送信号
    connect(timer1,&QTimer::timeout,[=](){
        static int num = 0;
        ui->label_4->setText( QString::number(num++));
    });

    //点击按钮“暂停定时器"
    connect(ui->pushButton,&QPushButton::clicked,[=](){
        timer1->stop();
    });


    //给ui->label做事件过滤器 拦截
    //步骤1    给控件安装过滤器
    //参数this 通过父窗口给lable安装过滤器
    ui->label->installEventFilter(this);
    //步骤2  重写 eventFilter事件

}

bool Widget::eventFilter(QObject * obj, QEvent * e)
{
    if(obj == ui->label)
    {
        //鼠标按下事件
        if( e->type() == QEvent::MouseButtonPress)
        {
            QMouseEvent * ev =  static_cast<QMouseEvent *>(e);

            QString str = QString("事件过滤器：：：鼠标按下了！！！ x = %1 y = %2").arg(ev->x()).arg(ev->y());

            qDebug()  << str;
             //只有鼠标按下 自己处理 返回true
            return true;
        }
    }

    //其他让 父类处理
    return QWidget::eventFilter(obj,e);
}


//定时器
void Widget::timerEvent(QTimerEvent * e)
{
    if(e->timerId() == id1)
    {
        static int num = 0;
        ui->label_2->setText( QString::number(num++));
    }

    if(e->timerId() == id2)
    {
        static int num2 = 0;
        ui->label_3->setText(QString::number(num2++));
    }

}

Widget::~Widget()
{
    delete ui;
}
