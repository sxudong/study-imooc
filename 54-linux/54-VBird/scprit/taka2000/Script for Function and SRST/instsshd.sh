#!/bin/bash
#date:2014/09/21

###  sshd
mkdir ~/sshd; cd ~/sshd
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj fujisawa
	cd oc/sshd
	bin
	get openssh-server-3.1p1-3.i386.rpm
	get ipchains
	by
***000-FTP-sTart-Server
if
	echo "Insatllation sshd"
	rpm -ivh openssh-server-3.1p1-3.i386.rpm
	cp -f ipchains /etc/sysconfig
	service sshd restart
	chkconfig sshd on	
then 
	echo "sshd Install Complete"
	cd 
	rm -fr ~/sshd
else 
	echo "sshd Install Fail "
fi
exit 0


