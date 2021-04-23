#!/bin/bash
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时7 shell流程控制语句及break-continue使用方法
#
#
# Program:（P396）
#      Try do calculate 1+2+3...+${your_input}
#      尝试计算1 + 2 + 3 ... + $ {您的输入}
# History:
# 2005/08/29   VBird   First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

while true #一直循环
do
	echo "*******************************"
	echo "Please select your operation:"
	echo " 1 Copy"
	echo " 2 Delete"
	echo " 3 Backup"
	echo " 4 Quit"
	echo "*******************************"
	read op
	case $op in
		C)
		echo "your selection is Copy"
		;;
		D)
		echo "your selection is Delete"
		;;
		B)
		echo "your selection is Backup"
		;;
		Q)
		echo "Exit ..."
		break
		;;
		*)
		echo "invalide selection , please try again"
		continue
		;;
	esac
done

	
#程序输出：
#[root@]# sh break-continue.sh 
#*******************************
#Please select your operation:
# 1 Copy
# 2 Delete
# 3 Backup
# 4 Quit
#*******************************
#C
#your selection is Copy
#*******************************
#Please select your operation:
# 1 Copy
# 2 Delete
# 3 Backup
# 4 Quit
#*******************************

