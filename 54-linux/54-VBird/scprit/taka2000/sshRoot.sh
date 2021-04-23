#!/bin/bash
# ssh root@192.168.100.111 //“root@”可以省略，省略代码当前用户
#
# Program:批量执行命令
# 
# History:
# 2021/01/21 Aaron Second release 
echo 192.168.100.111 >> iplist
echo 192.168.100.112 >> iplist

# 写一个iplist的文件保存需要批量分发的ip
for ip in cat iplist
do
#   echo root@$ip $1
#   ssh root@$ip $1
   echo $ip $1
   ssh $ip $1
done

# 注释用for循环替代
# echo ssh root@192.168.100.111 $1
# ssh root@192.168.100.111 $1
# echo ssh root@192.168.100.112 $1
# ssh root@192.168.100.112 $1
# echo ssh root@192.168.100.113 $1
# ssh root@192.168.100.113 $1
# echo ssh root@192.168.100.114 $1
# ssh root@192.168.100.114 $1
# echo ssh root@192.168.100.115 $1
# ssh root@192.168.100.115 $1
# echo ssh root@192.168.100.116 $1
# ssh root@192.168.100.116 $1
# echo ssh root@192.168.100.121 $1
# ssh root@192.168.100.121 $1
# echo ssh root@192.168.100.122 $1
# ssh root@192.168.100.122 $1
# echo ssh root@192.168.100.123 $1
# ssh root@192.168.100.123 $1
# echo ssh root@192.168.100.124 $1
# ssh root@192.168.100.124 $1
# echo ssh root@192.168.100.125 $1
# ssh root@192.168.100.125 $1
# echo ssh root@192.168.100.126 $1
# ssh root@192.168.100.126 $1
# echo ssh root@192.168.100.131 $1
# ssh root@192.168.100.131 $1
# echo ssh root@192.168.100.132 $1
# ssh root@192.168.100.132 $1
# echo ssh root@192.168.100.133 $1
# ssh root@192.168.100.133 $1
# echo ssh root@192.168.100.134 $1
# ssh root@192.168.100.134 $1
# echo ssh root@192.168.100.135 $1
# ssh root@192.168.100.135 $1
# echo ssh root@192.168.100.136 $1
# ssh root@192.168.100.136 $1
# echo ssh root@192.168.100.141 $1
# ssh root@192.168.100.141 $1
# echo ssh root@192.168.100.142 $1
# ssh root@192.168.100.142 $1
# echo ssh root@192.168.100.143 $1
# ssh root@192.168.100.143 $1
# echo ssh root@192.168.100.144 $1
# ssh root@192.168.100.144 $1
# echo ssh root@192.168.100.145 $1
# ssh root@192.168.100.145 $1
# echo ssh root@192.168.100.146 $1
# ssh root@192.168.100.146 $1
# echo ssh root@192.168.100.151 $1
# ssh root@192.168.100.151 $1
# echo ssh root@192.168.100.152 $1
# ssh root@192.168.100.152 $1
# echo ssh root@192.168.100.153 $1
# ssh root@192.168.100.153 $1
# echo ssh root@192.168.100.154 $1
# ssh root@192.168.100.154 $1
# echo ssh root@192.168.100.155 $1
# ssh root@192.168.100.155 $1
# echo ssh root@192.168.100.156 $1
# ssh root@192.168.100.156 $1
# echo ssh root@192.168.100.161 $1
# ssh root@192.168.100.161 $1
# echo ssh root@192.168.100.162 $1
# ssh root@192.168.100.162 $1
# echo ssh root@192.168.100.163 $1
# ssh root@192.168.100.163 $1
# echo ssh root@192.168.100.164 $1
# ssh root@192.168.100.164 $1
# echo ssh root@192.168.100.165 $1
# ssh root@192.168.100.165 $1
# echo ssh root@192.168.100.166 $1
# ssh root@192.168.100.166 $1
# echo ssh root@192.168.100.171 $1
# ssh root@192.168.100.171 $1
# echo ssh root@192.168.100.172 $1
# ssh root@192.168.100.172 $1
# echo ssh root@192.168.100.173 $1
# ssh root@192.168.100.173 $1
# echo ssh root@192.168.100.174 $1
# ssh root@192.168.100.174 $1
# echo ssh root@192.168.100.175 $1
# ssh root@192.168.100.175 $1
# echo ssh root@192.168.100.176 $1
# ssh root@192.168.100.176 $1
# echo ssh root@192.168.100.181 $1
# ssh root@192.168.100.181 $1
# echo ssh root@192.168.100.182 $1
# ssh root@192.168.100.182 $1
# echo ssh root@192.168.100.183 $1
# ssh root@192.168.100.183 $1
# echo ssh root@192.168.100.184 $1
# ssh root@192.168.100.184 $1
# echo ssh root@192.168.100.185 $1
# ssh root@192.168.100.185 $1
# echo ssh root@192.168.100.186 $1
# ssh root@192.168.100.186 $1
# echo ssh root@192.168.100.191 $1
# ssh root@192.168.100.191 $1
# echo ssh root@192.168.100.192 $1
# ssh root@192.168.100.192 $1
# echo ssh root@192.168.100.193 $1
# ssh root@192.168.100.193 $1
# echo ssh root@192.168.100.194 $1
# ssh root@192.168.100.194 $1
# echo ssh root@192.168.100.195 $1
# ssh root@192.168.100.195 $1
# echo ssh root@192.168.100.196 $1
# ssh root@192.168.100.196 $1
# echo ssh root@192.168.100.201 $1
# ssh root@192.168.100.201 $1
# echo ssh root@192.168.100.202 $1
# ssh root@192.168.100.202 $1
# echo ssh root@192.168.100.203 $1
# ssh root@192.168.100.203 $1
# echo ssh root@192.168.100.204 $1
# ssh root@192.168.100.204 $1
# echo ssh root@192.168.100.205 $1
# ssh root@192.168.100.205 $1
# echo ssh root@192.168.100.206 $1
# ssh root@192.168.100.206 $1
# echo ssh root@192.168.100.211 $1
# ssh root@192.168.100.211 $1
# echo ssh root@192.168.100.212 $1
# ssh root@192.168.100.212 $1
# echo ssh root@192.168.100.213 $1
# ssh root@192.168.100.213 $1
# echo ssh root@192.168.100.214 $1
# ssh root@192.168.100.214 $1
# echo ssh root@192.168.100.215 $1
# ssh root@192.168.100.215 $1
# echo ssh root@192.168.100.216 $1
# ssh root@192.168.100.216 $1
# echo ssh root@192.168.100.221 $1
# ssh root@192.168.100.221 $1
# echo ssh root@192.168.100.222 $1
# ssh root@192.168.100.222 $1
# echo ssh root@192.168.100.223 $1
# ssh root@192.168.100.223 $1
# echo ssh root@192.168.100.224 $1
# ssh root@192.168.100.224 $1
# echo ssh root@192.168.100.225 $1
# ssh root@192.168.100.225 $1
# echo ssh root@192.168.100.226 $1
# ssh root@192.168.100.226 $1


