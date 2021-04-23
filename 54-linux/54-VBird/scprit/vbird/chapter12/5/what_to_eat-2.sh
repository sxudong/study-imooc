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
# 2015/07/17 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

eat[1]="卖当当漢堡包"
eat[2]="肯爷爷炸鸡"
eat[3]="彩虹日式便当"
eat[4]="越油越好吃大雅"
eat[5]="想不出吃啥学餐"
eat[6]="太师父便当"
eat[7]="池上便当"
eat[8]="怀念火车便当"
eat[9]="一起吃方便面"

eatnum=9
eated=0

echo ${#eat[@]} #取得数组元素的个数
echo ${eat[@]}  #获取数组中的所有元素

# eated 如果小于3就执行
while [ "${eated}" -lt 3 ]; do
    check=$(( ${RANDOM} * ${eatnum} / 32767 + 1 ))
    mycheck=0
    # 大于 1
    if [ "${eated}" -ge 1 ]; then
        # 遍历 eatedcon ，查看与随机check是否有重复
        # seq 为 sequence（连续） 的缩写之意
        for i in $( seq 1 ${eated} ) 
        do  
            # 如果数据重复， mycheck 就等于 1，后面就不再打印
            if [ ${eatedcon[$i]} == $check ]; then
                mycheck=1
            fi
         done
    fi

    # mycheck = 1 就不打印
    if [ ${mycheck} == 0 ]; then
        echo "your may eat ${eat[${check}]}" # 打印随机吃什么
        eated=$(( ${eated} + 1 ))    # eated 累加1
        eatedcon[${eated}]=${check}  # eatedcon数组 中添加数据
    fi
done


#[root@shellscript]# sh what_to_eat-2.sh 
#9
#卖当当漢堡包 肯爷爷炸鸡 彩虹日式便当 越油越好吃大雅 想不出吃啥学餐 太师父便当 池上便当 怀念火车便当 一起吃方便面
#your may eat 一起吃方便面
#your may eat 想不出吃啥学餐
#your may eat 彩虹日式便当
