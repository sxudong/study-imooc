#!/bin/bash
# 第13章 学习shell script 
# 13.2.1 简单范例
# Program:(P377)
#    User inputs his fisrst name and last name. Program shows his full name.
#    用户输入他的名字和姓氏。 程序显示他的全名。
#History:
#2005/08/23 VBird Fist release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input your first name: " firstname    # 提示用户输入
read -p "Please input your last name:  " lastname     # 提示用户输入
echo -e "\nYour full name is: $firstname $lastname"   # 结果由屏幕输出 

#输出结果：
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh02-showFullName.sh
#Please input your first name: Sun
#Please input your last name:  Wukong
#
#Your full name is: Sun Wukong

#利用 source 来执行脚本：在父进程中执行
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# source sh02-showFullName.sh 
#Please input your first name: Sun
#Please input your last name:  Wukong

#Your full name is: Sun Wukong
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# echo $firstname $lastname
#Sun Wukong
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# 
