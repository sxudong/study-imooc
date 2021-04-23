#!/bin/sh 
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时10 mysql数据库自动备份脚本
# https://blog.csdn.net/weixin_33744854/article/details/92336805
#
#auto backup mysql 
#wugk  2012-12-12 
#Define PATH定义变量
BAKDIR=/data/backup/mysql/`date +%Y-%m-%d`  #数据库要备份的路径
MYSQLDB=test     #要备份的数据名
MYSQLPW=backup   #mysql数据库密码
MYSQLUSER=root   #帐号
#must use root user run scripts 必须使用 root用户运行，$UID为系统变量。echo $UID root是0
if [ $UID -ne 0 ];then 
   echo This script must use the root user ! ! ! 
   sleep 2 
   exit 0 
fi 
#Define DIR and mkdir DIR 判断目录是否存在，不存在则新建
if [ ! -d $BAKDIR ];then 
   mkdir -p $BAKDIR 
else 
   echo This is $BAKDIR exists.... 
fi 
#Use mysqldump backup mysql 使用 mysqldump备份数据库
/usr/bin/mysqldump -u$MYSQLUSER -p$MYSQLPW -d $MYSQLDB >$BAKDIR/webapp_db.sql 
cd $BAKDIR ; 
tar -czf  webapp_mysql_db.tar.gz *.sql 
#查找备份目录下以 .sql的文件并删除
#find  . -type f -name *.sql |xargs rm -rf 
#或
find  . -type f -name *.sql -exec rm -rf {} \; 
#如何数据库备份成功，则打印成功，并删除备份目录 30天以前的目录
[ $? -eq 0 ] && echo “ This `date +%Y-%m-%d` MySQL BACKUP is SUCCESS” 
cd /data/backup/mysql/ 
find . -type d -mtime +30 |xargs rm -rf 
echo "The mysql backup successfully "