#!/bin/bash
java="/root/java131/"
pccmd="/root/l91/"
sshd="/root/sshd/"
if [ -d "$java" ]; then
    rmdir "$java"
    mkdir "$java"
else
    mkdir "$java"
fi

if [ -d "$pccmd" ]; then
    rmdir "$pccmd"
    mkdir "$pccmd"
else
    mkdir "$pccmd"
fi

if [ -d "$sshd" ]; then
    rmdir "$sshd"
    mkdir "$sshd"
else
    mkdir "$sshd"
fi





