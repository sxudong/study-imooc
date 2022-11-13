#!/bin/bash

devicedir=$1
tritonflag=0

if [  $# -eq 1  ] 
then
    if [ -e $0 ] 
    then 
	echo "Install Device is $devicedir"
    else
	echo "Cannot find dir $1"
	exit 1
    fi
else
    if [ $# -eq 2 ] 
    then
	if [ -e $0 ] 
	then 
	    echo "Install Device is $devicedir"
	else
	    echo "Cannot find dir $1"
	    exit 1
	fi
	if [ $2 = "TRITON" ]
 	then
	    echo "TRITON Setup Selected."
	    tritonFlag=1
	else
	    echo "Incorrect Argument $2, Type \"TRITON\" !"
	    exit 1
	fi
    else
	echo "Cannot find $devicedir !"
	echo "usage: $0 [Install Directory]"
	echo "ex.) $0 /mnt/cdrom"
	exit 1
    fi
fi
#-------------------------------------------------
echo "Fvwm Session Install"
if 
	mkdir -p $devicedir/fvwm
	mv fvwm.zip $devicedir/fvwm
	cd $devicedir/fvwm
	unzip -o fvwm.zip
	chmod a+x $devicedir/fvwm/fvwminst
	sh $devicedir/fvwm/fvwminst
	cd $devicedir
 then 	
	echo "Fvwm Installation is completed."
 else
	echo "Fvwm Installation Failed !!"
fi  	
#-------------------------------------------------	 

echo "Install gftp"
if 
    rpm -i $devicedir/gftp-2.0.18-3.2.2.i386.rpm   
then
    echo "gftp Installation is completed."
else
    echo "gftp Installation Failed !!"
fi

echo "Install vsftpd"
if 
    rpm -i $devicedir/vsftpd-2.0.5-10.el5.i386.rpm   
then
    chkconfig vsftpd on
    chkconfig --level 5 vsftpd
    service vsftpd start
    echo "vsftpdd Installation is completed."
else
    echo "vsftpd Installation Failed !!"
fi

if [ -e /root/log ] 
then
    echo " /root/log already exist, go next step."
else
    mkdir /root/log
fi
if [ -e /root/bin ] 
then
    echo " /root/bin already exist, go next step."
else
    mkdir /root/bin
fi
unzip -o $devicedir/tools.zip -d /root/bin
chmod a+x /root/bin/* 
chmod +s /sbin/shutdown
#cp /root/bin/gdm.conf /etc/X11/gdm
#chmod 644 /etc/X11/gdm/gdm.conf
#cp /root/bin/wu-ftpd /etc/xinetd.d
#rm -fr /usr/share/gdm/defaults.conf		#new add
mv /usr/share/gdm/defaults.conf	/usr/share/gdm/defaults.conf.org	#new add by SN
cp /root/bin/defaults.conf /usr/share/gdm/     #new add  start computer automatic login "ope"
chmod 644 /usr/share/gdm/defaults.conf        #new add
#cp /root/bin/ftp* /etc
#chmod 644 /etc/ftp*

homedir="/home/"
userope="ope"
usereng="engineer"
usermai="mainte"

for user in $userope $usereng $usermai
do
if [ -e $homedir$user ] 
then
    chmod 755 $homedir$user
    mkdir $homedir$user/ltsback
    mkdir $homedir$user/lts
    mkdir $homedir$user/lts/system
    mkdir $homedir$user/lts/system/st
    mkdir $homedir$user/lts/system/etc
    mkdir $homedir$user/lts/system/jexe
    mkdir $homedir$user/lts/system/log
    mkdir $homedir$user/lts/system/config
    mkdir $homedir$user/lts/sysout
    mkdir $homedir$user/lts/sysout/bin
    mkdir $homedir$user/lts/sysout/binsend
    mkdir $homedir$user/lts/sysout/binsave
    mkdir $homedir$user/lts/sysout/buffer
    mkdir $homedir$user/lts/sysout/result
    mkdir $homedir$user/lts/sysout/restore
    mkdir $homedir$user/lts/sysin
    chown -fR $user $homedir$user/ltsback
    chgrp -fR $user $homedir$user/ltsback
    chown -fR $user $homedir$user/lts
    chgrp -fR $user $homedir$user/lts
    if [ -e $homedir$user/bin ]
    then
	echo "$homedir$user/bin already exist. go next step." 
    else
	mkdir $homedir$user/bin
    fi	
    unzip -o $devicedir/tools.zip -d $homedir$user/bin
    chown -fR $user $homedir$user/bin
    chgrp -fR $user $homedir$user/bin
    chmod 775 $homedir$user/bin
    rm -f $homedir$user/lts/system/etc/lts.ini
    rm -f $homedir$user/lts/system/config/lts.ini
    rm -f $homedir$user/lts/system/config/autosf.ini
    chmod 666 $homedir$user/.bashrc
    chmod 666 $homedir$user/.fvwm2rc
    chmod 666 $homedir$user/.wm_style
    chmod 666 $homedir$user/.Xclients
#    chmod 666 $homedir$user/.bash_profile
    #-------------------------------------------------  
    echo "Fvwm session setup"
    if
	rm -fr $homedir$user/.fvwm2rc
	cp $homedir$user/bin/fvwm2rc $homedir$user/.fvwm2rc
	chown $user $homedir$user/.fvwm2rc
	chgrp $user $homedir$user/.fvwm2rc
    then
		echo "Fvwm session setup complete"
    else
		echo "Fvwm session setup Fail !!"
    fi

    if  cp $homedir$user/bin/bashrc $homedir$user/.bashrc
	chown $user $homedir$user/.bashrc
	chgrp $user $homedir$user/.bashrc
	chmod 744 $homedir$user/.bashrc
	cp $homedir$user/bin/wm_style $homedir$user/.wm_style
	chown $user $homedir$user/.wm_style
	chgrp $user $homedir$user/.wm_style
	chmod 744 $homedir$user/.wm_style
#	cp $homedir$user/bin/bash_profile $homedir$user/.bash_profile
#	chown $user $homedir$user/.bash_profile
#	chgrp $user $homedir$user/.bash_profile
#	chmod 744 $homedir$user/.bash_profile
	cp $homedir$user/bin/lts.ini $homedir$user/lts/system/config/lts.ini
	chown $user $homedir$user/lts/system/config/lts.ini
	chgrp $user $homedir$user/lts/system/config/lts.ini
	chmod 744 $homedir$user/lts/system/config/lts.ini
	ln -s $homedir$user/lts/system/config/lts.ini $homedir$user/lts/system/etc
	chown -fR $user $homedir$user/lts/system/etc/lts.ini
	chgrp -fR $user $homedir$user/lts/system/etc/lts.ini
#	cp $homedir$user/bin/version.pcd $homedir$user/lts/system/jexe/version.pcd
#	chown $user $homedir$user/lts/system/jexe/version.pcd
#	chgrp $user $homedir$user/lts/system/jexe/version.pcd
#	chmod 744 $homedir$user/lts/system/jexe/version.pcd
	if [ $user = $userope ]
	then 
	    cp $homedir$user/bin/autosf.ini $homedir$user/lts/system/config/autosf.ini
	    chown $user $homedir$user/lts/system/config/autosf.ini
	    chgrp $user $homedir$user/lts/system/config/autosf.ini
	    chmod 644 $homedir$user/lts/system/config/autosf.ini
	    cp $homedir$user/bin/Xclients.ope $homedir$user/.Xclients
	    chown $user $homedir$user/.Xclients
	    chgrp $user $homedir$user/.Xclients
	    chmod 744 $homedir$user/.Xclients
	else
	    echo "$user is not installed autosf.ini"
    	fi
	if [ $user = $usereng ]
	then
	    cp $homedir$user/bin/Xclients.eng $homedir$user/.Xclients
	    chown $user $homedir$user/.Xclients
	    chgrp $user $homedir$user/.Xclients
	    chmod 744 $homedir$user/.Xclients
	else
	    echo "$user cannot copy .Xclients"
	fi
	if [ $user = $usermai ]
	then
	    cp $homedir$user/bin/Xclients.mai $homedir$user/.Xclients
	    chown $user $homedir$user/.Xclients
	    chgrp $user $homedir$user/.Xclients
	    chmod 744 $homedir$user/.Xclients
	else
	    echo "$user cannot copy .Xclients"
	fi
    then
	echo "[$user]copy .bashrc/.fvwm2rc/.wm_style/.Xclients passed !"
    else
	echo "[$user]copy .bashrc/.fvwm2rc/.wm_style/.Xclients failed !"
	exit 1
    fi
else 
    echo "Could not find $homedir$user !"
    echo "Please make user account for $homedir$user at first !"
    exit 1
fi
done

if cp /root/bin/timeserv.cron /etc/cron.daily
then
    echo "copy timeserv.cron completely."
    chmod a+x /etc/cron.daily/timeserv.cron
else
    echo "cannot copy timeserv.crom !"
    exit 1
fi

rm -f $homedir$usermai/lts/system/config/tester.conf
rm -f $homedir$usereng/lts/system/config/tester.conf
rm -f $homedir$userope/lts/system/config/tester.conf
if cp /root/bin/tester.conf $homedir$usermai/lts/system/config 
    chown $usermai $homedir$usermai/lts/system/config/tester.conf  
    chgrp $usermai $homedir$usermai/lts/system/config/tester.conf  
    chmod 664 $homedir$usermai/lts/system/config/tester.conf  
    cd $homedir$userope/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/tester.conf 
    chown -fR $userope $homedir$userope/lts/system/config/tester.conf  
    chgrp -fR $userope $homedir$userope/lts/system/config/tester.conf  
    cd $homedir$usereng/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/tester.conf
    chown -fR $usereng $homedir$usereng/lts/system/config/tester.conf  
    chgrp -fR $usereng $homedir$usereng/lts/system/config/tester.conf  
then
    echo "complete to link tester.conf"
else
    echo "cannot make tester.conf"
    exit 1
fi

rm -f $homedir$usermai/lts/system/etc/shutdown.tbl
rm -f $homedir$usereng/lts/system/etc/shutdown.tbl
rm -f $homedir$userope/lts/system/etc/shutdown.tbl
rm -f $homedir$usermai/lts/system/config/shutdown.tbl
rm -f $homedir$usereng/lts/system/config/shutdown.tbl
rm -f $homedir$userope/lts/system/config/shutdown.tbl
if cp /root/bin/shutdown.tbl $homedir$usermai/lts/system/config 
    chown $usermai $homedir$usermai/lts/system/config/shutdown.tbl
    chgrp $usermai $homedir$usermai/lts/system/config/shutdown.tbl 
    chmod 666 $homedir$usermai/lts/system/config/shutdown.tbl
    cd $homedir$userope/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown -fR $userope $homedir$userope/lts/system/config/shutdown.tbl
    chgrp -fR $userope $homedir$userope/lts/system/config/shutdown.tbl 
    cd $homedir$usereng/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown -fR $usereng $homedir$usereng/lts/system/config/shutdown.tbl
    chgrp -fR $usereng $homedir$usereng/lts/system/config/shutdown.tbl 
    cd $homedir$userope/lts/system/etc 
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown -fR $userope $homedir$userope/lts/system/etc/shutdown.tbl
    chgrp -fR $userope $homedir$userope/lts/system/etc/shutdown.tbl 
    cd $homedir$usereng/lts/system/etc
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown -fR $usereng $homedir$usereng/lts/system/etc/shutdown.tbl
    chgrp -fR $usereng $homedir$usereng/lts/system/etc/shutdown.tbl 
then
    echo "complete to link shutdown.tbl"
else
    echo "cannot make shutdown.tbl"
    exit 1
fi

#echo "replace /etc/X11/xdm/Xsession"
#chmod 777 /etc/X11/xdm/Xsession
#rm /etc/X11/xdm/Xsession
#cp /root/bin/Xsession /etc/X11/xdm/Xsession
#chmod 755 /etc/X11/xdm/Xsession
cp /root/bin/ntp.conf /etc/ntp.conf
chmod 644 /etc/ntp.conf
#-----------------------------------------------
echo "Default Session Install "
if
    rm -fr /etc/rc.d/rc.local
    cp /root/bin/rc.local /etc/rc.d/
    rm -fr /etc/rc.d/local1.sh
    cp /root/bin/local1.sh /etc/rc.d/
    rm -fr /etc/rc.d/dmrc
    cp /root/bin/dmrc /etc/rc.d/
    chmod a+x /etc/rc.d/rc.local
    chmod a+x /etc/rc.d/local1.sh
    chmod a+x /etc/rc.d/dmrc
    sh /etc/rc.d/local1.sh 
then
    echo "Default Session Setup complete"
else
    echo "Default Session Setup fail"
fi
#------------------------------------------------
if [ $tritonFlag -eq 1 ] 
then
    rm -f $homedir$usermai/bin/menu
    rm -f $homedir$usereng/bin/menu
    rm -f $homedir$userope/bin/menu
    if cp /root/bin/menu.triton $homedir$usermai/bin/menu
	chown $usermai $homedir$usermai/bin/menu
	chgrp $usermai $homedir$usermai/bin/menu
	chmod 744 $homedir$usermai/bin/menu
    then
	echo "complete to copy menu for TRITON"
    else
	echo "cannot copy menu for TRITON"
	exit 1
    fi    
    if cp /root/bin/menu.triton $homedir$usereng/bin/menu
	chown $usereng $homedir$usereng/bin/menu
	chgrp $usereng $homedir$usereng/bin/menu
	chmod 744 $homedir$usereng/bin/menu
    then
	echo "complete to copy menu for TRITON"
    else
	echo "cannot copy menu for TRITON"
	exit 1
    fi    
    if cp /root/bin/menu.triton $homedir$userope/bin/menu
	chown $userope $homedir$userope/bin/menu
	chgrp $userope $homedir$userope/bin/menu
	chmod 744 $homedir$userope/bin/menu
    then
	echo "complete to copy menu for TRITON"
    else
	echo "cannot copy menu for TRITON"
	exit 1
    fi    
    echo "TRITON Setup Completed."
else
    echo "V7 DMA100 Setup Completed."
fi
echo "PC SETUP UP COMPLETED !!"
exit 0
