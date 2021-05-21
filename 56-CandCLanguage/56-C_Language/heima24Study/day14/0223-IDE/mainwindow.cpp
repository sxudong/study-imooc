#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QTextCodec>
#include <QFileDialog>
#include <QString>
#include <QDebug>
#include <QByteArray>
#include <string.h>
#define cout qDebug()


QString fileName=NULL;
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::saveFile(const char * file,const char * buf)
{
    FILE * fp = fopen(file,"w");
    if(!fp)
        return;

    //保存文件
    fputs(buf,fp);

    fclose(fp);
}

/**
 * 打开文件
 */
void MainWindow::on_action_4_triggered()
{
    //打开文件
    /*1、foprn（文件名，打开方式）
     * 2、判断可用性
     * 3、读取内容
     * 4、关闭
     */
    //通过对话框打开文件 获取文件路径 QString
    fileName = QFileDialog::getOpenFileName();
    //cout<<"===="<<fileName<<"====";
    //将QString转化为char *
    QTextCodec * codec = QTextCodec::codecForName("GBK");

    //char * file =codec->fromUnicode(fileName).data();
    QByteArray ba = fileName.toLatin1();
    char * file  = ba.data();
    FILE * fp = fopen(file,"r");
    if(!fp)
    return;
    char  buf[1024];
    QString txt;
    while(!feof(fp))
    {
        memset(buf,0,1024);
        fgets(buf,1024,fp);
        //cout<<buf;
        txt +=codec->toUnicode(buf);
    }

    //为文本输入标签设置内容
    ui->textEdit->setText(txt);

    fclose(fp);
}


/**
 * 保存文件
 */
void MainWindow::on_actionBaocun_triggered()
{
    if(fileName==NULL)
    //打开文件
    fileName = QFileDialog::getSaveFileName();

   //转码
    QTextCodec * codec  = QTextCodec::codecForName("GBK");

    char * file = codec->fromUnicode(fileName).data();

    //读取textedit
    QString txt = ui->textEdit->toPlainText();
    //转成char*
    const char * buf = txt.toStdString().data();

    saveFile(file,buf); //调用上面实现的方法saveFile()，在mainwindow.h头文件中定义
}

/**
 * 新建
 */
void MainWindow::on_action_5_triggered()
{
    //ui->textEdit->setText("");

    //提示是用户保存
    ui->textEdit->clear();
    fileName.clear();
}


/**
 * 退出
 */
void MainWindow::on_action_7_triggered()
{
    //提示是用户保存
    exit(0);
}


/**
 * 编辑 -> 撤销
 */
void MainWindow::on_action_8_triggered()
{
    //撤销
    ui->textEdit->undo();
}


/**
 * 编辑 -> 复制
 */
void MainWindow::on_action_9_triggered()
{
    //拷贝
    ui->textEdit->copy();
}


/**
 * 编辑 -> 粘贴
 */
void MainWindow::on_action_10_triggered()
{
    //粘贴
    ui->textEdit->paste();
}


/**
 * 编辑 -> 剪切
 */
void MainWindow::on_action_11_triggered()
{
    //剪切
    ui->textEdit->cut();
}


/**
 * 编译
 */
void MainWindow::on_action_12_triggered()
{
    /* 1、保存文件（如果文件保存）
     * 2、组装gcc格式
     * 3、编译 如果出错提示错误信息   运行程序
     *
     */
    if(fileName ==NULL)
    {

        fileName = QFileDialog::getSaveFileName();
        QTextCodec * codec = QTextCodec::codecForName("GBK");
        const char * file = codec->fromUnicode(fileName).data();

        QString txt = ui->textEdit->toPlainText();
        const char * buf = txt.toStdString().data();
        saveFile(file,buf);
    }
    else
    {
        //gcc -o D:\a.exe D:\a.c

        QString des = fileName;
        des.replace(".c",".exe");
        //cout<<des;
        char  comm[1024]="gcc -o ";
        strcat(comm,des.toStdString().data());
        strcat(comm," ");
        strcat(comm,fileName.toStdString().data());

        //程序编译成功system 返回值为0
        if(!system(comm))
        {
            //程序编译成功后，直接运行编译后的命令
            char cmd[256]="cmd /k ";
            strcat(cmd,des.toStdString().data());
            cout<<cmd;
            system(cmd);
        }
        else
        {
            //cmd /k gcc -o D:\a.exe D:\a.c
            char cmd[256] = "cmd /k  ";
            strcat(cmd,comm);
            system(cmd);
        }
    }
}


/**
 * 另存为
 */
void MainWindow::on_action_6_triggered()
{
    //打开文件
    fileName = QFileDialog::getSaveFileName();

   //转码
    QTextCodec * codec  = QTextCodec::codecForName("GBK");

    char * file = codec->fromUnicode(fileName).data();

    //读取textedit
    QString txt = ui->textEdit->toPlainText();
    //转成char*
    const char * buf = txt.toStdString().data();

    saveFile(file,buf);
}


void MainWindow::on_action_13_triggered()
{

}
