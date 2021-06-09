#ifndef MYLABEL_H
#define MYLABEL_H

#include <QLabel>

class MyLabel : public QLabel
{
    Q_OBJECT
public:
    explicit MyLabel(QWidget *parent = 0);

    /*
     * 捕获事件
     */

    //鼠标进入事件
    void enterEvent(QEvent *);
    //鼠标离开事件
    void leaveEvent(QEvent *);
    //鼠标按下事件
    void mousePressEvent(QMouseEvent *ev);
    //鼠标释放事件
    void mouseReleaseEvent(QMouseEvent *ev);
    //鼠标移动事件
    void mouseMoveEvent(QMouseEvent *ev);
    //事件分发 Event事件
    bool event(QEvent *e);

};

#endif // MYLABEL_H
