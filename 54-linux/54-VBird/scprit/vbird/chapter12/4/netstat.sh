#!/bin/bash
#
# 第13章 学习shell script
# 13.1 条件判断式
# 13.4.1 利用if...then
#
# 利用“ netstat -tuln ”来取得目前主机有启动的服务
# 由于每个服务的关键字都是接在冒号“ : ”后面， 所以可以借由撷取类似“ :80 ”来侦测
#
# Program:
#    Using netstat and grep to detect WWW,SSH,FTP and Mail services.
#    使用netstat和grep检测WWW，SSH，FTP和邮件服务。
# History:
# 2005/08/28 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1. 先作一些告知的动作而已～
echo "Now, I will detect your Linux server's services!"
echo -e "The www, ftp, ssh, and mail（smtp） will be detect! \n"

# 2. 开始进行一些测试的工作，并且也输出一些信息啰！
testfile=/dev/shm/netstat_checking.txt
netstat -tuln > ${testfile}          # 先转存数据到内存当中！不用一直执行 netstat
testing=$(grep ":80 " ${testfile}) # 侦测看 port 80 在否？
if [ "${testing}" != "" ]; then
    echo ${testing}
	echo "WWW is running in your system."
fi

# grep语法：grep [-acinv] [--color=auto] '查找字符串' filename  
testing=$(grep ":22 " ${testfile}) # 侦测看 port 22 在否？

if [ "${testing}" != "" ]; then
    echo ${testing}
	echo "SSH is running in your system."
fi

testing=$(grep ":21 " ${testfile}) # 侦测看 port 21 在否？
if [ "${testing}" != "" ]; then
    echo ${testing}
	echo "FTP is running in your system."
fi

testing=$(grep ":25 " ${testfile}) # 侦测看 port 25 在否？
if [ "${testing}" != "" ]; then
    echo ${testing}
	echo "Mail is running in your system."
fi


#[root@]# sh sh10-netstat.sh 
#Now, I will detect your Linux server's services!
#The www, ftp, ssh, and mail will be detect! 
#
#tcp 0 0 0.0.0.0:80 0.0.0.0:* LISTEN
#WWW is runming in your system.
#tcp 0 0 0.0.0.0:22 0.0.0.0:* LISTEN
#SSH is runming in your system.
