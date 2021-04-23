#!/bin/bash
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时8 shifit命令使用方法
#
# 例子:
#   做一个加法计算器，求出所有参数的和
#   实现的思路:
#   求:12+12+1+1
#   $#> 0
#   sum = sum + $1.shift
#
# History:
# 2009/02/17 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


if [ $# -le 0 ]; then
	echo "err! : Not enough parameters"
	exit 124
fi

sum=0
while [ $# -gt 0 ]
do
	sum=`expr ${sum} + $1`
	shift
done
echo ${sum}


#程序输出:
#[root@]# sh sh08-shift.sh 10 20 30
#60
