#include "mypushbutton.h"
#include <QPropertyAnimation>

MyPushButton::MyPushButton(QString normalImg,QString pressedImg,QWidget *parent) : QPushButton(parent)
  ,mnormalImg(normalImg)
  ,mpressedImg(pressedImg)
{
    mState = Normal;
}

void MyPushButton::moveDown()
{
    // 属性动画对象，设置要做动画的对象和属性;
    // 属性动画就会根据时间生成目标对象某个属性过渡的动画;
    // 这里的对象就是按钮this，属性就是geometry(包含x,y坐标和宽度w高度h的一个属性);

    // 位置大小属性发生变化;
        // 给定开始位置大小属性;
        // 给定结束位置大小属性;
        // 给定速度、给定动画时长;
    QPropertyAnimation *animation = new QPropertyAnimation(this,"geometry",this);
    animation->setStartValue(this->geometry());
    animation->setEndValue(QRect(this->x(),this->y()+10,this->width(),this->height()));
    animation->setDuration(100);
    animation->start(QPropertyAnimation::DeleteWhenStopped);

}

void MyPushButton::moveUp()
{
    // 原模原样的从MyPushButton::moveDown()中拷贝下来;
    // 只更改了位移参数从加变成了减去;
    QPropertyAnimation *animation = new QPropertyAnimation(this,"geometry",this);
    animation->setStartValue(this->geometry());
    animation->setEndValue(QRect(this->x(),this->y()-10,this->width(),this->height()));
    animation->setDuration(100);
    animation->start(QPropertyAnimation::DeleteWhenStopped);


}

void MyPushButton::paintEvent(QPaintEvent *)
{
    // 绘制按钮的图片
    QPainter painter(this);
    // 第一种写法跟开始背景一样;
//    QPixmap pix(":/res/MenuSceneStartButton.png");
    // 第二种写法是使用load加载路径;
    QPixmap pix;
    if(mState == Normal){
        pix.load(mnormalImg);//":/res/BackButton.png"
    }
    if(mState == Pressed){
        pix.load(mpressedImg);//":/res/BackButtonSelected.png"
    }
    painter.drawPixmap(0,0,this->width(),this->height(),pix);

    // 绘制按钮的文字;
    painter.drawText(0,0,this->width(),this->height(),
                     Qt::AlignHCenter | Qt::AlignVCenter,this->text());

}

void MyPushButton::mousePressEvent(QMouseEvent *event)
{
    // 鼠标按下的状态切换到Pressed;
    this->mState = Pressed;
    update();
    // 保证信号槽功能
    QPushButton::mousePressEvent(event);
}

void MyPushButton::mouseReleaseEvent(QMouseEvent *event)
{
    // 鼠标松开的状态切换到Normal;
    this->mState = Normal;
    update();
    // 保证信号槽功能
    QPushButton::mouseReleaseEvent(event);
}
