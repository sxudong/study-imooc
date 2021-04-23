#!/bin/bash
#
# 第13章 学习shell script
# 13.3.2 利用判断符号[]
# 13.4.1 利用if...then
#
# 示例：如果想要知道 ${HOME} 这个变量是否为空的，可以这样做：
# [root@]# [ -z "${HOME}" ] ; echo $?
# 1
# [root@]# [ -z "${HOM}" ] ; echo $?
# 0
#
# Program:
# This program shows the user's choice 该程序显示用户的选择
# History:
# 2005/08/25 VBird First release 
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input (Y/N) : " yn

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
    echo "OK, continue"
    exit 0
fi

if [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
    echo "Oh, interrupt!" 
    exit 0
fi
echo "I don't know what your choice is" && exit 0



#程序运行输出：
#[root@]# sh sh09-if_then1.sh 
#Please input (Y/N) : Y
#OK, continue
