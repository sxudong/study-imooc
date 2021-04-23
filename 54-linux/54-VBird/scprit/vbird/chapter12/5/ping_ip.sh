#!/bin/bash
#
# 第13章 学习shell script
# 13.5 循环（loop）
# 13.5.2 for do done(固定循环)
#
# 语法：
# for var in con1 con2 con3 ...
# do
#     程序段
# done
#
# 下面这一串指令执行之后就可以显示出 192.168.1.1~192.168.1.100 共 100 部主机
# 目前是否能与你的机器连通！
# Program:（P395）
#      Use ping command to check the network's PC state.
#      使用ping命令检查网络的PC状态。
# History:
# 2009/02/18  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

network="192.168.1"            # 先定义一个网域的前面部分！
for sitenu in $(seq 1 100)     # seq 为 sequence（连续） 的缩写之意
do
    # 下面的程序在取得 ping 的回传值是正确的还是失败的！"192.168.1.xxx"
	# ping参数解释：
	#   -c ping指定次数后停止ping; 
	#   -w deadline;
	# command &> filename 重定向command的标准输出(stdout)和标准错误(stderr)到文件filename中；
	# /dev/null 可以吃掉任何导向这个设备的信息,指标准输出和错误输出都输出到/dev/null上，而不在界面上显示；
	# &&和|| 是与和或得意思，如a&&b||c ，表示a为真，则执行b；否则执行c
	ping -c 1 -w 1 ${network}.${sitenu} &> /dev/null && result=0 || result=1
	# 开始显示结果是正确的启动 （UP） 还是错误的没有连通 （DOWN）
	if [ "${result}" == 0 ]; then
	      echo "Server ${network}.${sitenu} is UP."
	else
	      echo "Server ${network}.${sitenu} is DOWN."
	fi
done


#程序输出：
#[root@]# sh sh17-ping_ip.sh 
#Server 192.168.1.1 is DOWN.
#Server 192.168.1.2 is DOWN.
#Server 192.168.1.3 is DOWN.
#......省略
#Server 192.168.1.100 is DOWN.
