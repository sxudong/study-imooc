#include "startscreen.h"
#include <QTimer>
#include <QSound> // 需要在prow文件中添加multimedia字段

StartScreen::StartScreen(QWidget *parent) : MyMainWindow(parent)
{
    this->setWindowTitle("开始场景");

    // 创建开始界面的开始按钮
    MyPushButton *btnStart = new MyPushButton(":/res/MenuSceneStartButton.png","",this);
    // 设置大小
    btnStart->resize(114,114);
    // 按钮位置水平居中，垂直应该在3/4的位置;
    // 按钮位置计算：
    // x = 窗口宽度/2-按钮宽度/2;
    // y = 窗口高度*(3/4)-按钮高度/2;
    btnStart->move(this->width()/2-btnStart->width()/2,
                   this->height()*3/4-btnStart->height()/2);

    // 关于选择关卡返回按钮的信号绑定(第二个窗口返回按钮)
    connect(&this->mSelectScreen,&SelectScreen::backBtnClicked,[=](){
        QSound::play(":/res/BackButtonSound.wav");
        // 当第二个窗口点击反汇的时候;
        this->show();
        this->mSelectScreen.hide();
        this->move(this->mSelectScreen.pos());
    });


    // 需要放一个自定义按钮(开始游戏按钮)，创建信号绑定
    connect(btnStart,&MyPushButton::clicked,[=](){
        QSound::play(":/res/TapButtonSound.wav");
        // 将组件设置为不可用
        btnStart->setEnabled(false);
        // 播放向下的动画效果
        btnStart->moveDown();
        QTimer::singleShot(110,[&](){// lambda表达式在视频教程中传入的是=,我这里使用了&,
                                     // 为了避免在表达式中更改了btnStart，还是建议用=
            // 向上的动画效果
            btnStart->moveUp();
        });
        QTimer::singleShot(220,[&](){
            // 将组件设置为可用
            btnStart->setEnabled(true);
        });

        // 动画播放完，场景进行转换
        // 隐藏当前窗口
        this->hide();
        // 并且显示SelectScreen窗口
        this->mSelectScreen.show();
        // 将窗口移动到当前窗口位置
        this->mSelectScreen.move(this->pos());
    });

}
