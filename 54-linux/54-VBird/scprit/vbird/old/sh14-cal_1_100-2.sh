#!/bin/bash
#
# 第13章 学习shell script
# 13.5 循环（loop）
# 13.5.1 while do done,until do done(不定循环)
#
# Program:(P394)
#     练习：用户输入一个数字，让程序由 1+2+...直到你输入的数字为止。
#     
# History:
# 2005/08/29  VBird   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

s=0  # 这是加总的数值变量
i=0  # 这是累计的数值，亦即是 1, 2, 3....

read -p "Please input number: " number
while [ "${i}" != "$number" ] #while [ "$i" != "$number" ]
do 
	i=$(($i+1))   # 每次 i 都会增加 1
	s=$(($s+$i))  # 每次都会加总一次！
done
echo "The result of '1+2+3...+100' is ==> $s"


