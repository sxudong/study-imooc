#! /bin/sh
# https://blog.csdn.net/zhou16333/article/details/84037624
#
# 带参数的函数执行方法，格式如下：
#    函数名 参数1 参数2
#
# 1)shell的位置参数（$1、$2…、$#、$*、$?及$@）都可以作为函数的参数来使用。
# 2)此时父脚本的参数临时的被函数参数所掩盖或隐藏。
# 3)$0比较特殊，它仍然是父脚本的名称。
# 4)当函数执行完成时，原来的命令行脚本的参数即可恢复。
# 5)函数的参数变量是在函数体里面定义的 
#
# Program:
# 利用shell开发检测url脚本,检查Web URL是否正常。
#
# History:
# 2021/01/25 Aaron First release
. /etc/init.d/functions #<==引入系统函数库

function usage(){ #<==帮助函数。
	echo $"usage：$0 url"
	exit 1
}

function check_url(){ #<==检测URL函数。
	wget --spider -q -o /dev/null --tries=1 -T 5 $1
	#<==--spider 当使用此选项调用时，Wget将表现为Web蜘蛛，这意味着它不会下载页面，只需检查它们是否存在。
	#<==-q 关掉Wget的输出。
	#<==--tries 重试次数。无限重试指定0。默认情况是重试20次，但“拒绝连接”或“未找到”(404)等致命错误除外。
	#<==-T指定超时时间，这里的$1为脚本的参数。

	if [ $? -eq 0 ];then
		action "$1 is yes." /bin/true  #<==这里的action就是在脚本开头引入系统函数库后调用的。
	else
		action "$1 is no." /bin/false
	fi
}

function main(){ #<==主函数。
	if [ $# -ne 1 ] #<==如果传入的是多个参数，则打印帮助函数，提示用户。
	then
		usage
	fi
	check_url $1 #<==接收函数的传参，即把下文main结尾的$*传到这里。
}

main $* #<==这里的$*就是把命令行接收的所有参数作为函数参数传给函