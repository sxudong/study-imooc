#!/bin/bash
#
# 第13章 学习shell script
# 13.5 循环（loop）
# 13.5.1 while do done,until do done(不定循环)
#
# Program:(P394)
#     Use loop to calculate "1+2+3+...+100" result.
#     使用循环计算“ 1 + 2 + 3 + ... + 100”结果。
# History:
# 2005/08/29  VBird   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

s=0  # 这是加总的数值变量
i=0  # 这是累计的数值，亦即是 1, 2, 3....

while [ "${i}" != "100" ] #while [ "$i" != "100" ]
do 
	i=$(($i+1))   # 每次 i 都会增加 1
	s=$(($s+$i))  # 每次都会加总一次！
done
echo "The result of '1+2+3...+100' is ==> $s"


#程序输出：
#[root@]# sh sh14-cal_1_100.sh 
#The result of '1+2+3...+100' is ==> 5050
