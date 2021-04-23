#!/bin/bash
# 
# 旋风新能源汽车服务器39.108.168.26数据库备份脚本
#
# crontab -e
# 0 0 * * * /home/sh/mysql-backups/db_backup.sh       #每天零晨备份
# 0 0 1 * * /home/sh/mysql-backups/db_backup_del.sh   #每月1号删除
#
############### MYSQL数据库备份 #########################
###############Basic parameters##########################
DAY=`date +%Y%m%d`    # 记录发生备份的当前日期
Environment=$(/sbin/ifconfig | grep "inet" | head -1 |grep -v "127.0.0.1" | awk '{print $2;}' )    # 当前主机的IP
USER="backup"
PASSWD="xuanfeng2020@"
HostPort="3306"
MYSQLBASE="/usr/local/mysql/"
DATADIR="/data/db_backup/${DAY}"        # 备份存放的目录（/home/db_backup目录下的以日期命名的子目录中）
MYSQL=`/usr/bin/which mysql`            # 定义mysql命令的目录
MYSQLDUMP=`/usr/bin/which mysqldump`    # 定义mysqldump命令的目录
mkdir -p ${DATADIR}                     # 创建存储目录

# 定义备份函数，使用到上面定义的变量

Dump(){
 ${MYSQLDUMP} --master-data=2 --single-transaction  --routines --triggers --events -u${USER} -p${PASSWD} -P${HostPort} ${database}  > ${DATADIR}/${Environment}-${database}.sql
 cd ${DATADIR}
 gzip ${Environment}-${database}.sql    # 对文件进行了压缩
}

# 利用for循环对当前服务器下的每一个数据库（排除了一些系统视图所在的数据库）分别来调用上面的Dump函数来进行备份

for db in `echo "SELECT schema_name FROM information_schema.schemata where schema_name not in ('information_schema','sys','performance_schema')" | ${MYSQL} -u${USER} -p${PASSWD} --skip-column-names`
do
   database=${db}
   Dump
done