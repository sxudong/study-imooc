#!/bin/bash
#date:2014/09/21
        cd lts/system/etc 
###Download switchtable and testcode        
ftp -n 10.83.72.31 <<***000-FTP-sTart-Server
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


