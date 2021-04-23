#!/bin/bash
#
# function 的语法是这样的：
# function 函数名（） {    #function可以不写
#   程序段
# }
#
# 函数：把一个功能封装起来。使用时直接调用函数名。这样的脚本好处∶模块，代码可读性强。
#
# History:
# 2021/01/15 Aaron First release
PATH=/bin/:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

###定义函数，使用参数
example2 () {
	echo $1
	echo $2
}
###调用函数，向它传递参数
example2 aaa bbb


#程序输出：
#[root@]# sh sh12-function-3.sh 
#aaa
#bbb

