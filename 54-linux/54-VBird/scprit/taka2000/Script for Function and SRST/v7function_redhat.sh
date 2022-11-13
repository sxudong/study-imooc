#!/bin/bash
#date:2014/09/21

###Download java131 and l63
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
echo -en 'File send OK!'
###setup java
	unzip java.zip
	sh ./pcsetup.sh /root/java131 | tee install.log
###OPE downlocad test code and switchtab
        cp ~/setup/if_ope.sh /home/ope/
        cp ~/setup/changecode_func.sh /home/ope/
	su - ope -s /bin/bash if_ope.sh
###MAINTE downloal check.zip and tester.conf 
        cp ~/setup/if_mainte.sh /home/mainte
	su - mainte -s /bin/bash if_mainte.sh
###Setup PCCMD
        cd ~/l63
	sh pcupdate.sh V7D100

echo -en 'Setup OK!'
