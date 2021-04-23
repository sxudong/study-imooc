#!/bin/bash
# ssh testpc@192.168.100.111 //“testpc@”可以省略，省略代码当前用户
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
#   echo testpc@$ip $1
#   ssh testpc@$ip $1
   echo $ip $1
   ssh $ip $1
done

# 注释用for循环替代
# echo ssh testpc@192.168.100.111 $1 $2 
# ssh testpc@192.168.100.111 $1 $2 
# echo ssh testpc@192.168.100.112 $1 $2 
# ssh testpc@192.168.100.112 $1 $2
# echo ssh testpc@192.168.100.113 $1 $2 
# ssh testpc@192.168.100.113 $1 $2
# echo ssh testpc@192.168.100.114 $1 $2 
# ssh testpc@192.168.100.114 $1 $2
# echo ssh testpc@192.168.100.115 $1 $2 
# ssh testpc@192.168.100.115 $1 $2
# echo ssh testpc@192.168.100.116 $1 $2 
# ssh testpc@192.168.100.116 $1 $2
# echo ssh testpc@192.168.100.121 $1 $2 
# ssh testpc@192.168.100.121 $1 $2
# echo ssh testpc@192.168.100.122 $1 $2 
# ssh testpc@192.168.100.122 $1 $2
# echo ssh testpc@192.168.100.123 $1 $2 
# ssh testpc@192.168.100.123 $1 $2
# echo ssh testpc@192.168.100.124 $1 $2 
# ssh testpc@192.168.100.124 $1 $2
# echo ssh testpc@192.168.100.125 $1 $2 
# ssh testpc@192.168.100.125 $1 $2
# echo ssh testpc@192.168.100.126 $1 $2 
# ssh testpc@192.168.100.126 $1 $2
# echo ssh testpc@192.168.100.131 $1 $2 
# ssh testpc@192.168.100.131 $1 $2
# echo ssh testpc@192.168.100.132 $1 $2 
# ssh testpc@192.168.100.132 $1 $2
# echo ssh testpc@192.168.100.133 $1 $2 
# ssh testpc@192.168.100.133 $1 $2
# echo ssh testpc@192.168.100.134 $1 $2 
# ssh testpc@192.168.100.134 $1 $2
# echo ssh testpc@192.168.100.135 $1 $2 
# ssh testpc@192.168.100.135 $1 $2
# echo ssh testpc@192.168.100.136 $1 $2 
# ssh testpc@192.168.100.136 $1 $2
# echo ssh testpc@192.168.100.141 $1 $2 
# ssh testpc@192.168.100.141 $1 $2
# echo ssh testpc@192.168.100.142 $1 $2 
# ssh testpc@192.168.100.142 $1 $2
# echo ssh testpc@192.168.100.143 $1 $2 
# ssh testpc@192.168.100.143 $1 $2
# echo ssh testpc@192.168.100.144 $1 $2 
# ssh testpc@192.168.100.144 $1 $2
# echo ssh testpc@192.168.100.145 $1 $2 
# ssh testpc@192.168.100.145 $1 $2
# echo ssh testpc@192.168.100.146 $1 $2 
# ssh testpc@192.168.100.146 $1 $2
# echo ssh testpc@192.168.100.151 $1 $2 
# ssh testpc@192.168.100.151 $1 $2
# echo ssh testpc@192.168.100.152 $1 $2 
# ssh testpc@192.168.100.152 $1 $2
# echo ssh testpc@192.168.100.153 $1 $2 
# ssh testpc@192.168.100.153 $1 $2
# echo ssh testpc@192.168.100.154 $1 $2 
# ssh testpc@192.168.100.154 $1 $2
# echo ssh testpc@192.168.100.155 $1 $2 
# ssh testpc@192.168.100.155 $1 $2
# echo ssh testpc@192.168.100.156 $1 $2 
# ssh testpc@192.168.100.156 $1 $2
# echo ssh testpc@192.168.100.161 $1 $2 
# ssh testpc@192.168.100.161 $1 $2
# echo ssh testpc@192.168.100.162 $1 $2 
# ssh testpc@192.168.100.162 $1 $2
# echo ssh testpc@192.168.100.163 $1 $2 
# ssh testpc@192.168.100.163 $1 $2
# echo ssh testpc@192.168.100.164 $1 $2 
# ssh testpc@192.168.100.164 $1 $2
# echo ssh testpc@192.168.100.165 $1 $2 
# ssh testpc@192.168.100.165 $1 $2
# echo ssh testpc@192.168.100.166 $1 $2 
# ssh testpc@192.168.100.166 $1 $2
# echo ssh testpc@192.168.100.171 $1 $2 
# ssh testpc@192.168.100.171 $1 $2
# echo ssh testpc@192.168.100.172 $1 $2 
# ssh testpc@192.168.100.172 $1 $2
# echo ssh testpc@192.168.100.173 $1 $2 
# ssh testpc@192.168.100.173 $1 $2
# echo ssh testpc@192.168.100.174 $1 $2 
# ssh testpc@192.168.100.174 $1 $2
# echo ssh testpc@192.168.100.175 $1 $2 
# ssh testpc@192.168.100.175 $1 $2
# echo ssh testpc@192.168.100.176 $1 $2 
# ssh testpc@192.168.100.176 $1 $2
# echo ssh testpc@192.168.100.181 $1 $2 
# ssh testpc@192.168.100.181 $1 $2
# echo ssh testpc@192.168.100.182 $1 $2 
# ssh testpc@192.168.100.182 $1 $2
# echo ssh testpc@192.168.100.183 $1 $2 
# ssh testpc@192.168.100.183 $1 $2
# echo ssh testpc@192.168.100.184 $1 $2 
# ssh testpc@192.168.100.184 $1 $2
# echo ssh testpc@192.168.100.185 $1 $2 
# ssh testpc@192.168.100.185 $1 $2
# echo ssh testpc@192.168.100.186 $1 $2 
# ssh testpc@192.168.100.186 $1 $2
# echo ssh testpc@192.168.100.191 $1 $2 
# ssh testpc@192.168.100.191 $1 $2
# echo ssh testpc@192.168.100.192 $1 $2 
# ssh testpc@192.168.100.192 $1 $2
# echo ssh testpc@192.168.100.193 $1 $2 
# ssh testpc@192.168.100.193 $1 $2
# echo ssh testpc@192.168.100.194 $1 $2 
# ssh testpc@192.168.100.194 $1 $2
# echo ssh testpc@192.168.100.195 $1 $2 
# ssh testpc@192.168.100.195 $1 $2
# echo ssh testpc@192.168.100.196 $1 $2 
# ssh testpc@192.168.100.196 $1 $2
# echo ssh testpc@192.168.100.201 $1 $2  
# ssh testpc@192.168.100.201 $1 $2
# echo ssh testpc@192.168.100.202 $1 $2 
# ssh testpc@192.168.100.202 $1 $2
# echo ssh testpc@192.168.100.203 $1 $2 
# ssh testpc@192.168.100.203 $1 $2
# echo ssh testpc@192.168.100.204 $1 $2 
# ssh testpc@192.168.100.204 $1 $2
# echo ssh testpc@192.168.100.205 $1 $2 
# ssh testpc@192.168.100.205 $1 $2
# echo ssh testpc@192.168.100.206 $1 $2 
# ssh testpc@192.168.100.206 $1 $2
# echo ssh testpc@192.168.100.211 $1 $2
# ssh testpc@192.168.100.211 $1 $2
# echo ssh testpc@192.168.100.212 $1 $2 
# ssh testpc@192.168.100.212 $1 $2
# echo ssh testpc@192.168.100.213 $1 $2 
# ssh testpc@192.168.100.213 $1 $2
# echo ssh testpc@192.168.100.214 $1 $2 
# ssh testpc@192.168.100.214 $1 $2
# echo ssh testpc@192.168.100.215 $1 $2 
# ssh testpc@192.168.100.215 $1 $2
# echo ssh testpc@192.168.100.216 $1 $2 
# ssh testpc@192.168.100.216 $1 $2
# echo ssh testpc@192.168.100.221 $1 $2 
# ssh testpc@192.168.100.221 $1 $2
# echo ssh testpc@192.168.100.222 $1 $2 
# ssh testpc@192.168.100.222 $1 $2
# echo ssh testpc@192.168.100.223 $1 $2 
# ssh testpc@192.168.100.223 $1 $2
# echo ssh testpc@192.168.100.224 $1 $2 
# ssh testpc@192.168.100.224 $1 $2
# echo ssh testpc@192.168.100.225 $1 $2 
# ssh testpc@192.168.100.225 $1 $2
# echo ssh testpc@192.168.100.226 $1 $2 
# ssh testpc@192.168.100.226 $1 $2
