#ifndef STARTSCREEN_H
#define STARTSCREEN_H

#include <QMainWindow>
#include "mymainwindow.h"
#include "mypushbutton.h"
#include "selectscreen.h"

class StartScreen : public MyMainWindow
{
    Q_OBJECT
public:
    explicit StartScreen(QWidget *parent = nullptr);

signals:

public slots:
    // 添加
private:
    SelectScreen mSelectScreen;

};

#endif // STARTSCREEN_H
