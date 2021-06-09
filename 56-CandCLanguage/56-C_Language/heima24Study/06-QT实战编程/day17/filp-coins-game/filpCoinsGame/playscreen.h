#ifndef PLAYSCREEN_H
#define PLAYSCREEN_H

#include <QMainWindow>
#include "mymainwindow.h"
#include "coinbutton.h"
#include <QMessageBox>  // 游戏胜利判断，调试开发用

class PlayScreen : public MyMainWindow
{
    Q_OBJECT
public:
    PlayScreen(int level,QWidget *parent = nullptr);
    // 翻动第几行第几列
    void flip(int ,int);
    // 判断胜利
    void judgeWin();

signals:
    // 点击返回按钮发射的信号
    void backBtnClicked();
protected:
    // 添加绘图事件
    void paintEvent(QPaintEvent *event) override;

public slots:
private:
    // 胜利状态
    bool mHasWin;
    // 硬币按钮数组
    CoinButton *currentCoins[4][4];
};

#endif // PLAYSCREEN_H
