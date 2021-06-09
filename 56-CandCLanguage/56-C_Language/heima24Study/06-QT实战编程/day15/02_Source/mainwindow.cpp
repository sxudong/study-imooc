#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow) //使用图型化添加组件，可以节省代码
{
    //意思是在一个指定的窗口建立起ui。
    //它按照Qt设计器里设计的样子把窗体画出来，把Qt设计器里面定义的信号和槽建立起来。
    //https://www.cnblogs.com/Stephen-Qin/p/13532254.html
    //https://blog.csdn.net/songjinshi/article/details/7333119
    ui->setupUi(this);

    /*
     * 通过ui寻找控件
     *   ui->actionNew->setIcon(QIcon("E:/Image/Luffy.png"));
     *
     * 1.添加资源文件 到项目中
     * 2.使用资源文件 " : + 前缀名 + 文件名 "
     */
    ui->actionNew->setIcon(QIcon(":/Image/Luffy.png"));     //"新建"添加图片
    ui->actionOpen->setIcon(QIcon(":/Image/OnePiece.png")); //"打开"添加图片

}

//析构函数
MainWindow::~MainWindow()
{
    delete ui;
}
