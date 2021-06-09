#ifndef MYWIDGET_H
#define MYWIDGET_H

#include <QWidget>

//MyWidget 继承 QWidget
class MyWidget : public QWidget
{
    Q_OBJECT  //Q_OBJECT宏 写了这个宏 就支持 QT中的信号和槽机制

public:
    MyWidget(QWidget *parent = 0); //构造函数
    ~MyWidget(); //析构函数
};

#endif // MYWIDGET_H
