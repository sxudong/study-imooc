代码运行需要在linux系统下才能运行

需要安装“nc”工具：
[root@ ~]# yum -y install nc

[root@]# ./server
client-->IP:[127.0.0.1],PORT:[39566]
lfd==[3], cfd==[4]
n==[6], buf==[hello
]

[root@ ~]# nc 127.1 8888
hello
HELLO