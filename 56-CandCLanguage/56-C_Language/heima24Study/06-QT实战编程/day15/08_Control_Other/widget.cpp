#include "widget.h"
#include "ui_widget.h"
#include <QMovie>
Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);


    //设置“默认选中”第0项
    ui->stackedWidget->setCurrentIndex(0);

    /*
     * stackWidget
     */
    //点击“btnScroll”按钮，切换到滚动条
    connect(ui->btnScroll,&QPushButton::clicked,[=](){ //滚动条
        ui->stackedWidget->setCurrentIndex(0);
    });
    //点击“btnTab”按钮切换
    connect(ui->btnTab,&QPushButton::clicked,[=](){
         ui->stackedWidget->setCurrentIndex(1);
    });
    //点击“btnToolBox”按钮切换
    connect(ui->btnToolBox,&QPushButton::clicked,[=](){
         ui->stackedWidget->setCurrentIndex(2);
    });


    /*
     * 下拉框使用
     */
    ui->comboBox->addItem("奔驰");
    ui->comboBox->addItem("宝马");
    ui->comboBox->addItem("拖拉机");

    //点击“拖拉机”按钮
    connect(ui->btnChoose,&QPushButton::clicked,[=](){
        ui->comboBox->setCurrentText("拖拉机");
    });


    /*
     * 利用QLabel显示 —— 图片
     */
    ui->img->setPixmap(QPixmap(":/Image/Luffy.png"));

    /*
     * 利用QLabel显示 —— gif图片
     */
    QMovie * movie = new QMovie(":/Image/mario.gif");
    ui->movie->setMovie(movie);
    movie->start(); //播放gif
}

Widget::~Widget()
{
    delete ui;
}
