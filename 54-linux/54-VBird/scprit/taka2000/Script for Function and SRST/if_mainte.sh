#!/bin/bash
    cd lts/system/config
	rm tester.conf        
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
    user fuj "fujisawa"
	cd oc/conf/25if/
	bin
	get tester.conf
    lcd /home/mainte/ltsback
	get check.zip
	by
***000-FTP-sTart-Server


