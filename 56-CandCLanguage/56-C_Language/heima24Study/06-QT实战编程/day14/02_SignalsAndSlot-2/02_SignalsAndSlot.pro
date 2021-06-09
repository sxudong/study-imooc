#-------------------------------------------------
#
# Project created by QtCreator 2017-05-05T14:37:13
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = 02_SignalsAndSlot
TEMPLATE = app


SOURCES += main.cpp\
        widget.cpp \
    teacher.cpp \
    student.cpp

HEADERS  += widget.h \
    teacher.h \
    student.h

CONFIG += c++11
