#!/bin/bash
#
# 第13章 学习shell script
# 13.1 条件判断式
# 13.4.3 利用function功能
#
# function 的语法是这样的：
# function 函数名（） {    #function可以不写
#   程序段
# }
#
# 函数：把一个功能封装起来。使用时直接调用函数名。这样的脚本好处∶模块，代码可读性强。
# Program （P391）
#    Use function to repeat information.使用功能重复信息。
# History:
# 2005/08/29 VBird First release
PATH=/bin/:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function printit () {
    echo -n "Your choice is "         # 加上 -n 可以不断行继续在同一行显示
}

echo "This program will print your selection !"
case $1 in
    "one")
	printit; echo $1 | tr 'a-z' 'A-Z' # 将参数做大小写转换！
	;;
    "two")
	printit; echo $1 | tr 'a-z' 'A-Z'
	;;
    "three")
	printit; echo $1 | tr 'a-z' 'A-Z'
	;;
    *)
	echo "Usage $0 {one|two|three}"
	;;
esac


#程序输出：
#[root@]# sh sh12-show123-2.sh two
#This program will print your selection !
#Your choice is TWO
