#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDebug>
#include <QDialog>
#include <QMessageBox>
#include <QColorDialog>
#include <QFileDialog>
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    //点击新建菜单项 弹出对话框
    connect(ui->actionNew, &QAction::triggered, this, [=](){

        /*
         * 对话框  有两种
         */
        //1.模态对话框 （不可以对其他窗口进行操作） 非模态对话框 （可以对其他窗口操作）
//            QDialog dlg(this);
//            dlg.resize(200,100);
//            dlg.exec(); //阻塞
//            qDebug() << "弹出对话框！";

        //2.非模态对话框创建
         //QDialog dlg2(this); 创建到栈上 一闪而过
//        QDialog * dlg2 = new QDialog(this);
//        dlg2->resize(200,100);
//        dlg2->show();
//        //需要设置属性 dlg2   55号
//        dlg2->setAttribute(Qt::WA_DeleteOnClose);

        /*
         * 使用标准对话框  QMessageBox
         * Static Public Members
         */
        //1.错误对话框 critical
//        QMessageBox::critical(this,"错误！","critical");
        //2.信息对话框 information
//        QMessageBox::information(this,"信息","info");
        //3.询问对话框 question
        //参数1 、父亲 2、标题 3、提示内容  4 按键类型 5 关联回车按键
//         if(QMessageBox::Save == QMessageBox::question(this, "问题", "question", QMessageBox::Save | QMessageBox::Cancel, QMessageBox::Cancel))
//         {
//            qDebug() << "点击的是保存";
//         }
//         else
//         {
//            qDebug() << "点击的是取消";
//         }
        //4.警告对话框 warning
//        QMessageBox::warning(this,"警告！","warning");



        /*
         * 选择颜色对话框
         */
//        QColor color =  QColorDialog::getColor(QColor(255,0,0));
//        qDebug() << color.red() << color.green() << color.blue();


        /*
         * 文件对话框
         */
        QString path =  QFileDialog::getOpenFileName(this,"打开文件","C:\\Users\\zhangtao\\Desktop","(*.txt *.png)");
        qDebug() << path;
    });



}

MainWindow::~MainWindow()
{
    delete ui;
}
