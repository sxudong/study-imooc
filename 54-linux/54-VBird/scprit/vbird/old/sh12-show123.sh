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
# 让使用者能够输入one, two, three ，并且将使用者的变量显示到屏幕上，
# 如果不是 one, two, three 时，就告知使用者仅有这三种选择。
# Program (P391)
#    This script only accepts the flowing parameter: one, two, three.
#    该脚本仅接受流动参数：1、2、3。
# History:
# 2005/08/29 VBird First release
PATH=/bin/:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "This program will print your selection !"
 read -p "Input your choice: " choice
 case $choice in
#case $1 in
  "one")
      echo "Your choice is ONE"
      ;;
  "two")
      echo "Your choice is TWO"
      ;;
  "three")
      echo "Your choice is THREE"
      ;;
  *)
      echo "Usage $0 {one|two|three}" 
      ;;
esac


#程序输出
#[root@]# sh sh12-show123.sh
#This program will print your selection !
#Input your choice: one
#Your choice is ONE
