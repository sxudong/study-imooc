#!/bin/bash
#
# 第13章 学习shell script
# 13.3.3 shell script 的默认变量（$0,$1,$2 ...）
#
# /path/to/scriptname opt1 opt2 opt3 opt4
#         $0           $1   $2   $3   $4
#
# Program:(P384)
#     Program shows the script name, parameters...
#     程序显示脚本名称，参数... 
#
#	我们也使用中括号的判断来做一个小案例，案例设置如下：
#	  1. 当执行一个程序的时候，这个程序会让使用者选择 Y 或 N ，
#	  2. 如果使用者输入 Y 或 y 时，就显示“ OK, continue ”
#	  3. 如果使用者输入 n 或 N 时，就显示“ Oh, interrupt ！”
#	  4. 如果不是 Y/y/N/n 之内的其他字符，就显示“ I don't know what your choice is ”
#
# History:
# 2009/02/17 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#程序的文件名
echo "The script name is ==> $0"
#共有几个参数
echo "Total parameter number is ==> $#"
#若参数的个数小于2则告知用户参数数量太少
[ "$#" -lt 2 ] && echo "The number of parameter is less than 2. Stop here." && exit 0
#全部的参数内容
echo "Your whole parameter is ==> '$@'"
#第一个参数
echo "The 1st parameter ==> $1"
#第二个参数
echo "The 2nd parameter ==> $2"



#程序输出：
#[dmtsai@study bin]$ sh how_paras.sh theone haha quot
#The script name is ==> how_paras.sh                   <==文件名
#Total parameter number is ==> 3                       <==共有三个参数
#Your whole parameter is ==> 'theone haha quot'        <==参数的内容全部
#The 1st parameter ==> theone                          <==第一个参数
#The 2nd parameter ==> haha                            <==第二个参数