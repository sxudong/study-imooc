#!/bin/bash
        cd lts/system/etc 
        
ftp -n 10.83.18.220 <<***000-FTP-sTart-Server
       user ope "operator"
	cd lts/system/etc
        bin
	prom
	mget *.txt
	cd ../../.. 
	cd ltsback
        lcd /home/ope/ltsback
	bin
	get tss.zip
	by
***000-FTP-sTart-Server


