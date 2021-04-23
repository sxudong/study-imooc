#!/bin/bash
# Program:
#    Check $1 is equal to "hello"
#
# 如果你不希望使用者由键盘输入额外的数据时，
# 可以使用上一节提到的参数功能 （$1）！让使用者在下
# 达指令时就将参数带进去！ 
# 现在我们想让使用者输入“ hello ”这个关键字时，利用
# 参数的方法可以这样依序设计：
#
# History:
# 2005/08/28 VBird First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

unknownFlag=0
testerType=0

if [ "$1" == "hello" ]; then
    echo "Hello, how are you ?"
elif [ $testerType -eq $unknownFlag  ]; then
    echo "The only parameter is 'hello', ex> {$0 hello}"
fi
