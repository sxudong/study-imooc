#!/bin/bash
# 第13章 学习shell script
# 13.3.3 shell script 的默认变量（$0,$1,$2 ...）
#
# shift: 造成参数变量号码偏移
# Program:（P384）
#     Program shows the effect of shift function
#     程序显示移位功能的效果
# History:
# 2009/02/17 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "Total parameter number is ==> $#"
echo "Your whole parameter is ==> '$@'"
# 进行第一次“一个变量的shift”
shift 
echo "Total parameter number is ==> $#"
echo "Your whole parameter is ==> '$@'"
# 进行第二次“三个变量的shift”
shift 3 
echo "Total parameter number is ==> $#"
echo "Your whole parameter is ==> '$@'"


#程序输出
#[dmtsai@study bin]$ sh shift_paras.sh one two three four five six <==给予六个参数
#Total parameter number is ==> 6                                   <==最原始的参数变量情况
#Your whole parameter is ==> 'one two three four five six'
#Total parameter number is ==> 5                                   <==第一次偏移，看下面发现第一个 one 不见了
#Your whole parameter is ==> 'two three four five six'
#Total parameter number is ==> 2                                   <==第二次偏移掉三个，two three four 不见了
#Your whole parameter is ==> 'five six'
