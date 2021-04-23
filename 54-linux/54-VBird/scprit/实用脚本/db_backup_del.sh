#!/bin/bash
# 按时批量清除N天前脚本
#
# /data/db_backup 要进行清理的目录
# mtime：+30表示查找30天前的文件
# "."：希望查找的数据类型，".jpg"表示查找扩展名为jpg的所有文件。
# ""表示查找所有文件
# -exec：固定写法 rm -rf：强制删除文件，包括目录 {} 
#
# crontab -e
# 0 0 * * * /home/sh/mysql-backups/db_backup.sh       #每天零晨备份
# 0 0 1 * * /home/sh/mysql-backups/db_backup_del.sh   #每月1号删除
#
# History:
# 2015/01/15 Aaron First release 
find /data/db_backup -mtime +30 -name "*.*" -exec rm -Rf {} \;
