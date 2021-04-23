#https://blog.csdn.net/u014609263/article/details/88988450
###### 二进制自动安装数据库脚本root密码mypassword将脚本和安装包放在/root目录即可###############
######数据库目录/usr/local/mysql############
######数据目录/data/mysql############
######慢日志目录/data/slowlog############
######端口号默认3306其余参数按需自行修改############
 
##################
#author 10 ##################
#!/bin/bash
 yum install -y numactl  tcmalloc libaio*  bc
 
 
# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi
 
clear
echo "========================================================================="
echo "A tool to auto-compile & install MySQL 5.7.21 on Redhat/CentOS Linux "
echo "========================================================================="
cur_dir=$(pwd)
 
#set mysql root password
    echo "==========================="
 
    mysqlrootpwd="mypassword"
    echo -e "Please input the root password of mysql:"
    read -p "(Default password: mypassword):" mysqlrootpwd
    if [ "$mysqlrootpwd" = "" ]; then
        mysqlrootpwd="mypassword"
    fi
    echo "==========================="
    echo "MySQL root password:$mysqlrootpwd"
    echo "==========================="
 
#which MySQL Version do you want to install?
echo "==========================="
 
 
    isinstallmysql57="n"
    echo "Install MySQL 5.7.21,Please input y"
    read -p "(Please input y , n):" isinstallmysql57
 
 
    case "$isinstallmysql57" in
    y|Y|Yes|YES|yes|yES|yEs|YeS|yeS)
    echo "You will install MySQL 5.7.21"
 
    isinstallmysql57="y"
    ;;
    *)
    echo "INPUT error,You will exit install MySQL 5.7.21"
 
    isinstallmysql57="n"
    exit
    esac
 
    get_char()
    {
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    #dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
    }
    echo ""
    echo "Press any key to start...or Press Ctrl+c to cancel"
    char=`get_char`
 
# Initialize  the installation related content.
function InitInstall()
{
    cat /etc/issue
    uname -a
    MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
    echo -e "\n Memory is: ${MemTotal} MB "
    #Set timezone
    #rm -rf /etc/localtime
    #ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  
    #Delete Old Mysql program
    rpm -qa|grep mysql
    rpm -e mysql || echo 'No mysql has been Installed'
 
     #Disable SeLinux
    if [ -s /etc/selinux/config ]; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    fi
    setenforce 0
 }
 
 
#Installation of depend on and optimization options.
function InstallDependsAndOpt()
{
cd $cur_dir
echo noop >/sys/block/vdc/queue/scheduler  

echo never >>  /sys/kernel/mm/transparent_hugepage/enabled
echo  never>>/sys/kernel/mm/transparent_hugepage/defrag

cat >>/etc/security/limits.conf<<EOF
* soft nproc 655350
* hard nproc 655350
* soft nofile 655350
* hard nofile 655350
EOF

echo "vm.swappiness=0" >> /etc/sysctl.conf 
echo "fs.file-max=65535" >> /etc/sysctl.conf

echo "5" >/proc/sys/vm/dirty_background_ratio
echo "10" >/proc/sys/vm/dirty_ratio

sysctl -p
}
 
 
 
#Install MySQL
function InstallMySQL57()
{
echo "============================Install MySQL 5.7.21=================================="
cd $cur_dir
 
#Backup old my.cnf
#rm -f /etc/my.cnf
if [ -s /etc/my.cnf ]; then
    mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d%H%M%S`.bak
fi
 
echo "============================MySQL 5.7.21 installing…………========================="
#mysql directory configuration
cd /usr/local
rm mysql* -fr
tar xvf /root/mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz
ln -s /usr/local/mysql-5.7.21-linux-glibc2.12-x86_64 mysql
groupadd mysql -g 512
useradd -u 512 -g mysql -s /sbin/nologin -d /home/mysql mysql

rm /data/mysql -fr
mkdir -p /data/mysql/data
mkdir -p /data/mysql/redolog
mkdir -p /data/mysql/undolog
chown -R mysql:mysql /data/mysql
chown -R mysql:mysql /usr/local/mysql
#chown -R mysql:mysql /data/
 
 
#edit /etc/my.cnf
MemTotal=`free -m | grep Mem | awk '{print  $2}'`
Buffer_Pool_Size=`echo "$MemTotal*13/20" |bc`
SERVERID=`ip a | grep "inet" | grep brd | awk '{ print $2}'|awk -F/ '{ print $1}' |awk -F. '{ print $3$4}'| head -1`
cat >>/etc/my.cnf<<EOF
[client]
port=3306
socket=/tmp/mysql.sock
default-character-set=utf8
 
[mysql]
no-auto-rehash
prompt="(\\u@\\h) \R:\m:\s [\d]> 
 
[mysqld]

########basic settings########

server-id=$SERVERID
port = 3306
user = mysql
bind_address = 0.0.0.0
autocommit = 1   
character_set_server=utf8mb4
skip_name_resolve = 1
max_connections = 800
max_connect_errors = 1000
datadir = /data/mysql/data
transaction_isolation = READ-COMMITTED
explicit_defaults_for_timestamp = 1
join_buffer_size = 134217728
tmp_table_size = 67108864
tmpdir = /tmp
max_allowed_packet = 33554432
sql_mode = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"
interactive_timeout = 600
wait_timeout = 600
read_buffer_size = 16777216
read_rnd_buffer_size = 33554432
sort_buffer_size = 33554432
lower_case_table_names = 1
table_open_cache_instances = 64
event_scheduler=on
########log settings########

log_bin_trust_function_creators=true
log_error = /data/mysql/data/error.log
slow_query_log = 1
slow_query_log_file = slow.log
log_queries_not_using_indexes = 1
log_slow_admin_statements = 1
log_slow_slave_statements = 1
log_throttle_queries_not_using_indexes = 10
expire_logs_days = 30
long_query_time = 2
min_examined_row_limit = 100

########replication settings########

master_info_repository = TABLE
relay_log_info_repository = TABLE
log_bin = bin.log
sync_binlog = 1
gtid_mode = on
enforce_gtid_consistency = 1
log_slave_updates=1
binlog_format = row
relay_log = relay.log
relay_log_recovery = 1
binlog_gtid_simple_recovery = 1
#slave_skip_errors = ddl_exist_errors

########innodb settings########

innodb_page_size = 16K
innodb_buffer_pool_size = ${Buffer_Pool_Size}M
innodb_buffer_pool_instances = 8
innodb_buffer_pool_load_at_startup = 1
innodb_buffer_pool_dump_at_shutdown = 1
innodb_lru_scan_depth = 2000
innodb_lock_wait_timeout = 5
innodb_io_capacity = 4000
innodb_io_capacity_max = 8000
innodb_flush_method = O_DIRECT
innodb_file_format = Barracuda
innodb_file_format_max = Barracuda
innodb_log_group_home_dir = /data/mysql/redolog
innodb_undo_directory = /data/mysql/undolog
innodb_undo_logs = 128
innodb_undo_tablespaces = 3
innodb_flush_neighbors = 1
innodb_flush_log_at_trx_commit=1
innodb_log_file_size = 2G
innodb_log_files_in_group = 4 
innodb_log_buffer_size = 16777216
innodb_purge_threads = 4
innodb_large_prefix = 1
innodb_thread_concurrency = 16
innodb_print_all_deadlocks = 1
innodb_strict_mode = 1
innodb_sort_buffer_size = 67108864
innodb_online_alter_log_max_size=128M

#[mysqld_safe]
#malloc-lib=tcmalloc

##########performance-schema############
performance-schema-instrument='memory/%=COUNTED'
performance_schema_digests_size = 40000
performance_schema_max_table_instances= 40000
performance_schema_max_sql_text_length= 4096
performance_schema_max_digest_length= 4096

########semi sync replication settings########

plugin_dir=/usr/local/mysql/lib/plugin
plugin_load = "rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
loose_rpl_semi_sync_master_enabled = 1
loose_rpl_semi_sync_slave_enabled = 1
loose_rpl_semi_sync_master_timeout = 5000
loose_rpl_semi_master_wait_point='after_sync'

[mysqld-5.7]
innodb_buffer_pool_dump_pct = 40
innodb_page_cleaners = 8
innodb_undo_log_truncate = 1
innodb_max_undo_log_size = 2G
innodb_purge_rseg_truncate_frequency = 128
binlog_gtid_simple_recovery=1
log_timestamps=system
transaction_write_set_extraction=MURMUR32
show_compatibility_56=on 

[mysqldump]
single-transaction=1
master-data＝１

EOF

 
 
 
/usr/local/mysql/bin/mysqld --defaults-file=/etc/my.cnf --user=mysql  --initialize-insecure
 
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chmod 700 /etc/init.d/mysqld
chkconfig --add mysqld
chkconfig --level 2345 mysqld on
 
cat >> /etc/ld.so.conf.d/mysql-x86_64.conf<<EOF
/usr/local/mysql/lib
EOF
ldconfig
 
if [ -d "/proc/vz" ];then
ulimit -s unlimited
fi
 
/etc/init.d/mysqld start
 
 
cat >> /etc/profile <<EOF
export PATH=$PATH:/usr/local/mysql/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/mysql/lib
EOF
 
/usr/local/mysql/bin/mysqladmin -u root password $mysqlrootpwd
 
cat > /tmp/mysql_sec_script<<EOF
#set password='root';
use mysql;
#delete from mysql.user where user!='root' or host!='localhost';
grant all privileges on *.* to 'sys_admin'@'%' identified by 'mypassword';
#grant all privileges on *.* to 'repl'@'%' identified by 'repl';
flush privileges;
EOF
 
 
/usr/local/mysql/bin/mysql -u root -p$mysqlrootpwd -h localhost < /tmp/mysql_sec_script
 
#rm -f /tmp/mysql_sec_script
 
 
#/etc/init.d/mysqld restart
 
 
 
 
echo "============================MySQL 5.7.21 install completed========================="
}
 
 
 
function CheckInstall()
{
echo "===================================== Check install ==================================="
clear
ismysql=""
echo "Checking..."
 
if [ -s /usr/local/mysql/bin/mysql ] && [ -s /usr/local/mysql/bin/mysqld_safe ] && [ -s /etc/my.cnf ]; then
  echo "MySQL: OK"
  ismysql="ok"
  else
  echo "Error: /usr/local/mysql not found!!!MySQL install failed."
fi
 
if [ "$ismysql" = "ok" ]; then
echo "Install MySQL 5.7.21 completed! enjoy it."
echo "========================================================================="
netstat -ntl
else
echo "Sorry,Failed to install MySQL!"
echo "You can tail /root/mysql-install.log from your server."
fi
}

source /etc/profile

#The installation log
InitInstall 2>&1 | tee /root/mysql-install.log
InstallDependsAndOpt 2>&1 | tee -a /root/mysql-install.log
InstallMySQL57 > /dev/null
CheckInstall 2>&1 | tee -a /root/mysql-install.log



