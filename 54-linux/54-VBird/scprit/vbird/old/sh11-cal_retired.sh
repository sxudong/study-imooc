#!/bin/bash
#
# 第13章 学习shell script
# 13.1 条件判断式
# 13.4.1 利用if...then
#
#  需求：当兵的想知道退伍的日期
#  整个脚本的制作流程：
#    1. 先让使用者输入他们的退伍日期；
#    2. 再由现在日期比对退伍日期；
#    3. 由两个日期的比较来显示“还需要几天”才能够退伍的字样。
#
# Program:(P389)
#    You input your demobilization date, I calculate how many days before you demobilize.
#    您输入遣散日期，我计算出遣散多少天。
#
# History:
# 2005/08/29 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export=PATH


# 1. 告知使用者这支程序的用途，并且告知应该如何输入日期格式？
echo "This program will try to calculate : "
echo "How many days before your demobilization date..."
read -p "Please input your demobilization date (YYYYMMDD ex> 20090401) : " date2

# 2. 测试一下，这个输入的内容是否正确？利用正则表达式啰～
date_d=$( echo $date2 | grep '[0-9]\{8\}' )               # 看看是否有八个数字
if [ "$date_d" == "" ]; then
     echo "You input the worong date format...."
     exit 1
fi

# 3. 开始计算日期啰～
# declare语法：declare [-aixrp] variable 
# -i: 将后面名为variabl的变量定义为整数数字（integer）类型

#第三版的写法
#declare -i date_dem=`date --date="$date2" +%s`            # 退伍日期秒数
#declare -i date_now=`date +%s`                            # 现在日期秒数
#declare -i date_total_s=$(($date_dem-$date_now))          # 剩余秒数统计
#declare -i date_d=$(($date_total_s/60/60/24))             # 转为日数
#if [ "$date_total_s" -lt "0" ]; then                      # 判断是否已退伍
#     echo "You had been demobilization before: " $((-1*$date_d)) " ago"
#else
#     declare -i date_h=$(($((date_total_s-$date_d*60*60*24)) /60/60))
#     echo "You will demobilize after $date_d days and $date_h hours."
#fi

#第四版的写法
#declare -i date_dem=$(date --date="${date2}" +%s)        # 退伍日期秒数
declare -i date_dem=$(date +%s -d "${date2}" )            # 退伍日期秒数
declare -i date_now=$(date +%s)                           # 现在日期秒数
declare -i date_total_s=$((${date_dem}-${date_now}))      # 剩余秒数统计
declare -i date_d=$((${date_total_s}/60/60/24))           # 转为日数

if [ "${date_total_s}" -lt "0" ]; then                    # 判断是否已退伍
    # $((运算内容)) 13.2.1 P378
	echo "You had been demobilization before: " $((-1*${date_d})) " ago"
else
	declare -i date_h=$(($((${date_total_s}-${date_d}*60*60*24))/60/60))
	echo "You will demobilize after ${date_d} days and ${date_h} hours."
fi


#程序输出：
#[root@]# sh sh11-cal_retired.sh
#This program will try to calculate : 
#How many days before your demobilization date...
#Please input your demobilization date (YYYYMMDD ex> 20090401) : 20220315
#You will demobilize after 424 days and 1 hours.
