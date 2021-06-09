#include "playscreen.h"
#include "mypushbutton.h"
#include <QPainter>
#include <QMenuBar>
#include <QLabel>
#include "dataconfig.h"
#include <QMap>
#include <QVector>
#include <QTimer>
#include <QMessageBox>
#include <QPropertyAnimation>
#include <QSound>

PlayScreen::PlayScreen(int level,QWidget *parent) : MyMainWindow(parent)
{
    mHasWin = false;
    // 返回按钮
    MyPushButton *btnBack = new MyPushButton(":/res/BackButton.png",
                                             ":/res/BackButtonSelected.png",
                                             this);

    // 设置按钮大小
    btnBack->resize(72,32);
    // 创建返回按钮的信号绑定
    connect(btnBack,&QPushButton::clicked,this,&PlayScreen::backBtnClicked);

    // 返回按钮的位置设置
    // 位置计算方式：从左上角移动到右下角
    btnBack->move(this->width()-btnBack->width(),this->height()-btnBack->height());

    // 添加左下角的Level
    QLabel *label = new QLabel(this);
    label->setText(QString("Level:%1").arg(level));// 在这里遇到了一个显示不全的bug，但是可以通过调用resize()设置label对象的geometry参数；
    // 设置标签大小
    label->resize(150,50);
    label->geometry();
    // 移动到左下角
    label->move(30,this->height()-label->height());
    // 设置字体大小
    label->setFont(QFont("微软雅黑",18));// 在这里我是通过更改字体的大小来实现了全部显示


    // 设置金币按钮默认行高列宽
    const int colWidth = 50;    // 列宽
    const int rowheigh = 50;    // 行高
    // 设置默认偏移
    const int xOffset=57;
    const int yOffset=200;

    // 游戏数据对象
    dataConfig objDataCon;
    // 取出关卡地图
    QVector<QVector<int> > objDataArray = objDataCon.mData[level];
    // 16个金币按钮
    for(int row=0;row<4;row++){
        for(int col=0;col<4;col++){
            CoinButton *cbtn = new CoinButton(this);
            // 存储当前按钮
            currentCoins[row][col] = cbtn;
            // x 坐标 = 列数*列宽+x偏移
            // y 坐标 = 行数*行高+y偏移
            int x = col * colWidth + xOffset;
            int y = row * rowheigh + yOffset;
            cbtn->setGeometry(x,y,50,50);
            // 在这里设置硬币图片大小
            // 从dataConfig中获取关卡地图位置值，进行赋值
            cbtn->setCoinState(objDataArray[row][col]);

            // 每次点击硬币的时候硬币状态置反
            connect(cbtn,&CoinButton::clicked,[=](){
//                cbtn->flip();// 需要存储状态，abandon
                this->flip(row,col);
            });
        }
    }


}

void PlayScreen::flip(int row, int col)
{
    // 如果胜利了，就直接返回
    if(mHasWin){
        return;
    }
    // 音效
    QSound::play(":/res/ConFlipSound.wav");
    this->currentCoins[row][col]->flip();
    // 延时翻动其它硬币
    QTimer::singleShot(250,[=](){ // 延迟时长根据硬币翻转帧数设置(30毫秒一帧)
        // 翻动上下左右的硬币
        // 上边硬币安全检查
        if(row+1<4){this->currentCoins[row+1][col]->flip();}
        // 下边硬币安全检查
        if(row-1>=0){this->currentCoins[row-1][col]->flip();}
        // 左边硬币安全检查
        if(col+1<4){this->currentCoins[row][col+1]->flip();}
        // 右边硬币安全检查
        if(col-1>=0){this->currentCoins[row][col-1]->flip();}

        // 判断游戏是否胜利
        this->judgeWin();
    });

}

void PlayScreen::judgeWin()
{
    // 当所有按钮的状态都为1
    for(int row = 0;row<4;row++){
        for (int col = 0;col<4;col++) {
            // 如果存在某个硬币是银币
            if(!(this->currentCoins[row][col]->getCoinState())){return ;}// 如果有一个是银币，那就直接返回;
        }
    }
    // 如果都是金币，游戏结束
//    QMessageBox::information(this,"恭喜","你已经胜利了"); // 测试用
    mHasWin = true;

    // 播放胜利音效
    QSound::play(":/res/LevelWinSound.wav");

    // 播放胜利动画
    QLabel *labelWin = new QLabel(this);
    QPixmap pix = QPixmap(":/res/LevelCompletedDialogBg.png");
    labelWin->setPixmap(pix);
    labelWin->resize(pix.size());
    labelWin->show();
    labelWin->move((this->width()-labelWin->width())/2,-labelWin->height());    // 先隐藏
    // 使用属性动画
    QPropertyAnimation *animation = new QPropertyAnimation(labelWin,"geometry",this);
    animation->setStartValue(labelWin->geometry());
    animation->setEndValue(QRect(labelWin->x(),labelWin->y()+100,labelWin->width(),labelWin->height()));
    animation->setDuration(1000);
    // 设置动画的运动曲线
    animation->setEasingCurve(QEasingCurve::OutBounce);
    animation->start(QPropertyAnimation::DeleteWhenStopped);    // 动画播放完自动删除

}

void PlayScreen::paintEvent(QPaintEvent *event)
{
    // 画背景
    QPainter painter(this);
    // 将画家搬动到菜单栏下面;
    painter.translate(0,this->menuBar()->height());
    // 绘制背景图片
    QPixmap pix(":/res/PlayLevelSceneBg.png");
    painter.drawPixmap(0,0,this->width(),this->height(),pix);
    // 添加Logo
    pix.load(":/res/Title.png");
    // logo缩小一半
    pix = pix.scaled(pix.width()/2,pix.height()/2);
    painter.drawPixmap(0,0,pix);


}
