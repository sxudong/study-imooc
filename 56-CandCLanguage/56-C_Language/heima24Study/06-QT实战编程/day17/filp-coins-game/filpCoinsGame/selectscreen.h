#ifndef SELECTSCREEN_H
#define SELECTSCREEN_H

#include <QMainWindow>
#include "mymainwindow.h"

class SelectScreen : public MyMainWindow
{
    Q_OBJECT
public:
    explicit SelectScreen(QWidget *parent = nullptr);


protected:
    // 添加绘图事件
    void paintEvent(QPaintEvent *event) override;

signals:
    // 触发信号
    void backBtnClicked();

public slots:
};

#endif // SELECTSCREEN_H
