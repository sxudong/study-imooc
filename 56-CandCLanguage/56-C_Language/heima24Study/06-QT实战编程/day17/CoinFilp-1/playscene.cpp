#include "playscene.h"
#include <QDebug>
#include <QMenuBar>
#include <QMenu>
#include <QAction>
#include <QPainter>
#include "mypushbutton.h"
#include <QTimer>
#include <QLabel>
//PlayScene::PlayScene(QWidget *parent) : QMainWindow(parent)
//{

//}


PlayScene::PlayScene(int levalIndex)
{

    //记录用户选择的具体关卡号
    this->levalIndex = levalIndex;
    qDebug() << "用户选择的是" << this->levalIndex << "关";


    //设置窗口固定大小
    this->setFixedSize(320,588);
    //设置图标
    this->setWindowIcon(QPixmap(":/res/Coin0001.png"));
    //设置标题
    this->setWindowTitle("翻金币游戏场景");

    //创建菜单栏
    QMenuBar * bar = this->menuBar();
    this->setMenuBar(bar);
    //创建开始菜单
    QMenu * startMenu = bar->addMenu("开始");
    //创建按钮菜单项
    QAction * quitAction = startMenu->addAction("退出");
    //点击退出 退出游戏
    connect(quitAction,&QAction::triggered,[=](){this->close();});


    //返回按钮
    MyPushButton * backBtn = new MyPushButton(":/res/BackButton.png",":/res/BackButtonSelected.png");

    backBtn->setParent(this);

    backBtn->move( this->width() - backBtn->width(),  this->height() - backBtn->height());


    connect(backBtn,&MyPushButton::clicked,[=](){
       // qDebug()<<"返回到主场景";

        //延时发送返回信号
        QTimer::singleShot(500,this,[=](){
            emit this->chooseSceneBack();
        });
    });


    //创建具体用户选择的关卡标签
    QLabel * label = new QLabel;
    label->setParent(this);

    QString str  = QString("leavel: %1").arg(this->levalIndex);
    label->setText(str);

    //设置字体和字号
    QFont font;
    font.setFamily("华文新魏");
    font.setPointSize(20);
    label->setFont(font);

    //设置位置和大小
    label->setGeometry(QRect(30,this->height() - 50, 120,50 ));


    //创建金币背景图片
    for(int i = 0 ;i  < 4;i++)
    {
        for(int j = 0 ; j < 4;j ++)
        {
            //QLabel显示图片
            QLabel* label = new QLabel;
            QPixmap pix;
            pix.load(":/res/BoardNode.png");

            label->setGeometry(0,0,pix.width(),pix.height());
            label->setPixmap(pix);
            label->setParent(this);
            label->move(57 + i*pix.width(),200+j*pix.height());
        }

    }
}


//重写绘图事件
void PlayScene::paintEvent(QPaintEvent *)
{
    QPainter painter(this);

    QPixmap pix;
    pix.load(":/res/PlayLevelSceneBg.png");

    painter.drawPixmap(0,0,this->width(),this->height(),pix);

    //加载标题
    pix.load(":/res/Title.png");
    pix = pix.scaled(pix.width()*0.5,pix.height()*0.5);
    painter.drawPixmap( 10,30,pix.width(),pix.height(),pix);


}
