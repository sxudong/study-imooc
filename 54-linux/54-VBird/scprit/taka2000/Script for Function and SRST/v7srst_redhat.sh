#!/bin/bash
#date:2014/12/07

### New Folder for java131&l63&sshd
java="/root/java131/"
pccmd="/root/l63/"
sshd="/root/sshd/"
if [ -d "$java" ]; then
    rm -rf "$java"
    mkdir "$java"
else
    mkdir "$java"
fi

if [ -d "$pccmd" ]; then
    rm -rf "$pccmd"
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

###Download java131 and pccmd
cd ~/java131

ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/java131
	bin
    get java.zip
    cd ../l63
	lcd ../l63
	prom
	mget *
	cd ../sshd
	lcd ../sshd
	get openssh-server-3.1p1-3.i386.rpm
	get ipchanis
	by
***000-FTP-sTart-Server

###setup java
	unzip java.zip
	sh ./pcsetup.sh /root/java131 UART25 | tee install.log
###sshd
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

###OPE downlocad test code and switchtab
if
    cp ~/setup/srst_ope.sh /home/ope/
    cp ~/setup/changecode_srst.sh /home/ope/
	cp ~/setup/update_swtchingtable.sh /home/ope
	chmod 777 /home/ope/changecode_srst.sh
	chmod 777 /home/ope/update_swtchingtable.sh
	su - ope -s /bin/bash srst_ope.sh
    cp ~/setup/srst_mainte.sh /home/mainte
	su - mainte -s /bin/bash srst_mainte.sh
then	
	rm -rf ~/setup
	rm -rf /home/mainte/srst_mainte.sh
	rm -rf /home/ope/srst_ope.sh
	echo "Download OK! Remove setup OK!"
else
	echo "Download fail! Remove setup fail!"
fi
###Setup PCCMD
    cd ~/l63
	sh ./pcupdate.sh UARTV7

echo -en 'Setup OK!'


