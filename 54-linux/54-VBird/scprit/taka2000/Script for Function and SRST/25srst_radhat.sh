#!/bin/bash
#Date:2014/12/07 

###New folder for java131&l91&sshd
java="/root/java131/"
pccmd="/root/l91/"
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

###Download java131& pccmdl63&sshd
cd ~/java131

ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/java131
	bin
        get java.zip
        cd ../l91
	lcd /root/l91
	prom
	mget *
	cd ../sshd
	lcd ../sshd
	get openssh-server-3.1p1-3.i386.rpm
	get ipchains
	by
***000-FTP-sTart-Server
###user passwd set
if
	useradd -c "Operator" ope
	useradd -c "Manintenance" mainte
	useradd -c "Engineer" engineer
then
	echo "operator" | passwd --stdin ope
	echo "mainte" | passwd --stdin mainte
	echo "engineer" | passwd --stdin engineer
	echo "user setup OK!"
else
	echo "user setup fail!"
	exit
fi
###setup java
if      echo "unzip java.zip"
        unzip java.zip
then
        /root/java131/pcsetup.sh /root/java131 UART25 | tee install.log
	echo "Java install OK!"
else
        echo "Java install fail!"
        exit
fi

###setup sshd
	cd ~/sshd
if
	echo "Insatllation sshd"
	rpm -ivh openssh-server-3.1p1-3.i386.rpm
	cp -f ipchains /etc/sysconfig
then 
	
	service sshd restart
	chkconfig sshd on	
	cd
	rm -rf ~/sshd
	echo "sshd Install Complete"
else 
	echo "sshd Install Fail "
	exit
fi

###Ope&Mainte downlocad test code,check code and switchtable
###Remove /root/setup and *.sh
if
        cp ~/setup/srst_ope.sh /home/ope/
        cp ~/setup/changecode_srst.sh /home/ope/
	chmod 777 /home/ope/changecode_srst.sh
	su - ope -s /bin/bash srst_ope.sh
        cp ~/setup/srst_mainte.sh /home/mainte
	su - mainte -s /bin/bash srst_mainte.sh
then
	rm -rf ~/setup
	rm -rf /home/ope/srst_ope.sh
	rm -rf /home/mainte/srst_mainte.sh
	echo "Downlocad OK! Remove setup and *.sh"
else
	echo "Downlocad fail! Remove file Fail!"
	exit
fi

###Setup PCCMD
if
        cd ~/l91
then
	sh ./pcupdate.sh UARTTM
	echo "Install PCCMD Complate!"
else
	echo "Install PCCMD Fail!"
fi

