#include "mainscene.h"
#include "ui_mainscene.h"
#include <QPainter>
#include "mypushbutton.h"
#include <QDebug>
#include <QTimer>

MainScene::MainScene(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainScene)
{
    ui->setupUi(this);


    //主场景的基本配置

    //设置标题
    this->setWindowTitle("翻金币主场景");

    //设置大小
    this->setFixedSize(320,588);

    //设置图标
    this->setWindowIcon(QPixmap(":/res/Coin0001.png"));

    //点击开始中的退出  实现退出游戏
    connect(ui->actionQuit,&QAction::triggered,[=](){
        this->close();
    });



    //创建出选择关卡的场景
    chooseScene = new ChooseLevelScene;

    //开始按钮
    MyPushButton * startBtn = new MyPushButton(":/res/MenuSceneStartButton.png");
    startBtn->move( this->width() *0.5 - startBtn->width() * 0.5, this->height() * 0.7 );
    startBtn->setParent(this);


    //监听选择关卡场景中的 返回按钮自定义信号
    connect(chooseScene,&ChooseLevelScene::chooseSceneBack,[=](){

         chooseScene->hide();
         this->show();
    });


    connect(startBtn,&MyPushButton::clicked,[=](){
       //qDebug() << "点击了开始按钮";


        startBtn->zoom1();
        startBtn->zoom2();


        QTimer::singleShot(500,this,[=](){
            //延时进入到选择关卡场景
            this->hide(); //自身隐藏
            chooseScene->show(); //选择关卡场景显示
        });

    });

}

//利用绘图事件  绘制背景
void MainScene::paintEvent(QPaintEvent *)
{
    QPainter painter(this);

    QPixmap pix;
    pix.load(":/res/PlayLevelSceneBg.png");

    painter.drawPixmap(0,0,this->width(),this->height(),pix);


    //加载标题
    pix.load(":/res/Title.png");

    pix = pix.scaled(pix.width() * 0.5 , pix.height() * 0.5);

    painter.drawPixmap(10,30,pix.width(),pix.height(),pix);

}

MainScene::~MainScene()
{
    delete ui;
}
