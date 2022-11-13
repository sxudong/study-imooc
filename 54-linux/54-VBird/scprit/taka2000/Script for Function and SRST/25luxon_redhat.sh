#!/bin/bash
#date:2014/09/21

###Download java131 and pccmd
mkdir ~/java131; cd ~/java131
mkdir ~/l91
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
###OPE downlocad test code and switchtab
        cp ~/setup/if_ope.sh /home/ope/
        cp ~/setup/changecode_func.sh /home/ope/
	su - ope -s /bin/bash if_ope.sh
###MAINTE downloal check.zip and tester.conf 
        cp ~/setup/if_mainte.sh /home/mainte
	su - mainte -s /bin/bash if_mainte.sh
###Setup PCCMD
        cd ~/l91
	sh ./pcupdate.sh TMLUXON

echo -en 'Setup OK!'
