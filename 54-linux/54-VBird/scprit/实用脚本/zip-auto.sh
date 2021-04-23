#!/bin/bash
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时11 zip包自动解压缩脚本
# https://edu.aliyun.com/lesson_155_1973#_1973
# 
# History:
# 2021/01/15 Aaron First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

 mkdir -p /root/shell/test1 /root/shell/test2
 cd /root/shell/test1 ; zip passwd.zip /etc/passwd

#Print welcome info  
cat <<EOF 
++--------------------------------------------------------++ 
++---------     welcome to use auto  zip scripts    -------+ 
++--------------------------------------------------------++ 
EOF

PATH1=/root/shell/test1
PATH2=/root/shell/test2

cd $PATH1

#Find Dir all ZIP packages 查找目录PATH1下所有的zip包，并创建解压目录PATH2
for i in `find . -name "*.zip"|awk -F. '{print $2}' `
do
    # -o 覆盖文件不提示
	unzip -o .$i.zip -d $PATH2$i
done	


#程序输出
#[root@]# sh zip-auto.sh 
#  adding: etc/passwd (deflated 58%)
#++--------------------------------------------------------++ 
#++---------     welcome to use auto  zip scripts    -------+ 
#++--------------------------------------------------------++ 
#Archive:  ./passwd.zip
#  inflating: /root/shell/test2/passwd/etc/passwd  

#测试单独命令
#[root@]# find . -name "*.zip"
#./passwd.zip
#[root@]# find . -name "*.zip"|awk -F. '{print $2}'
#/passwd
#[ root@]# unzip -o ./passwd-d /opt/
#Archive:./passwd . zip
#inflating: /opt/etc/passwd
#[root@]# ls /opt/
#etc webapp db.sql  #/opt下面多了一个etc文件夹，说明解压成功！
