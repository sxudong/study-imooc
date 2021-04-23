#!/bin/bash
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时4 case-for-while语句使用法
#
# while 的中文是“当....时”，所以，这种方式说的是“当 condition 条件成立时，
# 就进行循环，直到 condition 的条件不成立才停止”的意思。
#     while [ condition ] <==中括号内的状态就是判断式
#     do                  <==do 是循环的开始！
#       ......
#     done                <==done 是循环的结束
#
# “当 condition 条件成立时，就终止循环，否则就持续进行循环的程序段。”
#     until [ condition ]
#     do
#       ......
#     done
#
# Program:
#    求10以内的自然数的平方值。如:1*1=1 2*2=43*3=9 ...
# History:
# 2021/01/15   Aaron  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

num=1
while [ $num -le 10 ]
do
	square=`expr $num \* $num`
	echo $square
	num=`expr $num + 1`
done


#程序输出：
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh13-while_do_done-2.sh 
#1
#4
#9
#16
#25
#36
#49
#64
#81
#100

