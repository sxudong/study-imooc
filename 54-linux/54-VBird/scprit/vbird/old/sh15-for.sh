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
# 分析:.
#  1、外层控制输出几行
#  2、内层循环1:每行输出“空格”的个数
#     内层循环2:每行输出的 * 的个数
#
# 内层循环1∶每行输出空格的个数
# 指定每一行输出的空格数。第一行需要输出2个空格，第二行需要输出1个,
# 第三行输出0个空格。得出结论，空格数等于:总行数Line-当前行号。
#
# 内层循环2:每行输出的 * 的个数
# 第一行一个*，第二行两个*，第三个5个*。每行的*数等于:当前行号x2-1
# History:
# 2021/01/15   Aaron  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please Enter the line number: " Line #获取号行

#使用行号来控制一共循环的次数
for ((i=1; i<=Line; i++)) 
do
    #指定每一行输出的空格数。第一行需要输出2个空格，
	#第二行需要输出1个,第三行输出0个空格。
	#得出结论，空格数等于:总行数Line-当前行号。
	for ((j=${Line}-$i; j>0; j--)) 
	do
		echo -n ' '
	done
	#第一行一个*，第二行两个*，第三行五个*。
	#每行的*数等于:当前行号x2-1
	for ((h=1; h<=((2*$i-1)); h++))
	do	
		echo -n '*'  #输出内容时，不换行
	done
	echo
done	



#程序输出：
#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh13-while_do_done-4.sh 
#Please Enter the line number: 5
#    *
#   ***
#  *****
# *******
#*********


