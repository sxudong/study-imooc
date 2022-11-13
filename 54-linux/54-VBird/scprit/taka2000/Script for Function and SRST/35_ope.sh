#!/bin/bash
cd lts/system/etc 
        
ftp -n 10.83.13.190 <<***000-FTP-sTart-Server
    user ope "operator"
	cd lts/system/etc
	prom
	mget *.txt
	cd ../../.. 
	cd ltsback
    lcd /home/ope/ltsback
	bin
	get tss.zip
	by
***000-FTP-sTart-Server


