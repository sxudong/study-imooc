#include "student.h"
#include <QDebug>
Student::Student(QObject *parent) : QObject(parent)
{

}

void Student::treat()
{
    qDebug() << "请老师吃饭";
}


void Student::treat(QString foodName)
{
    //qDebug() << "请老师吃饭 ，老师要吃："<< foodName; //qDebug()打印，相当于cout打印

    //QString 转 char* ，1.先转成 QByteArray类型，2.再转char *
    qDebug() << "请老师吃饭 ，老师要吃："<< foodName.toUtf8().data();
}
