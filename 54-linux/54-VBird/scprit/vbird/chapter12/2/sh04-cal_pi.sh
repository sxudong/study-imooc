#!/bin/bash
# 第13章 学习shell script 
# 13.2.1 简单范例
#
# bc指令 想要计算含有小数点的数据时，其实可以通过 bc 这个指令的协助
#
# var=$((运算内容))
# 示例：[root]# echo "123.123*5539" | bc
#       681978.297
#
# 数值运算：通过 bc 计算 pi （PI指圆周率）
#
# Program:
# User input a scale number to calculate pi number.
# 用户输入scale以计算pi数值。
# History:
# 2015/07/16 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo -e "This program will calculate pi value. \n"
echo -e "You should input a float number to calculate pi value.\n"

read -p "The scale number （10~10000） ? " checking
# :-句法 如果$checking存在且不为空，num值就是$checking。如果$checking不存在或为空，num值就是$checking就是10
# 参阅：linux bash shell之变量替换：:=句法、=句法、:-句法、-句法、=?句法、?句法、:+句法、+句法
# https://www.cnblogs.com/fhefh/archive/2011/04/22/2024750.html
num=${checking:-"10"}  #开始判断有否有输入数值

echo -e "Starting calcuate pi value. Be patient."
# 4*a（1） 是 bc 主动提供的一个计算 pi 的函数
# scale 就是要 bc 计算几个小数点下位数的意思.当 scale 的数值越大， 代表 pi 要被计算的越精确
time echo "scale=${num}; 4*a（1）" | bc -lq



#[root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh sh04-cal_pi.sh
#This program will calculate pi value. 
#
#You should input a float number to calculate pi value.
#
#The scale number （10~10000） ? 15
#Starting calcuate pi value. Be patient.
#(standard_in) 1: illegal character: \357
#(standard_in) 1: illegal character: \274
#(standard_in) 1: illegal character: \210
#(standard_in) 1: syntax error
#(standard_in) 1: illegal character: \357
#(standard_in) 1: illegal character: \274
#(standard_in) 1: illegal character: \211
#
#real    0m0.002s
#user    0m0.000s
#sys     0m0.001s
