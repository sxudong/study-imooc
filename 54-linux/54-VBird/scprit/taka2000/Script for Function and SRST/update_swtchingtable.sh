#!/bin/bash
#date:2014/12/03
        cd lts/system/etc 
###Download switchtable and testcode        
ftp -n 10.83.72.31 <<***000-FTP-sTart-Server
       user ope "operator"
	cd lts/system/etc
	bin
	prom
	mget *.txt
	by
***000-FTP-sTart-Server

echo -n "Update OK!"
