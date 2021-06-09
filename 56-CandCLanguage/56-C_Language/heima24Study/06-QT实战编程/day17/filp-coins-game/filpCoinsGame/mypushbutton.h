#ifndef MYPUSHBUTTON_H
#define MYPUSHBUTTON_H

#include <QWidget>
#include <QPushButton>
#include <QPainter>

class MyPushButton : public QPushButton
{
    Q_OBJECT
public:
    enum MyPushButtonState{
        Normal,
        Pressed
    };
    MyPushButton(QString normalImg,QString pressedImg,QWidget *parent = nullptr);
    // 按钮动画效果 往上和往下的动作
    void moveDown();
    void moveUp();

protected:
    void paintEvent(QPaintEvent *) override;
    void mousePressEvent(QMouseEvent *) override;
    void mouseReleaseEvent(QMouseEvent *) override;



private:
    // 正常状态加载的图片
    QString mnormalImg;
    // 点击状态加载的图片
    QString mpressedImg;
    // 状态
    MyPushButtonState mState;

signals:

public slots:
};

#endif // MYPUSHBUTTON_H
