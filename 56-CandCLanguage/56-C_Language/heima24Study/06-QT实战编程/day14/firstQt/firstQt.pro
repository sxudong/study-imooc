#-------------------------------------------------
#
# Project created by QtCreator 2016-11-12T09:37:10
#
#-------------------------------------------------

QT       += core gui  #Qt包含的“模块”

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets  #大于4版本 包含widget模块

TARGET = firstQt  #目标 生成的.exe可执行文件的名称
TEMPLATE = app    #模板 应用程序


SOURCES += main.cpp\     #源文件
        mywidget.cpp \
    mybutton.cpp

HEADERS  += mywidget.h \ #头文件
    mybutton.h
