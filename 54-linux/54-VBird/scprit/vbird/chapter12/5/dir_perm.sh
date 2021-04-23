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
# Program: （P396）
#       User input dir name, I find the permission of files.
#       用户输入目录名，我找到文件的权限。
# History:
# 2005/08/29  VBird  First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1. 先看看这个目录是否存在啊？
read -p "Please input a directory: " dir
if [ "${dir}" == "" -o ! -d "${dir}" ]; then
	echo "The ${dir} is NOT exist in your system."
	exit 1
fi

# 2. 开始测试文件啰～
filelist=$(ls ${dir})     # 列出所有在该目录下的文件名称
for filename in ${filelist}
do
	perm=""
	test -r "${dir}/${filename}" && perm="${perm} readable"
	test -w "${dir}/${filename}" && perm="${perm} writable"
	test -x "${dir}/${filename}" && perm="${perm} executable"
	echo "The file ${dir}/${filename}'s permission is ${perm} "
done


#程序输出：
#[root@]# sh dir_perm.sh
#Please input a directory: /root/xf-admin
#The file /root/xf-admin/java.sh's permission is  readable writable 
#The file /root/xf-admin/lgos's permission is  readable writable executable 
#The file /root/xf-admin/logs's permission is  readable writable executable 
#The file /root/xf-admin/log.sh's permission is  readable writable 
#The file /root/xf-admin/nohup.out's permission is  readable writable 
#The file /root/xf-admin/run-devtools.sh's permission is  readable writable 
#The file /root/xf-admin/scp118.sh's permission is  readable writable 
#The file /root/xf-admin/xf-admin.jar's permission is  readable writable 
#The file /root/xf-admin/xf-admin.jar.pid's permission is  readable writable 
