#!/bin/bash
CodeType=$1;
CodeID=$2;
CodeName=$CodeType$CodeID
#Test-Script
case "$CodeType" in
	rb7	)FileDir="if/rb7/formal/";;
	rc7	)FileDir="if/rc7/formal/";;
	j1b	)FileDir="if/j1b/formal/";;
	j1c	)FileDir="if/j1c/formal/";;
	jgb	)FileDir="if/jgb/formal/";;
	jpt	)FileDir="if/jpt/formal/";;
	jgbc)FileDir="if/jgc/formal/";; 
esac
CodeDir=${FileDir}$CodeName;
TesterID=`cat "/home/ope/lts/system/config/tester.conf" | grep 'TesterID'`
echo -en '\E[47;31m'"\033[1mCodeName:${CodeName}\033[0m";
echo ""
echo -en '\E[47;31m'"\033[1mTesterID:${TesterID:10:14}\033[0m";
echo ""
Message_one='WARNING: Check the "CodeName/MachineIP/TesterID" !';
Message_two='These data is that correct?[y/n]';
echo -en '\E[47;31m'"\033[1m${Message_one}\033[0m";
echo ""
echo ""
sleep 1s;
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
ftp -n 10.83.29.166 <<***000-FTP-sTart-Server
	user mainte "nospeak"
	cd $CodeDir
	ls
	ls ..
	bin
    get tss.zip
	by
***000-FTP-sTart-Server
mv tss.zip /home/ope/ltsback
echo  'File send OK!'
fi

