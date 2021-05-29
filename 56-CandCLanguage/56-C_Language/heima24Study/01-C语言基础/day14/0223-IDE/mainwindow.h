#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

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
    void on_action_4_triggered();

    void on_actionBaocun_triggered();

    void on_action_5_triggered();

    void on_action_7_triggered();

    void on_action_8_triggered();

    void on_action_9_triggered();

    void on_action_10_triggered();

    void on_action_11_triggered();


    void saveFile(const char * file,const char * buf);

    void on_action_12_triggered();

    void on_action_6_triggered();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
