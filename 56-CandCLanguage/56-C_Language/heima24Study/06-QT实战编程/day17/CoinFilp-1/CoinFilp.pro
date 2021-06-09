#-------------------------------------------------
#
# Project created by QtCreator 2018-08-12T09:17:11
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = CoinFilp
TEMPLATE = app


SOURCES += main.cpp\
        mainscene.cpp \
    mypushbutton.cpp \
    chooselevelscene.cpp \
    playscene.cpp

HEADERS  += mainscene.h \
    mypushbutton.h \
    chooselevelscene.h \
    playscene.h

FORMS    += mainscene.ui

RESOURCES += \
    res.qrc
