#!/bin/bash
#date:2014/09/21

###Download java131 and pccmd
mkdir ~/java131; cd ~/java131
mkdir ~/l63
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/java131
	bin
    get java.zip
    cd ../l63
	lcd ../l63
	prom
	mget *
	by
***000-FTP-sTart-Server

###setup java
	unzip java.zip
	sh ./pcsetup.sh /root/java131 TRITON | tee install.log
###OPE downlocad test code and switchtab
    cp ~/setup/35_ope.sh /home/ope
    cp ~/setup/changecode_func.sh /home/ope/
    cp ~/setup/changecode_srst.sh /home/ope/
	su - ope -s /bin/bash 35_ope.sh
###MAINTE downloal check.zip and tester.conf 
    cp ~/setup/35_mainte.sh /home/mainte
	su - mainte -s /bin/bash 35_mainte.sh
###Setup PCCMD
    cd ~/l63
	sh pcupdate.sh TRITON

echo -en 'Setup OK!'
