#!/bin/bash
#
# 第13章 学习shell script
# 13.1 条件判断式
# 13.4.2 利用case...esac判断
#
# case $变量名称 in       <==关键字为 case ，还有变量前有钱字号
#     "第一个变量内容"）  <==每个变量内容建议用双引号括起来，关键字则为小括号 ）
#      ...
#      ;;                 <==每个类别结尾使用两个连续的分号来处理！
#     "第二个变量内容"）
#      ...
#      ;;
# *）                     <==最后一个变量内容都会用 * 来代表所有其他值
#     ...                 <==不包含第一个变量内容与第二个变量内容的其他程序执行段
#     exit 1
#     ;;
# esac                    <==最终的 case 结尾！“反过来写”思考一下
#
# Program:(P390)
#    Show "hello" from $1....by using case...esac
#    使用case ... esac显示$1...“ hello”。...
# History:
# 2005/08/29 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

case $1 in
 "hello" )
    echo "Hello, how are you ?"
    ;;
"")
    echo "You MUST input parameter, ex> {$0 someword}"
    ;;
*)  #其实就相当于万用字符，0~无穷多个任意字符之意！
    echo "Usage $0 {hello}"
    ;;
esac


#程序输出：
#[root@]# sh sh12-hello-3.sh hello
#Hello, how are you ?
