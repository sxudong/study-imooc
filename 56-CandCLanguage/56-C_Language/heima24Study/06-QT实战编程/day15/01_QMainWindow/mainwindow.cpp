#include "mainwindow.h"
#include <QMenuBar>    //菜单头文件
#include <QToolBar>    //工具栏头文件
#include <QLabel>      //标签头文件
#include <QStatusBar>  //状态栏头文件
#include <QDockWidget> //浮动窗口，铆接部件头文件
#include <QTextEdit>   //核心部件:文本编辑框头文件

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent) //参数列表
{
    resize(600,400);

    /*
     * 菜单栏
     * 只能有一个
     */
    QMenuBar * bar =  menuBar();
    //将菜单栏放入到窗口中
    this->setMenuBar(bar);

    //创建文件菜单
    QMenu * fileMenu =  bar->addMenu("文件");
    QMenu * editMenu =  bar->addMenu("编辑");

    //添加菜单项
    QAction * newAction =  fileMenu->addAction("新建");
    //添加分割线
    fileMenu->addSeparator();
    QAction * openAction =  fileMenu->addAction("打开");

    /*
     * 工具栏
     * 可以有多个
     */
    QToolBar * toolBar = new QToolBar(this);
    //addToolBar(Qt::RightToolBarArea,toolBar);
    addToolBar(Qt::LeftToolBarArea,toolBar); //默认停靠范围

    //只允许左右侧停靠
    toolBar->setAllowedAreas(Qt::LeftToolBarArea | Qt::RightToolBarArea );

    //设置浮动
    toolBar->setFloatable(false);

    //设置移动 （总开关）
    toolBar->setMovable(false);

    /*
     * 工具栏添加菜单项
     */
    toolBar->addAction(newAction);  //新建
    //添加分割线
    toolBar->addSeparator();
    toolBar->addAction(openAction); //打开


    /*
     * 状态栏
     * 只能有一个
     */
    QStatusBar * stBar = statusBar();
    setStatusBar(stBar);

    QLabel * label1 = new QLabel("提示信息", this);
    stBar->addWidget(label1); //添加提示信息到左侧

    QLabel * label2 = new QLabel("右侧提示信息", this);
    stBar->addPermanentWidget(label2);


    /*
     * 浮动窗口
     * 铆接部件,可以有多个。
     */
    QDockWidget * dock = new QDockWidget("浮动窗口");
    //添加铆接部件到 窗口中
    addDockWidget(Qt::BottomDockWidgetArea, dock);

    //设置停靠范围
    dock->setAllowedAreas(Qt::TopDockWidgetArea | Qt::BottomDockWidgetArea);


    /*
     * 核心部件:文本编辑框
     * 只能一个
     */
    QTextEdit * edit = new QTextEdit;
    setCentralWidget(edit);
}

MainWindow::~MainWindow()
{

}
