#!/bin/bash
#date:2014/09/21

###Download java and pccmd
mkdir ~/hgst; cd ~/hgst
mkdir ~/l91
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/os
	bin
        get centos5_setup_rev8.zip
        cd ../l91
	lcd /root/l91
	prom
	mget *
	by
***000-FTP-sTart-Server

###setup java
	unzip centos5_setup_rev8.zip
	sh ./pcsetup.sh /root/hgst TRITON
	sh ./pcsetupfvwm.sh /root/hgst/
###OPE download test code and switchtab
        cp ~/setup/if_ope.sh /home/ope/
        cp ~/setup/changecode_func.sh /home/ope/
	su - ope -s /bin/bash if_ope.sh
###MAINTE downlocal check.zip and tester.conf 
        cp ~/setup/if_mainte.sh /home/mainte
	su - mainte -s /bin/bash if_mainte.sh
###Setup PCCMD
        cd ~/l91
	sh ./pcupdate.sh TMLUXON 

echo -en 'Setup OK!'
