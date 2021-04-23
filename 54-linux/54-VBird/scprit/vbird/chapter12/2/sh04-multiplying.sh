#!/bin/bash
# 第13章 学习shell script 
# 13.2.1 简单范例
#
# 数值运算：简单的加减乘除
#
# var=$((运算内容))
# 示例：[root]# echo $(( 13 % 3 ))
#       1
#
# Program（P378）
#       User inputs 2 integer numbers; program will cross these two numbers.
#       用户输入2个整数； 程序将交叉这两个数字。
# History:
# 2005/08/23 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo -e "You SHOULD input 2 numbers, I will cross them! \n"
read -p "first number: " firstnu                             #输入第一个数字
read -p "second number: " secnu                              #输入第二个数字
total=$(($firstnu*$secnu))                                   #相乘
echo -e "\n The result of $firstnu x $secnu is ==> $total"


#运算输出：
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh04-Multiply.sh 
#You SHOULD input 2 numbers, I will cross them! 
#
#first number: 3
#second number: 5
#
# The result of 3 x 5 is ==> 15
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# 


