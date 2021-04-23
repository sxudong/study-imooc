#!/bin/bash
# 第12章 学习Shell Scripts
# 12.5.4 —— 搭配乱数与阵列的实验
#
# Program:
# Try do tell you what you may eat.
# 中午吃什么不知道，执行这只脚本后，直接跟你说要吃啥?
# 如果想要每次都秀出 3 个店家呢？ 而且这个店家不能重复！
#
# History:
# 执行这只脚本后， 直接跟你说要吃啥
# 2015/07/17 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

eat[1]="卖当当漢堡包" # 写下你所收集到的店家！
eat[2]="肯爷爷炸鸡"
eat[3]="彩虹日式便当"
eat[4]="越油越好吃大雅"
eat[5]="想不出吃啥学餐"
eat[6]="太师父便当"
eat[7]="池上便当"
eat[8]="怀念火车便当"
eat[9]="一起吃方便面"
eatnum=9            # 需要输入有几个可用的餐厅数！
check=$(( ${RANDOM} * ${eatnum} / 32767 + 1 ))
echo "your may eat ${eat[${check}]}" 

# 程序输出：
# [root@]# sh what_to_eat.sh 
# your may eat 一起吃方便面
# [root@iZwz95axph2ymsv7esqmb0Z shellscript]# sh what_to_eat.sh 
# your may eat 彩虹日式便当
