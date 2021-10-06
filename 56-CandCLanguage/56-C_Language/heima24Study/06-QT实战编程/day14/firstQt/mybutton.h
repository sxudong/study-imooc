#ifndef MYBUTTON_H
#define MYBUTTON_H

#include <QWidget>
#include <QPushButton>

class MyButton : public QPushButton         //继承QPushButton
{
    Q_OBJECT
public:
    explicit MyButton(QWidget *parent = 0); //explicit 防止构造函数中的隐式类型转换
    ~MyButton();
signals:

public slots:
};

#endif // MYBUTTON_H
