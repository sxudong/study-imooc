# Ubuntu 18.04 搭建iptables防火墙

https://blog.csdn.net/qq_40058321/article/details/103180923



1、检查是否有安装iptables, 我是在root账号下执行的，如果非root有些请加上sudo

```shell
# 检查
root@cocosum:~# which iptables
/sbin/iptables
root@cocosum:~# whereis iptables
iptables: /sbin/iptables /etc/iptables /usr/share/iptables /usr/share/man/man8/iptables.8.gz
# 说明有安装iptables
```

2、如果没有安装iptables则需要安装

```shell
# 进行安装
sudo apt-get install iptables
```

3、如果安装了需要配置防火墙规则，我这里自己创建一个防火墙规则

```shell
# 创建防火墙规则的文件
root@cocosum:~# vi /etc/iptables
# 添加下面的规则
 
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:syn-flood - [0:0]
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 3306 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 8080 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 7070 -j ACCEPT
 
-A INPUT -p icmp -m limit --limit 100/sec --limit-burst 100 -j ACCEPT
-A INPUT -p icmp -m limit --limit 1/s --limit-burst 10 -j ACCEPT
-A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j syn-flood
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A syn-flood -p tcp -m limit --limit 3/sec --limit-burst 6 -j RETURN
-A syn-flood -j REJECT --reject-with icmp-port-unreachable
COMMIT
```

4、保存规则

```shell
root@cocosum:~# iptables-save > /etc/iptables
```

5、创建一个脚本, 为了每次重启系统, iptables防火墙自动启动

```shell
# 直接创建，目的是为了系统每次重启自动加载
root@cocosum:~# vi /etc/network/if-pre-up.d/iptables
 
# 内容
#!/bin/bash
iptables-restore < /etc/iptables
 
# :wq保存
```

6、给添加的脚本有执行的权限

```shell
root@cocosum:~# chmod +x /etc/network/if-pre-up.d/iptables
```

7、查看iptables；直接iptables -L ，和centos 差不多

```shell
root@cocosum:~# iptables -L
Chain INPUT (policy DROP)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     all  --  anywhere             anywhere             state RELATED,ESTABLISHED
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:ssh
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:https
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:mysql
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:http-alt
ACCEPT     tcp  --  anywhere             anywhere             state NEW tcp dpt:7070
ACCEPT     icmp --  anywhere             anywhere             limit: avg 100/sec burst 100
ACCEPT     icmp --  anywhere             anywhere             limit: avg 1/sec burst 10
syn-flood  tcp  --  anywhere             anywhere             tcp flags:FIN,SYN,RST,ACK/SYN
REJECT     all  --  anywhere             anywhere             reject-with icmp-host-prohibited
 
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
 
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
 
Chain syn-flood (1 references)
target     prot opt source               destination         
RETURN     tcp  --  anywhere             anywhere             limit: avg 3/sec burst 6
REJECT     all  --  anywhere             anywhere             reject-with icmp-port-unreachable
```

