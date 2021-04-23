#!/bin/bash
#
# 第13章 学习shell script
# 13.1 条件判断式
# 13.4.3 利用function功能
#
# function 的语法是这样的：
# function fname（） {
#   程序段
# }
#
# Program（P392）
#    Use function to repeat information.使用功能重复信息。
# History:
# 2005/08/29 VBird First release
PATH=/bin/:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

function printit () {
      #echo "Your choice is $1"   # 版本三的写法
	  echo "Your choice is ${1}"  # 这个 $1 必须要参考下面指令的下达
}

echo "This program will print your selection !"
case $1 in
    "one")
	printit 1                     # 请注意， printit 指令后面还有接参数！
	;;
    "two")
	printit 2
	;;
    "three")
	printit 3
	;;
    *)
	echo "Usage $0 {one|two|three}"
	;;
esac


#程序输出：
#[root@]# sh sh12-show123-3.sh two
#This program will print your selection !
#Your choice is 2
