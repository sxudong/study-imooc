#!/bin/bash
# 第13章 学习shell script
# 13.3.1 利用test命令的测试功能
#
# 示例：
# [dmtsai@study ~]$ test -e /dmtsai && echo "exist" || echo "Not exist"
#  Not exist <==结果显示不存在啊！
# 
# Program:（P381）
#    User input a filename,Program will check the flowing:
#    1.)exist?  2.) file/directory? 3.) file permissions
#
#    用户输入文件名，程序将按下面流程检查：
#    1.）存在吗？ 2.）文件/目录？ 3.）文件权限
#
# History:
# 2005/08/25 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#1、让用户输入文件名,并且判断用户是否真的有输入字符串
echo -e "Please input a filename, I will check the filename's type and permission. \n\n"  #纯粹显示信息
read -p "Input a filename : " filename       #提示用户输入

test -z $filename && echo "You MUST input a filename." && exit 0

#2、判断文件是否存在？若不存在则显示信息并结束脚本
test ! -e $filename && echo "The filename '$filename' DO NOT exist" && exit 0

#3、开始判断文件类型和属性
test -f $filename && filetype="regular file"   #常规文件
test -d $filename && filetype="directory"      #目录
test -r $filename && perm="readable"           #可读的
test -w $filename && perm="$perm writeable"    #可读的、可写的
test -x $filename && perm="$perm executable"   #可读的、可写的、可执行文件

#4、开始输出信息！
echo "The filename: $filename is a $filetype"
echo "And the permission are : $perm"


#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh05-test_command.sh 
#Please input a filename, I will check the filename's type and permission. 
#
#
#Input a filename : sh04-Multiply.sh
#The filename: sh04-Multiply.sh is a regular file
#And the permission are : readable writeable

