#!/bin/bash
# 第13章 学习shell script 
# 13.1.2 第一个script的编写与执行
# Program:(P375)
#     This program shows "Hello World!" in your screen.
#     该程序显示“ Hello World！” 在您的屏幕上。
#History;
#2014/12/04 sxudong First release
PATH=/bin:/sbin:/usr/bin/:usr/sbin:/usr/local/bin:/usr/local/sbin:/root/bin
export PATH

echo -e "Hello World! \a \n"
exit 0

#输出结果：
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh01-HelloWorld.sh
#Hello World!  

