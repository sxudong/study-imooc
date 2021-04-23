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

abc=123
echo ${abc}
function example (){
	abc=456
}
example      #调用函数
echo ${abc}



#程序输出：
#[root@]# sh sh12-function-2.sh 
#123
#456

