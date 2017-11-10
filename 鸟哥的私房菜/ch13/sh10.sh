#!/bin/bash

testing=$(netstat -tuln | grep ":80 ")
if [ "$testing" != "" ];then # 注意if和[之间有空格
    echo "WWW is running on your system."
else
    echo "WWW is not running on your system."
fi

testing=$(netstat -tuln | grep ":22 ")
if [ "$testing" != "" ];then
    echo "SSH is running on your system."
fi

testing=$(netstat -tuln | grep ":21 ")
if [ "$testing" != "" ];then
    echo "FTP is running on your system."
fi
