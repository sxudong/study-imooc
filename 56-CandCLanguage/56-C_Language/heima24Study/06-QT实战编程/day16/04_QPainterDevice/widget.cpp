#include "widget.h"
#include "ui_widget.h"
#include <QPainter>
#include <QPicture>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    //QPixmap 做绘图设备，对不同平台显示做了优化
//    QPixmap pix(300,300);
//    //设置默认填充色
//    pix.fill(Qt::white);
//    QPainter painter(&pix);

//    painter.setPen(QPen(Qt::green));
//    painter.drawEllipse(QPoint(150,150),100,100);
//    //保存
//    pix.save("E:\\pix.png");


    //QImage 做绘图设备  对像素级访问进行了优化
//    QImage img(300,300,QImage::Format_RGB32);
//    img.fill(Qt::white);
//    QPainter painter(&img);
//    painter.setPen(QPen(Qt::blue));
//    painter.drawEllipse(QPoint(150,150),100,100);
//    img.save("E:\\img.png");


    //QPicture 绘图设备
    QPicture pic; //用于重现 记录绘图指令
    QPainter painter;
    painter.begin(&pic);

    painter.setPen(QPen(Qt::cyan));
    painter.drawEllipse(QPoint(150,150),100,100);

    painter.end();
    //保存
    pic.save("E:\\pic.zt");


}

void Widget::paintEvent(QPaintEvent *)
{
    //QImage可修改xiangsu
//    QImage img;
//    img.load(":/Image/Luffy.png");

//    for(int i = 50 ; i < 100;i++)
//    {
//       for(int j = 50 ; j < 100 ;j ++)
//       {
//           QRgb value = qRgb(255,0,0);
//           //设置像素点
//            img.setPixel(i,j,value);
//       }
//    }

//    QPainter painter(this);
//    painter.drawImage(QPoint(0,0),img);


    //重现绘图指令 QPicture
    QPicture pic;
    pic.load("E:\\pic.zt");
    QPainter painter(this);
    painter.drawPicture(0,0,pic);

}

Widget::~Widget()
{
    delete ui;
}
