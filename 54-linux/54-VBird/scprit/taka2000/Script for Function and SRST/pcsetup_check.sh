

devicedir=$1
unknownFlag=0
v3d100Flag=1
v9d100Flag=2
tritonFlag=3
trtmblFlag=4
uart25Flag=5
uart35Flag=6
testerType=0 

if [ $# -eq 2 ]   ## $# ：代表后接的参数"个数" -eq 代表两数值相等（equal）
    then
    if [ -e $0 ] ##-e 代表该文件是否存在。执行的脚本文件名为$0这个变量，第一个接的参数就是$1.
	then 
	echo "Install Device is $devicedir" ##脚本后面接的"/root/hgst"为变量$1:
    else
	echo "Cannot find dir $1"
	exit 1
    fi
    if [ $2 = "TRITON" ]   ##脚本后面接的第二个参数$2=TRITON .
	then
	echo "TRITON Setup Selected."
	testerType=$tritonFlag
    fi
    if [ $2 = "V3D100" ]  ##脚本后面接的第二个参数$2=V3D100
	then
	echo "V3/V9 60 CellS Setup Selected"
	testerType=$v3d100Flag
    fi
    if [ $2 = "V9D100" ]
	then
	echo "V9 120 CellS Setup Selected"
	testerType=$v9d100Flag
    fi
    if [ $2 = "TRTMBL" ]
	then
	echo "TRITON MOBILE Setup Selected"
	testerType=$trtmblFlag
    fi
    if [ $2 = "UART25" ]
	then
	echo "UART25 Setup Selected"
	testerType=$uart25Flag
    fi
    if [ $2 = "UART35" ]
	then
	echo "UART35 Setup Selected"
	testerType=$uart35Flag
    fi
    if [ $testerType -eq $unknownFlag ]   ##?????此处不明白???????
	then
	echo "Incorrect Argument $2, Type \"TRITON\" , \"V3D100\" , \"V9D100\" ,\"TRTMBL\" ,\"UART25\" ,\"UART35\" !"
	exit 1
    fi
else
    echo "Cannot find $devicedir !"
    echo "usage: $0 [Install Directory]"
    echo "ex.) $0 /mnt/cdrom"
    exit 1
fi

echo "Install Java Run Time"
if rpm -i $devicedir/jre-6-linux-i586.rpm  ##如果已经安装过一遍，再安装会fail,手动rpm -i 安装jre.rpm包会提示package jre-1.6.0-fcs.i586 is already installed
then
    echo "Java Run Time Installation is completed."
else
    echo "Java Run Time Installation Failed !!"
fi
echo "Install Java Comm API"  ## 三个文件已经含在centos5_setup_rev8.zip里了，可以把cenos5.zip中的3个文件删除重新压缩，以免每次执行脚本时都要提示解压覆盖选择“"A"了。
if unzip $devicedir/commapi.zip -d .
    cp libLinuxSerialParallel.so /usr/lib
    cp comm.jar /usr/java/jre1.6.0/lib
    cp javax.comm.properties /usr/java/jre1.6.0/lib
then
    echo "COMMAPI Installation is completed."
else
    echo "COMMAPI Installation Failed !!"
fi
echo "Install fvwm2"
echo "Install wu-ftpd"
###New Folder for "/root/log" and "/root/bin"
if [ -e /root/log ] 
then
    echo " /root/log already exist, go next step."
else
    mkdir /root/log
fi

if [ -e /root/bin ] ##判断/root/bin存在
then
    echo " /root/bin already exist, go next step." ## 显示“/root/bin已经存在，下一步。”
else
    mkdir /root/bin
fi
unzip -o $devicedir/tools.zip -d /root/bin
chmod a+x /root/bin/* 
chmod +s /sbin/shutdown

########################################################################################
echo "cp /root/bin/gdm.conf /etc/X11/gdm"  #无效显示，没有cp gdm.conf
echo "chmod 644 /etc/X11/gdm/gdm.conf"     #无效显示，/etc/X11下无gdm
echo "cp /root/bin/wu-ftpd /etc/xinetd.d"  #无效显示，no copy wu-ftpd到/etc/xined.d下
echo "cp /root/bin/ftp* /etc"	 #无效显示，no copy ftp*到/etc下
echo "chmod 644 /etc/ftp*"     #无效显示，chmod 无/etc/ftp*
echo "cp /root/bin/ipchains /etc/sysconfig" #无效显示，no copy ipchains to /etc/sysconfig，and centos have not ipchains,centos is iptables.
echo "chmod 644 /etc/sysconfig/ipchains"  #无效显示，centos have not ipchains,centos is iptables.
######################################################################################

homedir="/home/"
userope="ope"
usereng="engineer"
usermai="mainte"
userautopc="autopc"
usertestpc="testpc"
userrobotpc="robotpc"
userconveyor="conveyor"
userpfjudge="pfjudge"

for user in $userope $usereng $usermai $userautopc $usertestpc $userrobotpc $userconveyor $userpfjudge
##for...in...do...done循环语句
do
adduser $user                ###Add "ope" "mainte" "engineer" "autopc" "robotpc" "conveyor" "pfjudge" for user.
if [ -e $homedir$user ]      #homedir="/home/"  第一个if
then

#######################                  新建所有用户下的“formautopc”“ltsback”and “lts”子文件夹
    chmod 755 $homedir$user
    mkdir $homedir$user/fromautopc
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
    chown -fR $user $homedir$user/fromautopc
    chgrp -fR $user $homedir$user/fromautopc
    chown -fR $user $homedir$user/lts
    chgrp -fR $user $homedir$user/lts

###第2个if
###新建autopc用户下lts子文件夹
    if [ $user = $userautopc ]     
	then
	mkdir $homedir$user/lts/autopc
	mkdir $homedir$user/lts/dispatcher
	mkdir $homedir$user/lts/config
	mkdir $homedir$user/lts/robotpc
	mkdir $homedir$user/lts/cseserver
	mkdir $homedir$user/lts/log
	mkdir $homedir$user/lts/hddlog
	mkdir $homedir$user/lts/celllog
	mkdir $homedir$user/lts/totestpc
	mkdir $homedir$user/lts/rcvdata
	mkdir $homedir$user/lts/senddata
	mkdir $homedir$user/lts/invdata
	chown -fR $user $homedir$user/lts
	chgrp -fR $user $homedir$user/lts
    fi   
###第2个if结束

###第3个if
###新建所有用户下的/bin文件夹
    if [ -e $homedir$user/bin ]  
    then
	echo "$homedir$user/bin already exist. go next step." 
    else
	mkdir $homedir$user/bin
    fi	 
###第3个if结束

###########################解压tools.zip到所有用户的/bin文件夹中
    unzip -o $devicedir/tools.zip -d $homedir$user/bin
    chown -fR $user $homedir$user/bin  ###改变文件所有者  -R(recursive)进行递归的持续更改，即连同子目录下的所有文件都更改
    chgrp -fR $user $homedir$user/bin  ###改变文件所属用户组  -R(recursive)进行递归的持续更改，即连同子目录下的所有文件都更改
    chmod 775 $homedir$user/bin

####################################3个无效的文件删除#####################################
    rm -f $homedir$user/lts/system/etc/lts.ini   ###无效删除，新建文件夹下还未有/etc/lts.ini文件，除非用于新安装删除。
    rm -f $homedir$user/lts/system/config/lts.ini ###无效删除，新建文件夹下还未有conifg/lts.ini文件，除非用于新安装删除。
    rm -f $homedir$user/lts/system/config/autosf.ini ###无效删除，新建文件夹下还未有conifg/autosf.ini文件，除非用于新安装删除。
##########################################################################################

#############################给予所有用户下.bashrc别名文件665读写权限
    chmod 666 $homedir$user/.bashrc  
    echo "chmod 666 $homedir$user/.fvwm2rc"
    echo "chmod 666 $homedir$user/.wm_style"
    echo "chmod 666 $homedir$user/.Xclients"
    chmod 666 $homedir$user/.bash_profile
######################################################################

###第4个if
    if  
###cp $user/bin/bashrc 到用户者根目录下。
   cp $homedir$user/bin/bashrc $homedir$user/.bashrc 
	chown $user $homedir$user/.bashrc
	chgrp $user $homedir$user/.bashrc
	chmod 744 $homedir$user/.bashrc

########################无效的echo显示#######################
	echo "cp $homedir$user/bin/wm_style $homedir$user/.wm_style"###这个提示错误，这里显示cp了所有用户/bin/wm_style到所有用户下，其实并没有cp的动作。
	echo "chown $user $homedir$user/.wm_style"  ###这里的提示也是错误的，由于所有用户下并没有.wm_style，只是显示而已。
	echo "chgrp $user $homedir$user/.wm_style"  ###显示错误，不知道为何要提示，但script并未有执行这个的指令。
	echo "chmod 744 $homedir$user/.wm_style"   ###提示错误。
##############################################################

	cp $homedir$user/bin/bash_profile $homedir$user/.bash_profile ###测试code标题栏显示的"jre1.6.0"的文件
	chown $user $homedir$user/.bash_profile
	chgrp $user $homedir$user/.bash_profile
	chmod 744 $homedir$user/.bash_profile

###cp $user/bin/lts.ini文件到$user的根目录下。
   cp $homedir$user/bin/lts.ini $homedir$user/lts/system/config/lts.ini
	chown $user $homedir$user/lts/system/config/lts.ini
	chgrp $user $homedir$user/lts/system/config/lts.ini
	chmod 744 $homedir$user/lts/system/config/lts.ini

###建立lts.ini的软连接
	ln -s $homedir$user/lts/system/config/lts.ini $homedir$user/lts/system/etc

###cp $user/bin/version.pcd文件到/lts/system/jexe/version.pcd
	cp $homedir$user/bin/version.pcd $homedir$user/lts/system/jexe/version.pcd
	chown $user $homedir$user/lts/system/jexe/version.pcd ###这一步有必要吗？本来/bin下所有文件的用户组与拥有者前面的代码已经给到＄user了。
	chgrp $user $homedir$user/lts/system/jexe/version.pcd ###这一步有必要吗？本来/bin下所有文件的用户组与拥有者前面的代码已经给到＄user了。
	chmod 744 $homedir$user/lts/system/jexe/version.pcd   

###第5个if
###OPE用户下文件配置
	if [ $user = $userope ]   
	then 
###cp $user/bin/autosf.ini到lts/system/config/autosf.ini
	    cp $homedir$user/bin/autosf.ini $homedir$user/lts/system/config/autosf.ini
	    chown $user $homedir$user/lts/system/config/autosf.ini
	    chgrp $user $homedir$user/lts/system/config/autosf.ini
	    chmod 644 $homedir$user/lts/system/config/autosf.ini
###不知未何提示cp $user/bin/Xclients.ope到$user/.Xclients
###$user下有一个隐藏文件.Xclients，但不是pcsetup.sh copy过来的，是pcsetupfvwm.sh脚本copy过去的。此代码在pcsetupfvwm.sh脚本中完成。
	    echo "cp $homedir$user/bin/Xclients.ope $homedir$user/.Xclients"  
	    echo "chown $user $homedir$user/.Xclients"
	    echo "chgrp $user $homedir$user/.Xclients"
	    echo "chmod 744 $homedir$user/.Xclients"
###java桌面的鼠标左右键的菜单文件，此代码在pcsetupfvwm.sh脚本中完成。########################
	    echo "cp $homedir$user/bin/fvwm2rc.ope $homedir$user/.fvwm2rc"
	    echo "chown $user $homedir$user/.fvwm2rc"
	    echo "chgrp $user $homedir$user/.fvwm2rc"
	    echo "chmod 744 $homedir$user/.fvwm2rc"
	else
	    echo "$user is not installed autosf.ini"
    	fi  ###第5个if结束

##############################第6个if engineer 无效的显示。此代码在pcsetupfvwm.sh脚本中完成。########################################
	if [ $user = $usereng ]  ###第6个if
	then
	    echo "cp $homedir$user/bin/Xclients.eng $homedir$user/.Xclients"
	    echo "chown $user $homedir$user/.Xclients"
	    echo "chgrp $user $homedir$user/.Xclients"
	    echo "chmod 744 $homedir$user/.Xclients"
	    echo "cp $homedir$user/bin/fvwm2rc.eng $homedir$user/.fvwm2rc"
	    echo "chown $user $homedir$user/.fvwm2rc"
	    echo "chgrp $user $homedir$user/.fvwm2rc"
	    echo "chmod 744 $homedir$user/.fvwm2rc"
	else
	    echo "$user cannot copy .Xclients"
	fi  ###第6个if结束
#######################################################################################################

#################第7个if  mainte  无效显示，此代码在pcsetupfvwm.sh脚本中完成#################################
	if [ $user = $usermai ] 
	then
	    echo "cp $homedir$user/bin/Xclients.mai $homedir$user/.Xclients"
	    echo "chown $user $homedir$user/.Xclients"
	    echo "chgrp $user $homedir$user/.Xclients"
	    echo "chmod 744 $homedir$user/.Xclients"
	    echo "cp $homedir$user/bin/fvwm2rc.mai $homedir$user/.fvwm2rc"
	    echo "chown $user $homedir$user/.fvwm2rc"
	    echo "chgrp $user $homedir$user/.fvwm2rc"
	    echo "chmod 744 $homedir$user/.fvwm2rc"
	else
	    echo "$user cannot copy .Xclients"
	fi  ###第7个if结束
######################################################################################################

    then  
	echo "[$user]copy .bashrc/.fvwm2rc/.wm_style/.Xclients passed !"  #####安装JAVA完成时，成功显示  .Xclients passed !
    else
	echo "[$user]copy .bashrc/.fvwm2rc/.wm_style/.Xclients failed !"
	exit 1
    fi 
###第4个if结束

else 
    echo "Could not find $homedir$user !"
    echo "Please make user account for $homedir$user at first !"
    exit 1
fi  ###第1个if结束
done
##################################################循  环  语  句  结   束  ####################################

##################################################copy timeserv.cron到/etc/crondaily，内容cp /root/bin/timeserv.cron ＞ /root/log/timeserv.log#########
if cp /root/bin/timeserv.cron /etc/cron.daily
then
    echo "copy timeserv.cron completely."
    chmod a+x /etc/cron.daily/timeserv.cron
else
    echo "cannot copy timeserv.crom !"
    exit 1
fi
#######################################################################################

############删除ope mainte engineer 三个用户一的tester.conf,都还没有文件copy进入不知为何要删除,除非是重新安装java.#####################################################
rm -f $homedir$usermai/lts/system/config/tester.conf
rm -f $homedir$usereng/lts/system/config/tester.conf
rm -f $homedir$userope/lts/system/config/tester.conf
#######################################################################################

#######正式copy /root/bin/tester.conf到mainte用户下，所有者mainte,群组mainte,权限664。############################
if cp /root/bin/tester.conf $homedir$usermai/lts/system/config 
    chown $usermai $homedir$usermai/lts/system/config/tester.conf  
    chgrp $usermai $homedir$usermai/lts/system/config/tester.conf  
    chmod 664 $homedir$usermai/lts/system/config/tester.conf  
#######建立tester.conf ope用户下的软连接，所有者ope,群组ope。
    cd $homedir$userope/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/tester.conf 
    chown $userope $homedir$userope/lts/system/config/tester.conf  
    chgrp $userope $homedir$userope/lts/system/config/tester.conf  
#######建立testr.conf mainte用户下的软连接，所有者engineer,群组engineer。
    cd $homedir$usereng/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/tester.conf
    chown $usereng $homedir$usereng/lts/system/config/tester.conf  
    chgrp $usereng $homedir$usereng/lts/system/config/tester.conf  
then
    echo "complete to link tester.conf"
else
    echo "cannot make tester.conf"
    exit 1
fi
########################################################################################################################

######删除ope mainte engineer 3个用户lts/system/etc和lts/system/config下的shutdown.tbl文件。不知为何删除，这几个用户下还是空文件夹在的，除非是在重装java，才有必要删除。###################################################
rm -f $homedir$usermai/lts/system/etc/shutdown.tbl
rm -f $homedir$usereng/lts/system/etc/shutdown.tbl
rm -f $homedir$userope/lts/system/etc/shutdown.tbl
rm -f $homedir$usermai/lts/system/config/shutdown.tbl
rm -f $homedir$usereng/lts/system/config/shutdown.tbl
rm -f $homedir$userope/lts/system/config/shutdown.tbl
#######################################################################################################################################

######copy /root/bin/shutdown.tbl 到 mainte用户/lts/system/config,拥有者mainte,群组mainte,权限666。###########################
if cp /root/bin/shutdown.tbl $homedir$usermai/lts/system/config 
    chown $usermai $homedir$usermai/lts/system/config/shutdown.tbl
    chgrp $usermai $homedir$usermai/lts/system/config/shutdown.tbl 
    chmod 666 $homedir$usermai/lts/system/config/shutdown.tbl
    #########shutdown.tbl ope用户lts/system/config下建立软连接，拥有者ope,群组ope.
	 cd $homedir$userope/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown $userope $homedir$userope/lts/system/config/shutdown.tbl
    chgrp $userope $homedir$userope/lts/system/config/shutdown.tbl 
    ###########shutdown.tbl engineer用户lts/system/config下建立软连接，拥有者engineer,群组engineer。
    cd $homedir$usereng/lts/system/config 
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown $usereng $homedir$usereng/lts/system/config/shutdown.tbl
    chgrp $usereng $homedir$usereng/lts/system/config/shutdown.tbl 
    ###########shutdown.tbl ope用户lts/system/etc建立软连接，拥有者ope,群组ope.
    cd $homedir$userope/lts/system/etc 
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown $userope $homedir$userope/lts/system/etc/shutdown.tbl
    chgrp $userope $homedir$userope/lts/system/etc/shutdown.tbl 
    ###########shutdown.tbl engineer用户lts/system/etc下建立软连接，拥有者engineer,群组engineer.
    cd $homedir$usereng/lts/system/etc
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown $usereng $homedir$usereng/lts/system/etc/shutdown.tbl
    chgrp $usereng $homedir$usereng/lts/system/etc/shutdown.tbl 
    ###########shutdown.tbl mainte用户lts/system/conifg下建立软连接，拥有者engineer,群组engineer.
    cd $homedir$usermai/lts/system/etc
    ln -s $homedir$usermai/lts/system/config/shutdown.tbl
    chown $usereng $homedir$usereng/lts/system/etc/shutdown.tbl
    chgrp $usereng $homedir$usereng/lts/system/etc/shutdown.tbl 
then
    echo "complete to link shutdown.tbl"
else
    echo "cannot make shutdown.tbl"
    exit 1
fi
##########################################################################################################################


##########################################无用的显示######################################################
echo "replace /etc/X11/xdm/Xsession"  ####/etc/X11下没有一个xdm的文件夹，/etc/X11/init/下有一个Xsession但非copy进来的。
echo "chmod 777 /etc/X11/xdm/Xsession"
echo "rm /etc/X11/xdm/Xsession"
echo "cp /root/bin/Xsession /etc/X11/xdm/Xsession"  ##/root/bin下有一个Xsession文件。
echo "chmod 755 /etc/X11/xdm/Xsession"
echo "cp /root/bin/ntp.conf /etc/ntp.conf"   ##/root/bin/下有一个ntp.conf文件，local clock。
echo "chmod 644 /etc/ntp.conf"
##############################################################################################################


##################删除 ope mainte engineer rautopc testpc robotpc conveyor pfjudge等用户/bin/menu########
rm -f $homedir$usermai/bin/menu    #搞不明白为什么要删除所有用户/bin下的menu文件，解压分发时，你不copy分发到每一
rm -f $homedir$usereng/bin/menu    #个用户不就行了吗？就用不着再一个一个用户的删除了啊！
rm -f $homedir$userope/bin/menu
rm -f $homedir$userautopc/bin/menu
rm -f $homedir$usertestpc/bin/menu
rm -f $homedir$userrobotpc/bin/menu
rm -f $homedir$userconveyor/bin/menu
rm -f $homedir$userpfjudge/bin/menu
###################################################################################################################

###############判断copy $2 对应的参数menu到 ope mainte engineer 三个用户bin下。如$2=triton 就copy menu.triton到3个用户中###
menuFilename=/root/bin/menu
checkshFilename=/root/bin/check.sh

if [ $testerType -eq $tritonFlag ] 
    then
    menuFilename=/root/bin/menu.triton
    checkshFilename=/root/bin/checktrt.sh
fi
if [ $testerType -eq $v3d100Flag ] 
    then
    menuFilename=/root/bin/menu.v3d100
    checkshFilename=/root/bin/checkv3.sh
fi
if [ $testerType -eq $v9d100Flag ] 
    then
    menuFilename=/root/bin/menu.v9d100
    checkshFilename=/root/bin/checkv9.sh
fi
if [ $testerType -eq $trtmblFlag ] 
    then
    menuFilename=/root/bin/menu.trtmbl
    checkshFilename=/root/bin/checktrm.sh
fi
if [ $testerType -eq $uart25Flag ] 
    then
    menuFilename=/root/bin/menu.uart25
    checkshFilename=/root/bin/checkur.sh
fi
if [ $testerType -eq $uart35Flag ] 
    then
    menuFilename=/root/bin/menu.uart35
    checkshFilename=/root/bin/checkur.sh
fi    
#####copy $2对应的参数menu(menu.triton menu.trtmbl menu.uart25 menu.uart35) 到mainte用户/bin/menu里############
if cp $menuFilename $homedir$usermai/bin/menu
    chown $usermai $homedir$usermai/bin/menu
    chgrp $usermai $homedir$usermai/bin/menu
    chmod 744 $homedir$usermai/bin/menu
    then
    echo "complete to copy menu "
else
    echo "cannot copy menu "
    exit 1
fi    
####copy $2 对应参数check*.sh(checktrt.sh)到mainte用户/bin下。
if cp $checkshFilename $homedir$usermai/bin/check.sh
    chown $usermai $homedir$usermai/bin/check.sh
    chgrp $usermai $homedir$usermai/bin/check.sh
    chmod 744 $homedir$usermai/bin/check.sh
    then
    echo "complete to copy menu"
else
    echo "cannot copy menu"
    exit 1
fi    
#####copy $2对应的参数menu(menu.triton menu.trtmbl menu.uart25 menu.uart35) 到engineer用户/bin/menu里############
if cp $menuFilename $homedir$usereng/bin/menu
    chown $usereng $homedir$usereng/bin/menu
    chgrp $usereng $homedir$usereng/bin/menu
    chmod 744 $homedir$usereng/bin/menu
    then
    echo "complete to copy menu"
else
    echo "cannot copy menu"
    exit 1
fi    
#####copy $2对应的参数menu(menu.triton menu.trtmbl menu.uart25 menu.uart35) 到ope用户/bin/menu里############
if cp $menuFilename $homedir$userope/bin/menu
    chown $userope $homedir$userope/bin/menu
    chgrp $userope $homedir$userope/bin/menu
    chmod 744 $homedir$userope/bin/menu
    then
    echo "complete to copy menu"
else
    echo "cannot copy menu"
    exit 1
fi    
"Startup Menu  Setup Completed."  ###这一条又没有加echo显示，不知道为何用？
########################################################################################################################

##########################设置网关  不过看不懂, 为何script 就知道执行putdef?它又不是内部命令################################
echo "Setup Anonymoust FTP G/W Configuration"
putdef autosf UserID anonymous $homedir$usermai/lts/system/config/tester.conf
putdef autosf PassWord anonymous $homedir$usermai/lts/system/config/tester.conf
putdef autosf RemoteRawDir . $homedir$usermai/lts/system/config/tester.conf
########################################################################################################################

#####copy /root/bin/hosts到/etc下################
echo "Copy hosts/host.conf files."
if cp /root/bin/hosts /etc
then
    echo "Complete to copy hosts"
else
    echo "cannot copy hosts"
    exit 1
fi
chmod 644 /etc/hosts

#####copy /root/bin/host.conf到/etc下############
if cp /root/bin/host.conf /etc
then
    echo "Complete to copy host.conf."
else
    echo "cannot copy host.conf"
    exit 1
fi
chmod 644 /etc/host.conf

#####delete /etc/crondaily/slocate.cron文件######
echo "Delete cron.daily/slocate.cron"
chmod 666 /etc/cron.daily/slocate.cron
rm -f /etc/cron.daily/slocate.cron
echo "Delete rc.d/rc5.d/S80sendmail"
chmod 666 /etc/rc.d/rc5.d/S80sendmail
rm -f /etc/rc.d/rc5.d/S80sendmail

####set all file 权限为776属性，set *.sh为权限664属性，set *menu*为权限664属性，set *config*.sh为权限776属性#####
echo "Change attribute for shell."
for user in $userope $usereng $usermai $userautopc $usertestpc $userrobotpc $userconveyor $userpfjudge
do
chmod 776 $homedir$user/bin/*
chmod 664 $homedir$user/bin/*.sh
chmod 664 $homedir$user/bin/*menu*
chmod 776 $homedir$user/bin/*config*.sh
done

####关闭 yun#####
echo "DO NOT USE yum "
chkconfig yum-updatesd off 
/usr/sbin/ntpdate timeserv 
hwclock --systohc

echo "PC SETUP UP COMPLETED !!"
exit 0
