#!/bin/bash
CodeType=$1;
CodeID=$2;
CodeName=$CodeType$CodeID
#Test-Script
cd lts/system/config
TesterID=`cat "${FtpClient}.conf" | grep 'TesterID'`
#echo -en '\E[47;31m'"\033[1mZ\033[0m"
echo -en '\E[47;31m'"\033[1mTesterID:${TesterID:10:14}\033[0m";
echo ""

case "$CodeType" in
	e7b	)FileDir="/featmfg/eb7/";;
	e7c	)FileDir="/featmfg/ec7/";;
	jb1	)FileDir="/featmfg/j1b/";;
	jc1	)FileDir="/featmfg/j1c/";;
	jbg	)FileDir="/featmfg/jgb/";;
	ajt	)FileDir="/featmfg/jpt/";;
	ars	)FileDir="/featmfg/mrs/";;
esac
CodeDir="/feature"${FileDir}$CodeName;
ftp -n 10.83.29.220 <<***000-FTP-sTart-Server
	user mainte "nospeak"
	cd $CodeDir
	ls
	ls ..
	get tss.zip
	by
***000-FTP-sTart-Server
mv tss.zip /home/ope/ltsback
echo Transfer complete!successful! 
