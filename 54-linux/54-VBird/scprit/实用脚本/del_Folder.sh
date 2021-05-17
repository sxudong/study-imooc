
#!/bin/bash
# 获取当年的年份 year，当月的月份 month ；然后遍历图片文件夹中所有目录，
# 判断是不是小于当月的前三个月，如果是就直接 rm -rf 删除掉，如果不是则保留；
#
# Date: 20210517 Release

echo "========The script excute begin========"
baseFolder="/data/db_backup"
year=$(date +%Y)
month=`date +%m`      #如果当前是5月，则是05
monthStr=${month:0:1} #截取字符串，从0开始，截取一个字符

if [ $monthStr -eq "0"  ];then
  month1=${month#*0} #字符串的掐头去尾，*任意个字符到0为止。删除0字符。如: 05 -> 5
else
  month1=$month
fi

#保留当前月的文件夹
month2=`expr $month1 - 0`
yearMonth="${year}0${month2}01"


cd $baseFolder
#for dir in $(ls $baseFolder)
#  do
#    if [ -d $dir ];then
#      if [ $dir != $year ];then
#        echo "The folder "$dir" will be removed"
#        rm -rf $dir
#      else folder=$baseFolder$year"/"
#      fi
#    fi
#  done

#cd $folder
#for dir1 in $(ls $folder)
for dir1 in $(ls $baseFolder)
do
  if [ -d $dir1 ];then
    # 小于$month2的删除
    if [ $dir1 -lt $yearMonth ];then
      echo "The folder "$dir1" will be removed"
      rm -rf $dir1
    fi
  fi
done
echo "========The script excute end========"
