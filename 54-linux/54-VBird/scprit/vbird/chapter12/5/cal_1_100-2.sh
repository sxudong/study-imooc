#!/bin/bash
#
# 第13章 学习shell script
# 13.5 循环（loop）
# 13.5.3 for...do...done的数值处理
#
# 语法：
# for ((初始值; 限制值; 执行步阶 ))
# do
#     程序段
# done
#
# Program:（P396）
#      Try do calculate 1+2+3...+${your_input}
#      尝试计算1 + 2 + 3 ... + $ {您的输入}
# History:
# 2005/08/29   VBird   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

read -p "Please input a number, I will count for 1+2+...+your_input: " nu

s=0
for ((i=1; i<=${nu}; i=i+1))
do
	s=$((${s}+${i}))
done
echo "The result of '1+2+3+...+${nu}' is ==> ${s}"


#程序输出：
#[root@]# sh cal_1_100-2.sh 
#Please input a number, I will count for 1+2+...+your_input: 100
#The result of '1+2+3+...+100' is ==> 5050
