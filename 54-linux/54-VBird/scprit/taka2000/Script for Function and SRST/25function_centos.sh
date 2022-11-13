#!/bin/bash
#Date:2014/09/21 
#Modify date:2014/12/07  add user password and vnc

###vncserver命令语法
###vncserver [：虚拟桌面号码] [选项] [Xvnc选项]
###重启VNCSERVER，注意:1前面一定要有空格。
vncserver -kill :1
vncserver :1
###New Folder for hgst&pccmdl91
hgst="/root/hgst/"
pccmd="/root/l91/"
if [ -d "$hgst" ]; then
	rm -rf  "$hgst"
	mkdir "$hgst"
else
	mkdir "$hgst"
fi

if [ -d "$pccmd" ]; then
	rm -rf "$pccmd"
	mkdir "$pccmd"
else
	mkdir "$pccmd"
fi

###Download java and pccmd
cd ~/hgst
ftp -n 10.83.29.213 <<***000-FTP-sTart-Server
	user fuj "fujisawa"
	cd oc/os
	bin
    get centos5_setup_rev8.zip
    cd ../l91
	lcd /root/l91
	prom
	mget *
	cd ../sshd
	lcd /root/
	get x11.zip
	by
***000-FTP-sTart-Server
###setup java
if	echo "unzip cenos5_setup_rev8.zip"
	unzip centos5_setup_rev8.zip
	sh ./pcsetup.sh /root/hgst TRITON
then
	sh ./pcsetupfvwm.sh /root/hgst/
	echo "Java install OK!"
else
	echo "Java install fail!"
	exit
fi
### Password for ope&mainte&engineer
if
	echo "operator" | passwd --stdin ope
	echo "mainte" | passwd --stdin mainte
	echo "engineer" | passwd --stdin engineer

then
	echo "user passwd setup OK!"
else
	echo "user passwd fial!"
	exit
fi
###vsftpd start
if
	echo "service vsftpd restart"
	service vsftpd restart
then
	chkconfig vsftpd on
	echo "vsftpd restart OK!"
else
	echo "vsftpd restart fail!"
	exit
fi
####Copy vnc setup data
if
	cd
	unzip x11.zip
	cd ~/x11
	chmod 600 iptables 
	mv iptables /etc/sysconfig/
	mv xstartup /root/.vnc/
then
	echo "Copy data OK!"
else
	echo "Copy data fail!"
	exit
fi
###Ope&Mainte download test code,check code and switchtab
###Remove /root/setup and *.sh
if
    cp ~/setup/if_ope.sh /home/ope/
    cp ~/setup/changecode_func.sh /home/ope/
	chmod 777 /home/ope/changecode_func.sh
	su - ope -s /bin/bash if_ope.sh
    cp ~/setup/if_mainte.sh /home/mainte
	su - mainte -s /bin/bash if_mainte.sh
then
	rm -rf ~/setup
	rm -rf /home/ope/if_ope.sh
	rm -rf /home/mainte/if_mainte.sh
	rm -rf /root/x11.zip
	echo "Download OK! Remove setup and *.sh"
else
	echo "Download fail! Remove file fail!"
	exit
fi

###press any key to continue
read -p "press any key to continue..."

###Setup pccmd
if
    cd ~/l91 
then
	sh ./pcupdate.sh TRTMBL
	echo "Install PCCMD OK!"
else
	echo "Install PCCMD FAIL!"
	exit
fi


