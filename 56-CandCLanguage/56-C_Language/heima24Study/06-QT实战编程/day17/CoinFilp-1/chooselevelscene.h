#ifndef CHOOSELEVELSCENE_H
#define CHOOSELEVELSCENE_H

#include <QMainWindow>
#include "playscene.h"

class ChooseLevelScene : public QMainWindow
{
    Q_OBJECT
public:
    explicit ChooseLevelScene(QWidget *parent = 0);

    //重写绘图事件
    void paintEvent(QPaintEvent *);

    PlayScene * playScene;

signals:

    //点击返回按钮后 抛出自定义信号
    void chooseSceneBack();

public slots:
};

#endif // CHOOSELEVELSCENE_H
