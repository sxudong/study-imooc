#ifndef MYWIDGET_H
#define MYWIDGET_H

#include <QWidget>

class MyWidget : public QWidget  //MyWidget继承QWidget
{
    Q_OBJECT  //Q_OBJECT宏 写了这个宏 就支持了 Qt中的信号和槽机制

public:
    MyWidget(QWidget *parent = 0);  //构造函数
    ~MyWidget(); //析构函数
};

#endif // MYWIDGET_H
