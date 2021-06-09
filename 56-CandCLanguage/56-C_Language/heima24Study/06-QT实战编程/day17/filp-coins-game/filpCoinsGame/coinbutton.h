#ifndef COINBUTTON_H
#define COINBUTTON_H

#include <QWidget>
#include <QPushButton>
#include <QTimer>

class CoinButton : public QPushButton
{
    Q_OBJECT
public:
    explicit CoinButton(QWidget *parent = nullptr);

    int getCoinState() const;
    void setCoinState(int value);

    // setCoinState带动画的函数
    void setCoinStateWithAnimation(int);

    // 硬币反转函数
    void flip();

signals:

public slots:

private:
    // 硬币状态
    // 0表示银币，1表示金币
    int coinState;

    // 当前硬币动画帧数
    int coinFrame;

    // 定时器
    QTimer coinTimer;
protected:
    void paintEvent(QPaintEvent *) override;
};

#endif // COINBUTTON_H
