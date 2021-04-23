#!/bin/bash
#
# 第13章 学习shell script
# 13.5 循环（loop）
# 13.5.2 for do done(固定循环)
#
# 语法：
# for 变量 in con1 con2 con3 ...
# do
#     程序段
# done
#
# Program（P395）
#     Using for...loop to print 3 animals 
#     使用for ...循环打印3种动物
# History:
# 2005/08/29   VBird   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

for animal in dog cat elephant
do
      echo "There are ${animal}s..."
done


#程序输出：
#[root@]# sh show_animal.sh
#There are dogs...
#There are cats...
#There are elephants...
