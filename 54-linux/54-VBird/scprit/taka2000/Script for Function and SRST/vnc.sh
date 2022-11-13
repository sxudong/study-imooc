#!/bin/bash
###vncserver命令语法
###vncserver [：虚拟桌面号码] [选项] [Xvnc选项]
###重启VNCSERVER，注意:1前面一定要有空格。
vncserver -kill :1
vncserver :1
useradd ope
useradd mainte
useradd engineer
echo "operator" | passwd --stdin ope
echo "mainte" | passwd --stdin mainte
echo "engineer" | passwd --stdin engineer


