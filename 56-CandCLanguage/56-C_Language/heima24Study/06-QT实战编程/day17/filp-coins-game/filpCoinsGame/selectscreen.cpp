#include "selectscreen.h"
#include <QPushButton>
#include <QPainter>
#include <QMenuBar>
#include "mypushbutton.h"
#include "playscreen.h"
#include <QSound>

SelectScreen::SelectScreen(QWidget *parent) : MyMainWindow(parent)
{
    // 返回按钮
    MyPushButton *btnBack = new MyPushButton(":/res/BackButton.png",
                                             ":/res/BackButtonSelected.png",
                                             this);

    // 设置按钮大小
    btnBack->resize(72,32);
    // 创建返回按钮的信号绑定
    connect(btnBack,&QPushButton::clicked,this,&SelectScreen::backBtnClicked);

    // 返回按钮的位置设置
    // 位置计算方式：从左上角移动到右下角
    btnBack->move(this->width()-btnBack->width(),this->height()-btnBack->height());




    // 设置按钮默认行高列宽
    const int colWidth = 70;    // 列宽
    const int rowheigh = 70;    // 行高
    // 设置默认偏移
    const int xOffset=25;
    const int yOffset=130;
    // 创建20个按钮；
    for(int i=0;i<20;i++){
        MyPushButton *btn = new MyPushButton(":/res/LevelIcon.png",":/res/LevelIcon.png", this);
        btn->setText(QString::number(i+1));
        // 排列
        // 行  i/4
        // 列  i%4
        int row = i/4;
        int col = i%4;
        // x 坐标 = 列数*列宽+x偏移
        // y 坐标 = 行数*行高+y偏移
        int x = col * colWidth + xOffset;
        int y = row * rowheigh + yOffset;
        btn->resize(57,57);
        btn->move(x,y);
        // 打开第三个场景
        connect(btn,&MyPushButton::clicked,[=](){
            QSound::play(":/res/TapButtonSound.wav");
            // 点击关卡按钮后，每次打开一个新的PlayScreen场景;
            PlayScreen *playScreen = new PlayScreen(i+1);
            // 设置playScreen关闭的时候自动释放;
            playScreen->setAttribute(Qt::WA_DeleteOnClose);
            playScreen->move(this->pos());
            playScreen->show();
            this->hide();
            // 返回按钮
            connect(playScreen,&PlayScreen::backBtnClicked,[=](){
                QSound::play(":/res/BackButtonSound.wav");
                this->move(playScreen->pos());
                this->show();
                // 返回直接关闭
                playScreen->close();
            });
        });
    }

}

void SelectScreen::paintEvent(QPaintEvent *event)
{
    // 画背景
    QPainter painter(this);
    // 将画家搬动到菜单栏下面;
    painter.translate(0,this->menuBar()->height());
    // 绘制背景图片
    QPixmap pix(":/res/OtherSceneBg.png");
    painter.drawPixmap(0,0,this->width(),this->height(),pix);
    // 添加Logo
    pix.load(":/res/Title.png");
    painter.drawPixmap(0,0,pix);
}
