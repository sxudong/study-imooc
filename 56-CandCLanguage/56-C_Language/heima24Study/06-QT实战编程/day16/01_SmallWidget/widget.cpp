#include "widget.h"
#include "ui_widget.h"
#include <QDebug>



Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    //点击设置 到一半的位置
    connect(ui->btnSet, &QPushButton::clicked, [=](){
        //SmallWidget在widget.ui里属性objectName叫widget
        ui->widget->setValue(50);
    });

    //点击获取，拿到当前值
    connect(ui->btnGet, &QPushButton::clicked, [=](){
        //SmallWidget在widget.ui里属性objectName叫widget
        qDebug () << "当前值为：" << ui->widget->getValue();
    });
}

Widget::~Widget()
{
    delete ui;
}
