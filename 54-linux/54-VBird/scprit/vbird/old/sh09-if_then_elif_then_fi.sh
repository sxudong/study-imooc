#!/bin/bash
#
# 第13章 学习shell script
# 13.1 条件判断式
# 13.4.1 利用if...then
#
# 复杂的情况语法：
# if[条件判断式一]; then
#     ......
# elif[条件判断式一]; then
#     ......
# else
#
# Program:（P387）
#    Check $1 is equal to "hello" 
#    检查 变量1 是否等于"hello"
#
#	1. 判断 $1 是否为 hello，如果是的话，就显示 "Hello, how are you ?"；
#	2. 如果没有加任何参数，就提示使用者必须要使用的参数下达法；
#	3. 而如果加入的参数不是 hello ，就提醒使用者仅能使用 hello 为参数。
#
# History:
# 2005/08/28 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ "$1" == "hello" ]; then
    echo "Hello, how are you ?"
elif [ "$1" == "" ]; then
    echo "You MUST input parameter, ex> {$0 someword}"
else
    echo "The only parameter is 'hello', ex> {$0 hello}"
fi


#程序输出：
#[root@]# sh sh09-if_then_elif_then_fi.sh hello
#Hello, how are you ?
#
#[root@]# sh sh09-if_then_elif_then_fi.sh 
#You MUST input parameter, ex> {sh09-if_then.sh someword}

