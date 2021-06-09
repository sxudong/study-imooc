#include "widget.h"
#include "ui_widget.h"
#include <QPainter>

/*
 * 绘图画画
 */
Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    //点击移动按钮 移动图片

    posX = 10;

    connect(ui->pushButton,&QPushButton::clicked,[=](){
        posX += 10;

        //手动调用绘图事件
        update();

    });

}

void Widget::paintEvent(QPaintEvent *)
{
    //创建画家
    QPainter painter(this);

    //如果出屏幕 强制变回10
    if(posX > this->width())
    {
        posX = 10;
    }

    //画图片
    painter.drawPixmap(posX,100,QPixmap(":/Image/OnePiece.png"));


    //高级设置
//    painter.drawEllipse( QPoint(100,100),50,50);
//    //设置抗锯齿 效率低
//    painter.setRenderHint(QPainter::Antialiasing);
//    painter.drawEllipse( QPoint(200,100),50,50);


//    painter.drawRect( QRect(20,20,50,50));

//    //移动画家
//    painter.translate(QPoint(100,0));

//    //保存状态
//    painter.save();

//    painter.drawRect( QRect(20,20,50,50));

//    painter.translate(QPoint(100,0));
//    //取出状态
//    painter.restore();

//    painter.drawRect( QRect(20,20,50,50));


//    //设置画笔颜色
//    QPen pen(QColor(255,0,0));
//    //设置笔宽度
//    pen.setWidth(3);
//    //设置笔风格
//    pen.setStyle(Qt::DotLine);
//    //画家用这只笔
//    painter.setPen(pen);

//    //画刷填充颜色
//    QBrush brush(Qt::cyan);
//    //让画家使用画刷
//    brush.setStyle(Qt::Dense4Pattern);
//    painter.setBrush(brush);


//    //利用画家画画
//    //画线
//    painter.drawLine(QPoint(0,0),QPoint(100,100));

//    //画圆(椭圆)
//    painter.drawEllipse(QPoint(100,100),50,50);

//    //画矩形
//    painter.drawRect(QRect(10,10,50,50));

//    //画字体
//    painter.drawText(QRect(10,200,150,50),"好好学习，天天向上");



}

Widget::~Widget()
{
    delete ui;
}
