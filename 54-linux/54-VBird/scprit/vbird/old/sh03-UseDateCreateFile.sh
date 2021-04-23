#!/bin/bash
# 第13章 学习shell script 
# 13.2.1 简单范例 
# 
# 随日期变化：利用日期进行文件的创建
# Program:（P377）
#   Program creates three files,which named by user's input and date command.
#   程序创建了三个文件，分别由用户的输入和日期命令命名。
#History:
#2005/08/23 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 1.让用户输入文件名，并取得fileuser这个变量
echo -e "I will use 'touch' command to create 3 files." # 纯粹显示信息
read -p "Please input your filename: " fileuser         # 提示用户输入

# 2.为了避免用户随意按【Enter】,利用变量功能分析文件名是否有设置
# :-句法 如果$checking存在且不为空，num值就是$checking。如果$checking不存在或为空，num值就是$checking就是10
# 参阅：linux bash shell之变量替换：:=句法、=句法、:-句法、-句法、=?句法、?句法、:+句法、+句法
# https://www.cnblogs.com/fhefh/archive/2011/04/22/2024750.html
filename=${fileuser:-"filename"}              # 开始判断是否有配置文件名

# 3.开始利用date命令来取得所需要的文件名了
date1=$(date --date='2 days ago' +%Y%m%d)     # 前两天的日期
date2=$(date --date='1 days ago' +%Y%m%d)     # 前一天的日期
date3=$(date +%Y%m%d)                         # 今天的日期
file1=${filename}_${date1}		              # 下面三行在配置文件名
file2=${filename}_${date2}
file3=${filename}_${date3}

# 4.创建文件名
touch "$file1"
touch "$file2"
touch "$file3"



#输出结果：
#[root@]# sh sh03-UseDateCreateFile.sh
#I will use 'touch' command to create 3 files.
#Please input your filename: VBird
#[root@]# ls VBird*
#VBird_20210112  VBird_20210113  VBird_20210114

