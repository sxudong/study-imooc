#!/bin/bash
#
# 第13章 学习shell script
# 13.3.2 利用判断符号[]
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
elif
     [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
     echo "Oh, interrupt!" 
else
    echo "I don't know what your choice is."
fi


#程序运行输出：
#[root@]# sh sh06-choice2.sh 
#Please input (Y/N) : Y
#OK, continue