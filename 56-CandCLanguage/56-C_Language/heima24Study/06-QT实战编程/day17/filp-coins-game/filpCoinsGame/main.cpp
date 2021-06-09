#include "mymainwindow.h"

#include <QApplication>
#include "startscreen.h"

#include "selectscreen.h"   // 调试添加作用
#include "playscreen.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    // 旧窗口作为父类被继承，这里注释掉
//    MyMainWindow w;
//    w.show();

    // 开始场景
    StartScreen w;
    w.show();

    // 调试技巧，可以直接跳过已经写好的窗口，直接加载需要调试的窗口
    // 调试记得注释，结束记得撤回；

    // 选择场景
//    SelectScreen w;
//    w.show();
    // 游戏场景
//    PlayScreen w;
//    w.show();

    return a.exec();
}
