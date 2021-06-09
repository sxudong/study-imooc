#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this); //利用ui布局来完成一个登录窗口
}

//析构函数
Widget::~Widget()
{
    delete ui;
}
