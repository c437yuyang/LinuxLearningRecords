#!/bin/bash
read -p "please input (Y/N):" yn
if [ "$yn" == "y" ] || [ "$yn" == "Y" ];then
    echo "ok continue"
elif [ "$yn" == "n" ] || [ "$yn" == "N" ];then
    echo "oh interrupt"
else
    echo "i dont understand what you input"
fi

