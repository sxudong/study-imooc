#include "widget.h"
#include "ui_widget.h"
#include <QDebug>
Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    /*
     * 单选按钮
     *   默认选中“男”
     */
    ui->rBtnMan->setChecked(true);

    //点击女的 就打印选中了
    connect(ui->rBtnWoman, &QRadioButton::clicked, [=](){
        qDebug() << "选中女的了！";
    });


    /*
     * 多选框
     *   状态改变 0 未选中 1 半选tristate 2 全选
     */
    connect(ui->checkBox, &QCheckBox::stateChanged, [=](int state){
        qDebug() << state ;
    });


    /*
     * 利用listWidget 写诗
     */
    //方式一：
//    QListWidgetItem  * item = new QListWidgetItem("锄禾日当午");
//    //设置对齐方式
//    item->setTextAlignment(Qt::AlignHCenter);
//    ui->listWidget->addItem(item);

    //方式二：
    //QStringList ===  QList<QString>
    QStringList list;
    list << "锄禾日当午"<< "汗滴禾下土"<< "谁知盘中餐"<< "粒粒皆辛苦";
    //匿名对象也可以直接使用
    //ui->listWidget->addItems(QStringList()<<"锄禾日当午"<< "汗滴禾下土"<< "谁知盘中餐"<< "粒粒皆辛苦");
    ui->listWidget->addItems(list);
}

//析构函数
Widget::~Widget()
{
    delete ui;
}
