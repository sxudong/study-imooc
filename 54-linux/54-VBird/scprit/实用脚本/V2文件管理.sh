#!/bin/bash
#
# 阿里云大学 —— Shell 编程入门到精通
# 课时11 zip包自动解压缩脚本
# https://edu.aliyun.com/lesson_155_1973#_1973
#
# 
# History:
# 2021/01/15 Aaron First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#show system info
TIME=$(date +%Y-%m-%d)
echo "USER: $USER HOST: $HOSTNAME DATE: $TIME"

# set color
green='\e[1;32m' #green
red='\e[1;31m'   #red
blue='\e[1;34m'  #blue
nc='\e[0m'       #normal

srcPath=""
dstPath=""

ErrMsg="Yout enter the directory or file dose not exist. "
DstDirMsg="Please input destination dircetory"
SrcFilesMsg="Please input source dircetory or file."
DstFilesMsg="Delete the file or dircetory. "
DirFileMsg=""

function inputSourcePath(){
while true
do

        echo $DirFileMsg
        read srcPath
        if [  -d $srcPath -o -f $srcPath  ]; then

                if [ -e $srcPath ]; then
                        break
                fi

        fi
        echo "$ErrMsg"

done
}

function inputDstPath(){
while true
do
        echo $DstDirMsg
        read dstPath
        if [  -d $dstPath -a -e $dstPath ]; then

                break
        fi
        echo "$ErrMsg"
done
}

function copy(){
while true
do
        inputSourcePath
        inputDstPath


        if [  $srcPath != $dstPath  -a  -d $srcPath  ]; then
                break

        elif [ -f $srcPath -a  `dirname $srcPath` != $dstPath ]; then
                break

        fi

        echo "The source and destination cannot be the same! Please input again"

done

cp -a  $srcPath $dstPath
echo "The files have been susscessfully copied."

}

function delete(){

        inputSourcePath

        echo "Proceed with removal? y"
        read yn
        if [ $yn == "y" ]; then
                rm -rf $srcPath
                echo "sussessfully delete!"
        fi

}


function backup(){

        inputSourcePath
        inputDstPath

        backName=`date -d today +%Y%m%d%H%M%S`
        cd $dstPath
        tar -czvf  "$backName.tar.gz" $srcPath
        echo "A successful backup to $dstPath/$backName.tar.gz"
}


while true
do

echo "*******************************************"
echo " 1 Copy"
echo " 2 Delete"
echo " 3 Backup"
echo " 4 Quit "
echo "*******************************************"


read op

case $op in
        1)
        echo "You selection is Copy"
        DirFileMsg=$SrcFilesMsg
        copy
        read -p "Press any key to continue..."
        clear
        ;;
        2)
        echo "You selection is delete"
        DirFileMsg=$DstFilesMsg
        delete
        read -p "Press any key to continue..."
        clear
        ;;
        3)
        echo "You selection is Back"
        DirFileMsg=$SrcFilesMsg
        backup
        read -p "Press any key to continue..."
        clear
        ;;
        4)
        echo "Exit..."
        break
        ;;
        *)
        echo -e "[${red}Error!${nc}] invalide selection, try again"
        ;;
esac
done

