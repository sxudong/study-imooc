#!/bin/bash
#date:2014/09/21

###New Folder for java131&l91&sshd
java="/root/java131/"
pccmd="/root/l91/"
sshd="/root/sshd/"
if [ -d "$java" ]; then
rm -rf  "$java"
mkdir "$java"
else
mkdir "$java"
fi

if [ -d "$pccmd" ]; then
rm -rf  "$pccmd"
mkdir "$pccmd"
else
mkdir "$pccmd"
fi

if [ -d "$sshd" ]; then
rm -rf "$sshd"
mkdir "$sshd"
else
mkdir "$sshd"
fi

###ownload java131 and pccmdl63
cd ~/java131
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/java131
	bin
        get java.zip
        cd ../l91
	lcd ../l91
	prom
	mget *
	by
***000-FTP-sTart-Server

###setup java
	unzip java.zip
	sh ./pcsetup.sh /root/java131 TRTMBL | tee install.log
#####Setupcd3.iso  
  mkdir -p /mnt/cdrom
	mount -t iso9660 -o loop setupcd3.iso /mnt/cdrom
	cd /mnt/cdrom
	sh ./setup.sh
###rm /root/sshd
	rm -rf ~/sshd
	rm -rf ~/setup

###Setup PCCMD L91
	cd /home/root/l91
        sh ./pcupdate.sh TRTMBL
	
echo -en 'Setup OK!'
