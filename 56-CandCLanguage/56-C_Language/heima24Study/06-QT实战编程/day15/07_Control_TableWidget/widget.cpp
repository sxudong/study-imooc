#include "widget.h"
#include "ui_widget.h"
#include <QMessageBox>

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    /*
     * QTableWidget控件使用
     */
    //1.告诉控件 一共有多少列
    QStringList list;
    list << "姓名"<< "性别"<< "年龄";
    ui->tableWidget->setColumnCount(list.size());     //多少列
    //设置水平头
    ui->tableWidget->setHorizontalHeaderLabels(list); //表头
    //设置行数
    ui->tableWidget->setRowCount(5);  //这里写死了5行
    //设置正文
    //ui->tableWidget->setItem(0,0,new QTableWidgetItem("亚瑟")); // 0行0列 输出“姓名”，使用一个for循环把数据填进去


    //2.准备数据
    QStringList nameList;
    QList<QString> sexList;
    nameList << "亚瑟"<< "妲己"<< "安琪拉"<< "东皇太一"<< "李白";
    sexList << "男" << "女"<< "女"<< "男"<< "男";

    //3.往列中添加数据
    for(int row = 0 ; row < 5; row++)
    {
        int col = 0;
        int i = row;
        ui->tableWidget->setItem(row,col++,new QTableWidgetItem(nameList[i]));  //添加姓名
        ui->tableWidget->setItem(row,col++,new QTableWidgetItem(sexList.at(i))); //添加性别
        //int 转 QString number
        ui->tableWidget->setItem(row,col++,new QTableWidgetItem( QString::number(i+18))); //添加年龄
    }


    //点击“按钮” -> 添加赵云
    connect(ui->addBtn,&QPushButton::clicked,[=](){
        //先判断有没有赵云，有不添加，没有才添加
       bool isEmpty = ui->tableWidget->findItems("赵云",Qt::MatchExactly).empty();

       if(isEmpty)
       {
            ui->tableWidget->insertRow(0);
            ui->tableWidget->setItem(0,0,new QTableWidgetItem("赵云"));
            ui->tableWidget->setItem(0,1,new QTableWidgetItem("男"));
            ui->tableWidget->setItem(0,2,new QTableWidgetItem( QString::number(20)));
       }
       else
       {
            QMessageBox::warning(this,"警告！","赵云有了！");
       }
    });

    //点击“按钮” -> 删除赵云
    connect(ui->delBtn,&QPushButton::clicked,[=](){
        bool isEmpty = ui->tableWidget->findItems("赵云",Qt::MatchExactly).empty();
        if(isEmpty)
        {
            QMessageBox::warning(this,"警告！","赵云没有了！");
        }
        else
        {
            //先找到赵云所在的行
           int row = ui->tableWidget->findItems("赵云",Qt::MatchExactly).first()->row();
           //找到行数  删除掉
           ui->tableWidget->removeRow(row);
        }
    });

}

//析构函数
Widget::~Widget()
{
    delete ui;
}
