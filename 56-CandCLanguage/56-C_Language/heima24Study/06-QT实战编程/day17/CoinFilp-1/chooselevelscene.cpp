#include "chooselevelscene.h"
#include <QMenuBar>
#include <QMenu>
#include <QAction>
#include <QPainter>
#include "mypushbutton.h"
#include <QDebug>
#include <QTimer>
#include <QLabel>

ChooseLevelScene::ChooseLevelScene(QWidget *parent) : QMainWindow(parent)
{
    //菜单栏
    QMenuBar * bar = menuBar();
    //菜单
    QMenu * startMenu =  bar->addMenu("开始");
    //菜单项
    QAction * quitAction = startMenu->addAction("退出");

    connect(quitAction,&QAction::triggered,[=](){
        this->close();
    });

    //设置标题
    this->setWindowTitle("选择关卡场景");

    //设置大小
    this->setFixedSize(320,588);

    //设置图标
    this->setWindowIcon(QPixmap(":/res/Coin0001.png"));


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


    playScene = NULL;


    //创建20个选择关卡的小按钮

    for(int i = 0 ; i < 20;i++)
    {

        MyPushButton * menuBtn = new MyPushButton(":/res/LevelIcon.png");

        menuBtn->setParent(this);

        menuBtn->move( 25+ (i%4) * 70 , 130 + (i/4)*70 );

        connect(menuBtn,&MyPushButton::clicked,[=](){
              //qDebug() <<"您选择的是第"<< i+1 << "关";

            playScene = new PlayScene(i+1);

            this->hide();
            this->playScene->show();

            //监听游戏场景中点击返回按钮 发送的自定义信号
            connect(this->playScene,&PlayScene::chooseSceneBack,[=](){

                delete this->playScene;
                this->playScene = NULL;
                this->show();
            });

        });

        //创建显示具体关卡号的 label
        QLabel * label = new QLabel;
        label->setParent(this);

        label->setFixedSize(menuBtn->width(),menuBtn->height());

        label->setText( QString::number(i+1) );

        label->move(25+ (i%4) * 70 , 130 + (i/4)*70);

        //设置居中
        label->setAlignment(Qt::AlignHCenter | Qt::AlignVCenter);


        //设置鼠标穿透事件   51号  鼠标穿透
        label->setAttribute(Qt::WA_TransparentForMouseEvents);
    }

}


//重写绘图事件
void ChooseLevelScene::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    QPixmap pix;
    pix.load(":/res/OtherSceneBg.png");
    painter.drawPixmap(0,0,this->width(),this->height(),pix);

        //加载标题
    pix.load(":/res/Title.png");
    painter.drawPixmap( (this->width() - pix.width())*0.5,30,pix.width(),pix.height(),pix);

}
