#ifndef PLAYSCENE_H
#define PLAYSCENE_H

#include <QMainWindow>

class PlayScene : public QMainWindow
{
    Q_OBJECT
public:
    //explicit PlayScene(QWidget *parent = 0);


    PlayScene(int levalIndex);


    //具体选择的关卡号
    int levalIndex;

    //重写绘图事件
    void paintEvent(QPaintEvent *);

signals:
    void chooseSceneBack();
public slots:
};

#endif // PLAYSCENE_H
