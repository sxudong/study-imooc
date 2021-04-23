#!/bin/bash
#=====================================================
#先输入系统所需要的数据
host="192.168.1.100"       #远程主机
id="dmtsai"                #远程主机的 FTP 账号
pw='dmtsai.pass'           #该账号的密码
basedir="/backup/weekly"   #本地端欲备份的目录
remotedir="/home/backup"   #备份到远程的何处

#=====================================================
backupfile=weekly.tar.bz2
cd $basedir/..
   tar -jpc -f $backupfile $(basename $basedir)

ftp -n "$host" > ${basedir}/../ftp.log 2>&1 <<EOF
      user $id $pw
      binary
      cd $remotedir
      put $backupfile
      bye
EOF
