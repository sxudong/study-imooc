#!/bin/bash
CodeType=$1;
CodeID=$2;
CodeName=$CodeType$CodeID
#Test-Script

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
Arithmometer=`cat IPList | wc -l`
for((Row=1;Row<=$Arithmometer;Row++))
do
FtpClient=`sed -n ${Row}p IPList`;
ftp -n $FtpClient <<***000-FTP-sTart-Client-CheckTestID
	user mainte "mainte"
	bin
	cd lts/system/config
	get tester.conf
	quit
***000-FTP-sTart-Client-CheckTestID
mv tester.conf "${FtpClient}.conf"
TesterID=`cat "${FtpClient}.conf" | grep 'TesterID'`
#echo -en '\E[47;31m'"\033[1mZ\033[0m"
echo -en '\E[47;31m'"\033[1mCodeName:${CodeName}\033[0m";
echo ""
echo -en '\E[47;31m'"\033[1mMachineIP:${FtpClient}\033[0m";
echo ""
echo -en '\E[47;31m'"\033[1mTesterID:${TesterID:10:14}\033[0m";
echo ""
Message_one='WARNING: Check the "CodeName/MachineIP/TesterID" !';
Message_two='These data is that correct?[y/n]';
Message_Err='Error:"CodeName/MachineIP/TesterID" is not match from '
echo -en '\E[47;31m'"\033[1m${Message_one}\033[0m";
echo ""
echo ""
sleep 5s;
echo -en '\E[47;31m'"\033[1m${Message_two}:\033[0m";
read key;
echo $key
if [ $key == 'n' ]
then
	echo -en '\E[47;31m'"\033[1m${Message_Err}${TesterID:10:14}:\033[0m";
	echo ""
	echo "TesterID with the IP does not match from: "${TesterID:10:14}>>Error.log	
	continue
else
ftp -n $FtpClient <<***000-FTP-sTart-Client
	user ope "operator"
	cd ltsback
	ls
	quit
***000-FTP-sTart-Client
done
fi
rm -fr tss.zip
rm -fr *.conf
