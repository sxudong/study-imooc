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
# Program:（P395）
#      Use id command to check system account's information.
#      使用id命令检查系统帐户的信息。
# History:
# 2009/02/18   VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

users=$(cut -d ':' -f1 /etc/passwd)    # 撷取帐号名称
for username in ${users}               # 开始循环进行！
do
    #echo ${username}
	id ${username}
done


#程序输出：
#[root@]# sh userid.sh
#uid=0(root) gid=0(root) 组=0(root)
#uid=1(bin) gid=1(bin) 组=1(bin)
#uid=2(daemon) gid=2(daemon) 组=2(daemon)
#uid=3(adm) gid=4(adm) 组=4(adm)
#uid=4(lp) gid=7(lp) 组=7(lp)
#uid=5(sync) gid=0(root) 组=0(root)
#uid=6(shutdown) gid=0(root) 组=0(root)
#uid=7(halt) gid=0(root) 组=0(root)
#uid=8(mail) gid=12(mail) 组=12(mail)
#uid=11(operator) gid=0(root) 组=0(root)
#uid=12(games) gid=100(users) 组=100(users)
#uid=14(ftp) gid=50(ftp) 组=50(ftp)
#uid=99(nobody) gid=99(nobody) 组=99(nobody)
#uid=192(systemd-network) gid=192(systemd-network) 组=192(systemd-network)
#uid=81(dbus) gid=81(dbus) 组=81(dbus)
#uid=999(polkitd) gid=998(polkitd) 组=998(polkitd)
#uid=74(sshd) gid=74(sshd) 组=74(sshd)
#uid=89(postfix) gid=89(postfix) 组=89(postfix),12(mail)
#uid=998(chrony) gid=996(chrony) 组=996(chrony)
#uid=38(ntp) gid=38(ntp) 组=38(ntp)
#uid=72(tcpdump) gid=72(tcpdump) 组=72(tcpdump)
#uid=28(nscd) gid=28(nscd) 组=28(nscd)
#uid=997(dockerroot) gid=994(dockerroot) 组=994(dockerroot)
#uid=996(clamupdate) gid=992(clamupdate) 组=992(clamupdate),991(virusgroup)
#uid=995(clamscan) gid=990(clamscan) 组=990(clamscan),991(virusgroup)
#uid=59(tss) gid=59(tss) 组=59(tss)

