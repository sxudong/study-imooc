#ifndef MYBUTTON_H
#define MYBUTTON_H

#include <QWidget>
#include <QPushButton>

class MyButton : public QPushButton         //�̳�QPushButton
{
    Q_OBJECT
public:
    explicit MyButton(QWidget *parent = 0); //explicit ��ֹ���캯���е���ʽ����ת��
    ~MyButton();
signals:

public slots:
};

#endif // MYBUTTON_H
