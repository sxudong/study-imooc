#include "mybutton.h"
#include <QDebug>

MyButton::MyButton(QWidget *parent) : QPushButton(parent)
{

}

//析构函数
MyButton::~MyButton()
{
    qDebug() << "MyButton调用析构了！";
}