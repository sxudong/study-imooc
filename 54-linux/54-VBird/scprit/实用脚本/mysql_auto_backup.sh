#!/bin/sh

DATABASE_Name=test

# current running shell path
BASEPATH=$(cd `dirname $0`; pwd)

DATABASE_BACKUP_PATH=$BASEPATH/ppwkBackup

echo "Begin backup $DATABASE_Name database..."

if [ ! -d $DATABASE_BACKUP_PATH ];then
    mkdir -p $DATABASE_BACKUP_PATH
fi

# begin to backup database
/usr/local/mysql/bin/mysqldump -Y -F -E -x -l -u root -padx^1pk_u7Yv --default-character-set=utf8mb4 --add-drop-database --add-drop-table --add-locks --add-drop-trigger -B $DATABASE_Name > $DATABASE_BACKUP_PATH/mysqlbackup-`date +%Y-%m-%d-%H%M%S`.sql

if [ 0 -eq $? ];then
    echo $(date +"%Y-%m-%d %H:%M:%S") "$DATABASE_Name Database backup success!" >> /root/DBBackLog.log                                                                                                                                    sync 
else
    echo $(date +"%Y-%m-%d %H:%M:%S") "$DATABASE_Name Database backup error!" >> /root/DBBackLog.log
    exit
fi 

# Delete beyond 15 days backup sql files
find $DATABASE_BACKUP_PATH/ -mtime +15 -name "*.sql" -exec rm -rf {} \;

echo "Backup $DATABASE_Name database finished!"

# recovery $DATABASE_Name database
# mysql -hlocalhost -uroot -p123456 --database $DATABASE_Name< mysqlbackup-2018-05-23-13:44:42.sql
