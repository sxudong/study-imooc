#!/bin/sh
#批量复制文件
if [ "$1" = "xcal" ] then
     scp -r $2 ope@10.83.59.254:$3
     scp -r $2 ope@10.83.59.26:$3
     scp -r $2 ope@10.83.59.28:$3
     scp -r $2 ope@10.83.59.30:$3
     scp -r $2 ope@10.83.59.32:$3
     scp -r $2 ope@10.83.59.35:$3
     scp -r $2 ope@10.83.59.37:$3
     scp -r $2 ope@10.83.15.18:$3
     scp -r $2 ope@10.83.15.17:$3
     scp -r $2 ope@10.83.15.59:$3
     scp -r $2 ope@10.83.15.12:$3
     scp -r $2 ope@10.83.15.10:$3
     scp -r $2 ope@10.83.15.225:$3
     scp -r $2 ope@10.83.59.41:$3
elif [ "$1" = "optimus" ] then
    scp -r $2 ope@10.83.1.11:$3
    scp -r $2 ope@10.83.1.21:$3
    scp -r $2 ope@10.83.1.31:$3
    scp -r $2 ope@10.83.1.41:$3
    scp -r $2 ope@10.83.1.51:$3
    scp -r $2 ope@10.83.1.61:$3
#     scp -r $2 ope@10.83.2.11:$3
#     scp -r $2 ope@10.83.2.21:$3
#     scp -r $2 ope@10.83.2.31:$3
#     scp -r $2 ope@10.83.2.41:$3
#     scp -r $2 ope@10.83.2.51:$3
#     scp -r $2 ope@10.83.2.61:$3
#     scp -r $2 ope@10.83.3.11:$3
#     scp -r $2 ope@10.83.3.21:$3
#     scp -r $2 ope@10.83.3.31:$3
#     scp -r $2 ope@10.83.3.41:$3
#     scp -r $2 ope@10.83.3.51:$3
#     scp -r $2 ope@10.83.3.61:$3
#     scp -r $2 ope@10.83.4.11:$3
#     scp -r $2 ope@10.83.4.21:$3
#     scp -r $2 ope@10.83.4.31:$3
#     scp -r $2 ope@10.83.4.41:$3
#     scp -r $2 ope@10.83.4.51:$3
#     scp -r $2 ope@10.83.4.61:$3
else
    echo ""
    echo "distribution"
    echo ""
    echo "usage   : ./distribution.sh [type] [source] [distination]"
    echo ""
    echo "        [type]        : xcal or optimus"
    echo "        [source]      : source file name"
    echo "        [distination] : distination file name"
    echo ""
    echo "example : ./distribution.sh xcal st lts/system/st"
    echo ""
fi
