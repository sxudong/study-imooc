#!/bin/bash
#date:2014/09/21
        cd lts/system/config
	rm -rf tester.conf        
###Download tester.conf and check.zip
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server 
       user fuj "fujisawa"
	cd oc/conf/25srst/
	bin
	get tester.conf
        lcd /home/mainte/ltsback
	get check.zip
	by
***000-FTP-sTart-Server


