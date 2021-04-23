#!/bin/bash
#
# 第13章 学习shell script
# 13.5 循环（loop）
# 13.5.1 while do done,until do done(不定循环)
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
# Program:(P393)
#    Repeat question until user input correct answer.
#    重复问题，直到用户输入正确答案为止。
# History:
# 2005/08/29   VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#第三版写法
#while [ "$yn" != "yes" -a "$yn" != "YES" ]
while [ "${yn}" != "yes" -a "${yn}" != "YES" ]
do
	read -p "Please input yes/YES to stop this program: " yn
done
echo "OK! you input the correct answer."


#程序输出：
#[root@]# sh sh13-yes_to_stop.sh 
#Please input yes/YES to stop this program: yes
#OK! you input the correct answer.
