#include "mybutton.h"
#include <QDebug>
MyButton::MyButton(QWidget *parent) : QPushButton(parent)
{

}

MyButton::~MyButton()
{

    qDebug() << "MyButton的析构";
}
