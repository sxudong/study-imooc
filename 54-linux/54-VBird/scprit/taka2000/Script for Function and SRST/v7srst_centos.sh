#!/bin/bash
#date:2014/09/21 Modify date:2014/12/07 add rm data

### New folder for hgst&l63
hgst="/root/hgst/"
l63="/root/l63/"
if [ -d "$hgst" ]; then
rm -rf "$hgst"
mkdir "$hgst"
else
mkdir "$hgst"
fi

if [ -d "$l63"]; then
rm -rf "$l63"
mkdir "$l63"
else
mkdir "$l63"
fi

###Download java and pccmdl63
cd ~/hgst
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/os
	bin
    get centos5_setup_rev8.zip
    cd ../l63
	lcd /root/l63
	prom
	mget *
	by
***000-FTP-sTart-Server

###setup java
if
	echo "unzip centos5_setup_rev8.zip"
	unzip centos5_setup_rev8.zip
	sh ./pcsetup.sh /root/hgst TRITON
	sh ./pcsetupfvwm.sh /root/hgst/
then
	echo "Java instll OK!"
else
	echo "Java instll fail!"

###OPE download test code and switchtab
if
    cp ~/setup/srst_ope.sh /home/ope/
    cp ~/setup/changecode_srst.sh /home/ope/
	chmod 777 /home/ope/changecode_srst.sh
	su - ope -s /bin/bash srst_ope.sh
    cp ~/setup/srst_mainte.sh /home/mainte
	su - mainte -s /bin/bash srst_mainte.sh
then
	rm -rf ~/setup
	rm -rf /home/mainte/srst_mainte.sh
	rm -rf /home/ope/srst_ope.sh 
	echo "Download OK! and Remove setup and *.sh"
else
	echo "Download fail! and Remove file fail!"
fi

###Setup PCCMD
    cd ~/l63
	sh ./pcupdate.sh UARTV7 

echo -en 'Setup OK!'
