#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <time.h> //随机操作的头文件

//Java package 相当于C++中的 namespace
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

private slots:
    void on_pushButton_clicked();

    void on_pushButton_2_clicked();

    void on_pushButton_3_clicked();

//定义私有变量
private:
    Ui::MainWindow *ui;
    unsigned int start_time;
    unsigned int end_time;
    int value=0;
    char arr[21];
};

#endif // MAINWINDOW_H
