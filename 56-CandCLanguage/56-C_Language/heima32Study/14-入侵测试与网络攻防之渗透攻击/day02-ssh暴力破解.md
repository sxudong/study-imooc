# day2- 攻击

## 补充内容

### 虚拟地址/ 物理地址 



虚拟地址， 在操作系统之上，看到的地址，都是虚拟地址。  （当系统打开mmu（）之后， 使用的地址，都是虚拟地址。 ）



mmu： 内存管理单元， 作用： 把虚拟地址映射为物理地址。



main.c

```c
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[])
{    
	int a = 0;
	while (1){
		printf("&a=%plt %d\n", &a, a++);
        sleep(1);
	}
    return 0;
}
```

gcc -Wall main.c -g -o main

```shell
root@Kali-itcast:~/c31# ls
main main.c
root@Kali-itcast:~/c31# ./main
&a=0x7ffdf6b5c21c 0
&a=0x7ffdf6b5c21c 1
&a=Ox7ffdf6b5c21c 2
&a=0x7ffdf6b5c21c 3
&a=ox7ffdf6b5c21c 4
&a=Ox7ffdf6b5c21c 5
&a=0x7ffdf6b5c21c 6
&a=0x7ffdf6b5c21c 7
&a=0x7ffdf6b5c21c 8
&a=ox7ffdf6b5c21c 9
......

root@Kali-itcast:~/c31# cat /proc/sys/kernel/random
random/    randomize_va_space
root@Kali-itcast:~/c31# cat /proc/sys/kernel/randomize_va_space
2
root@Kali-itcast:~/c31# echo 0 > /proc/sys/kernel/randomize_va_space
root@Kali-itcast:~/c31# cat /proc/sys/kernel/randomize_va_space
0
root@Kali-itcast:~/c31#
&a=0x7fffffffe1fc 0
&a=0x7fffffffelfc l
&a=Ox7fffffffe1fc 2


```





### linux内核启动：

cpu执行指令：

取指， 译码  ， 执行：   从pc寄存器（程序计数器， 存放的是，下一条指令的地址。 ）内容为地址， 去要执行指令。 

**结论： 想从哪里执行， 就把地址放到pc寄存器中来。** 

* 加电 ，运行rom中代码（bootloader-0）-- 加载bootloader （bios）  --- 加载内核 -- 执行用户态的init进程。 也就是1号进程。 
  * **加电：** 从固定地址开始执行， 一般是固化到cpu中的 代码， 完成对系统最基本初始化， 完成时钟、内存、硬盘
  * **加载bootloader：** 就是从硬盘把引导程序加载到内存， 然后， 把bootloader首地址给pc， （开始执行bootloader）， 完成对硬件进一步的初始化， （根据具体硬件配置）， 加载内核（拷贝到内存）。
  * **内核引导：** 开始执行内核代码， 又是一堆的初始化， （一个流程进行）  在内核引导的最后阶段。创建一个新内核线程， 用于执行用户空间的那init进程。 成为1号进程。 
    * 来那个内核线程， 就成为idle线程，  也就是所谓0号进程。 完成休眠， 也就是节电。
    * 新的一号进程，按相应的init进程的实现特点（老版本按inittab文件，）， 加载相应的程序。

## ssh暴力破解

简单，粗暴， 笨。

### 踩点： 

```bash
nmap -sP 192.168.26.0/24  
```

踩点的目的： 

* 确认目标主机在线， 
* 收集目标主机，可能的网络拓扑结构。
* 确认攻击目标，

### 扫描：

```shell
nmap -sS  192.168.26.240 
root@Kali-itcast:~# nmap -ss 192.168.26.240
Starting Nmap 7.70 ( https:/ / nmap.org ) at 2018-11-12 10:07 CSTNmap scan report for 192.168.26.240
Host is up (0.0000060s latency) .Not shown:999 closed ports
PORT STATE SERVICE
22/tcp open ssh  #发现目标主机，开启的服务
Nmap done: 1 IP address (1 host up)_scanned in 11.16 seconds
```

 发现目标主机，开启的服务。



进一步： 

```shell
root@Kali-itcast:~# nmap -sV -p 22192.168.26.240
starting Nmap 7.70 ( https: / / nmap.org ) at 2018-11-12 10:13 CSTNmap scan report for 192.168.26.240
Host is up (0.000046s latency) .
PORT STATE SERVICE VERSION
22/tcp open ssh openssH 7.8p1 Debian 1 (protocol 2.0)
Service Info: 0s: Linux; CPE: cpe:/o:linux:linux_kernel
Service detection performed.Please report any incorrect results at https://nmap.org/ submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.94 seconds

root@Kali-itcast:-# telnet 192.168.26.240 22
Trying 192.168.26.240...
Connected to 192.168.26.240.Escape character is '^]'.
sSH-2.0-openSSH_7.8p1 Debian-1
Connection closed by foreign host.
root@Kali-itcast:-#
```

发现目标主机服务，所采用的程序版本， 根据之前对cve漏洞的积累，整理在当前版本上，可能存在的漏洞。



### 查点：

目的， 进一步的对目标服务，收集信息。 

```shell
telnet 192.168.26.240 22    # 只有ssh可用这种方法查点
```



### 暴力攻击

```bash
hydra  -l itcast -P passwd.txt -e nsr  -vV   -o itcast.ok  192.168.26.240 ssh
```

 

### 提权 or  后门

提权： 让你当前用户，具备某种特权，（su 到root， sudo操作，）

​            进去后想办法提权。

后门： 

	一种，用自有程序替换，某种你的程序。（自写一个ls命令，替换/bin/ls,添加了一些其它的查询数据发送）
	
	还有一种，启动一个守护进程，并配置开机自启，定时发送一些希望收集的数据。 

sudo vi /etc/sudoers

```
#
# This file MUST be edited with the 'visudo' command as root.#
# Please consider adding local content in /etc/sudoers.d/ instead of# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.#
Defaults env_reset
Defaults mail_badpass
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Host alias specification

# User alias specification

#Cmnd alias specification

#User privilege specification
rootALL=(ALL:ALL)ALL
itcast ALL=(ALL:ALL)NOPASSWD :ALL

# Allow members of group sudo to execute any command
%sudoALL=(ALL:ALL)ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
```



### 掩踪灭迹：

 清除的操作痕迹：  通常是 ~/.bash_history   , 还有/var/log/* 日志。 



### 字典

暴力破解成功的关键，是给一个有效的字典， 

字典来源：

* kali自带： /usr/shared/wordlist/rockyou.txt 
* 开源下载：
* cupp命令生成
  *  cupp -l 下载，  （可用性不强）
  * cupp -i

### 防护

* 口令考虑复杂度， 口令增强技术， pam_cracklib

* 用户名隐藏技术：  禁止root用户远程登录，
  * 修改`/etc/ssh/sshd_config`:   

    ```shell
    PermitRootLogin   no     # 禁止 root 用户登陆
    DenyUsers  root itcast   # 禁止 root 和 itcast 用户登陆
    ```

* 判断你尝试次数， 错误输入超过限制，锁定用户特定时间。 

  ```shell
  itcast@itcast $ sudo vi /etc/pam.d/sshd
  
  #添加
  auth required pam_tally.so per_user unlock_time=300 onerr=succeed audit deny=5
  ```

  选项解读：

  ```shell
   unlock_time=300:  锁定帐号300秒
  
   onerr=succeed:  当鉴权失败时，返回PAM_SUCCESS
  
   audit:  当用户名不存在时，将用户名写入入系统log
  
   deny=5 : 用户鉴权失败超过5次锁定
  ```

* **注意， 锁定时间按实际情况来处理（某种情况下可能不允许锁定）**


## 补充内容-- 文件系统小论

回答几个问题： df统计系统空间，速度为什么快，  硬连接本质，  rm删除文件做了啥（为什么能恢复）， 

安全角度： 残余信息利用。（srm删除文件，避免残余信息利用） 

![](C:\Users\guoto\Desktop\01-文件系统.png)

格式化后， 以“**块**”为单位，块大小可指定， 默认4096

整个磁盘分为两部分，一部分**组织区**（管理相关）， 一部分叫**数据区**， 文件内容。

inode节点：   文件属性相关信息，存储于inode节点。每个inode节点有自己的编号。  `ls -i`, 

* 块位图表：  占用一个块，用一位（bit）来描述当前分区中，每一个块使用情况，
  *  块位图引入， df统计快。

* inode节点：记录文件的信息（除去文件名，文件内容）
  * 如何找文件， 找到文件的inode节点，在inode节点中记录了，文件内容所占用的块地址，
  * 如何找到inode节点，答：根据inode节点编号，inode表中inode节点的存放按序存放， 
  * 如何找到inode阶段编号：答：找到父目录文件的目录项，（目录文件的内容是目录项）， 一个目录项有inode节点编号+ 文件名组成。 
* inode位图表：占用一个磁盘块，用一位标识后边inode节点是否被占用。 



4098 * 8 * 4098