#include "smallwidget.h"      //头文件
#include "ui_smallwidget.h"

SmallWidget::SmallWidget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::SmallWidget)
{
    ui->setupUi(this);

    //QSpinBox移动 Slider跟着移动
    void(QSpinBox:: * signal)(int) = &QSpinBox::valueChanged;
    connect(ui->spinBox,signal,ui->horizontalSlider,&QSlider::setValue); //spinBox组件

    //Slider移动  SpinBox跟着移动
    connect(ui->horizontalSlider,&QSlider::valueChanged,ui->spinBox,&QSpinBox::setValue); //horizontalSlider组件
}

//widget.cpp里调用
void SmallWidget::setValue(int v)
{
    ui->spinBox->setValue(v);
}

//widget.cpp里调用
int SmallWidget::getValue()
{
    return ui->spinBox->value();
}

SmallWidget::~SmallWidget()
{
    delete ui;
}
