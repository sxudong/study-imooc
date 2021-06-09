#include "coinbutton.h"
#include <QPainter>
#include <QString>

CoinButton::CoinButton(QWidget *parent) : QPushButton(parent)
{
    // 设置初始状态
    this->setCoinState(0);
    // 设置按钮不规则样式，去掉边框；
    this->setStyleSheet("QPushButton{border:0px}");

    // 动画的定时器，信号和槽的实现
    connect(&this->coinTimer,&QTimer::timeout,[=](){
        if(this->coinState){
            // 如果为1表示银币翻金币
            this->coinFrame--;
        }else{
            // 否则表示金币翻转银币
            this->coinFrame++;
        }
        // 加载相应帧的图片
        QString picFrameName = QString(":/res/Coin000%1.png").arg(this->coinFrame);
        this->setIcon(QIcon(picFrameName));
        // 停止计时器，停止动画
        if(this->coinFrame == 8 || this->coinFrame == 1){
            this->coinTimer.stop();
        }
    });

}

int CoinButton::getCoinState() const
{
    return coinState;
}

void CoinButton::setCoinState(int value)
{
    coinState = value;
    if(this->coinState){
        // 金币
        this->setIcon(QIcon(":/res/Coin0001.png"));
    }
    else{
        // 银币
        this->setIcon(QIcon(":/res/Coin0008.png"));
    }
    // 因为在PlayScreen类中,加载按钮后又重新设置了大小，先后次序问题，这里加载的是没有重新设置的大小，
    // 所以转到PlayScreen类中还需要进行设置加载；
//    // 设置coin图标大小
    this->setIconSize(this->size());

}

void CoinButton::setCoinStateWithAnimation(int mstate)
{
    // 金币翻转成银币动画
    this->coinState = mstate;
    if(this->coinState){
        // coinState == 1 时翻转，表示银币翻转金币
        this->coinFrame = 8;
    }
    else{
        // 金币翻转银币
        // 金币翻转过程状态设置
        this->coinFrame = 1;
    }
    // 定时器设置
    this->coinTimer.start(30);  // 30毫秒


}

void CoinButton::flip()
{
    // 状态置反
//    this->setCoinState(!(this->getCoinState())); //设置翻转动画前
    // 反转动画
    this->setCoinStateWithAnimation(!(this->getCoinState()));
}

void CoinButton::paintEvent(QPaintEvent *event)
{
    // 绘制按钮的图片
    QPainter painter(this);

    QPixmap pix;
    pix.load(":/res/BoardNode(1).png");
    painter.drawPixmap(0,0,this->width(),this->height(),pix);
    // 调用父类的paintEvent,解决图层覆盖问题
    QPushButton::paintEvent(event);

}
