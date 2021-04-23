#!/bin/bash
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时6 shell循环嵌套使用方法
#
# echo * #此命令中*表示匹配当前目录下所有文件名。所以应该:echo "*"
#
# 循环语句嵌套
# Program:
#    使用特殊符号打印三角形。要求整个程序要有交互，
#    运行时可以自动输入打印的行数和用于描绘三角形
#    的特殊符号。
#
# 思路:双重循环外层∶控制∶行数
# 内层:每行输出的*的个数
# 第一行一个，第二行二个，第三行三个，。。。第五行五个。规律:每行输出的*数等于行号。
#
# History:
# 2021/01/15   Aaron  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please Enter the line number: " Line
read -p "Please Enter the char number: " char

a=1
while [ $a -le $Line ]
do
	b=1
	while [ $b -le $a ]
	do
		echo -n "$char"
		b=`expr $b + 1`
	done
	echo
	a=`expr $a + 1`
done


#程序输出：
#[root@]# sh sh13-while_do_done-3.sh 
#Please Enter the line number: 5
#Please Enter the char number: *
#*
#**
#***
#****
#*****

