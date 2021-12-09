# day4-渗透

目标网站：testphp.vulnweb.com
渗透目标：获取目标网站的敏感信息



## 敏感信息

- www.baidu.com/index.html: index.html 这个是网站管理人员给我们提供的，希望我们看到的。还有一些，是网站管理人员,不希望我们看到的。

  - 有一些 .git，.svn目录 (版本控制工具)
  - 隐藏目录，隐藏文件。(指的是网站目录中存在的一些.html文件，但这些文件不能通过正常界面链接过去)，通常看到，一些admin,config目录等, login.html
  - 数据库文件
  - 等等



  为什么要获取敏感信息：渗透测试就是获取网站敏感信息，为进一步的渗透服务。


## 获取敏感信息原理（渗透原理）

向网站请求一个文件，如果网站该文件存在，答复200，如果网站该文件不存在，404。

如果循环请求文件列表（字典)，就可以获取到完整的目录结构（框架)。



## 小试牛刀

踩点：

```shell
itcast@2018-11-15 10:01:01 $ nmap -sP testphp. vulnweb.com
```



```shell
itcast@2018-11-15 10:01:01 $whois linuxsecurity.cn
Domain Name: linuxsecurity.cn
ROID:20150816s10001s76771710-cn
Domain Status : ok
Registrant ID: hc9164672667874
Registrant:郭同彬
Registrant Contact Email: vulcanus@aliyun. com
Sponsoring Registrar:阿里云计算有限公司(万网)
Name Server: dns9.hichina. com
Name Server: dns10.hichina. com
Registration Time: 2015-08-16 14:28:36
Expiration Time: 2020-08-1614:28:36
DNSsEc: unsigned
itcast@2018-i1-1510:01:11 $
```

https://www.cnvd.org.cn/flaw/show/CNVD-2014-06347

目标网站web服务指纹

```shell
itcast@itcast $ sudo nmap -A -T4  -p 80 testphp.vulnweb.com

Starting Nmap 7.40 ( https://nmap.org ) at 2018-08-08 16:42 CST
Nmap scan report for testphp.vulnweb.com (176.28.50.165)
Host is up (0.30s latency).
rDNS record for 176.28.50.165: rs202995.rs.hosteurope.de
PORT   STATE SERVICE VERSION
80/tcp open  http    nginx 1.4.1
|_http-server-header: nginx/1.4.1
|_http-title: Home of Acunetix Art
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
```

## 渗透

```bash
itcast@2018-11-1510:18:02 $dirb http://testphp. vu7nweb.com/usr/share/word1ists/dirb/common .txt
```



## 字典获取
- 系统dirb自带:/usr/share/wordlists/dirb/
- 开源字典: https://www.netsparker.com/blog/web-security/svn-digger-better-lists-for-forced-browsing/
- 暴力破解工具字典SVN Digger项目，



补充：OWASP：**如果你面试的是一个web安全职位，一定要看**。

Open Web Application Security Project，开放式Web应用程序安全项目



# day04-DDOS

## 基本概念

DOS：拒绝服务式攻击，Denial of Service的简称，即拒绝服务

DDOS：多点进行DOS攻击，俗话，组团dos攻击。

如何实现：耗尽目标机资源（流量，CPU，内存...），让目标机无法对外提供正常服务。

DOS攻击，不能绝对避免，只能减缓、减少。



## tcp链接基本概念

tcp建立链接（(三次握手)∶

1. client 发送 syn 请求，server 接到 syn，应答 syn+ack，如果 client 收到 syn+ack，应答ack，如 server 收到 ack 后，完成三次握手，链接建立成功。

2. server 收到 syn 链接请求后，用**半链接队列**记录链接，发送 syn+ack，如 syn+ack 丢包重传。

3. 当 server 收到 ack 应答后，完成三次握手，用**全链接队列**记录完成握手的链接， accetp 从全链接队列中取链接返回文件描述符 fd，来标识这个链接。



## 攻击思路

1. client 发送 syn 请求，源 ip 随机填充，(只要不是本机ip就好)，server 收到后 syn 后，放入"半链接队列"，应答 syn+ack ，以刚收到的数据包中源 ip 为目标地址。此时半链接队列+1。
2. 如果 client 一直发送 syn 连接请求包，那么，server 维护的半连接队列会很快变满。正常链接到来，就无法相应。----拒绝服务，这就是 TCP Flood 攻击。



构建攻击程序：

```
sudo netwox 76 -i 127.0.0.1 -p 22
```

攻哪个IP地址和端口22



## tcp flood攻击防护手段

介绍三种，主要是内核和次相关的参数

- tcp_max_syn_backlog：队列长度：默认128

```shell
itcast@2018-11-15 $ cat /proc/sys/net/ipv4/tcp_max_syn_backlog
128
```

- tcp_syn_retries：server 端应答 syn+ack 丢包重传次数，默认5，该为0，

```shell
itcast@2018-11-15 $cat /proc/sys /net/ipv4/tcp_s ynack_retries
5
```

- tcp_syncookies：用于防止 tcp flood 攻击，默认1，表示功能打开。

```shell
itcast@2018-11-15 15:56:02 $cat /proc/sys/net/ipv4/tcp_syncookies
1
```

下面配置方式，与此等效 (两种配置方法)

```shell
itcast@2018-11-15 16:00:12 $sudo sysct1 -w net.ipv4.tcp_s yncookies=1[sudo] itcast的密码:
net.ipv4.tcp_syncookies = 1

itcast@2018-11-15 16:01:13 $sudo cat /proc/sys/net/ipv4/tcp_syncookies
1

itcast@2018-11-15 16:01:36 $sudo sysct1 -w net.ipv4.tcp_syncookies=0net.ipv4.tcp_s yncookies = o

itcast@2018-11-15 16:01:44 $sudo cat /proc/sys/net/ipv4/tcp_syncookies
0
```

把 “net.ipv4.tcp_syncookies=O” 放到 /etc/sysct1.conf ，系统重启时自动配置。



## 后渗透测试阶段

攻击成功后，提权。

- 掩踪灭迹
- 留后门，......



## 渗透测试报告
报告内容：一般包括，摘要，渗透过程，技术发现、结论