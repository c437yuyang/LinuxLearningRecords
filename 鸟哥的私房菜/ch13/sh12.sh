#!/bin/bash

function printit(){
    echo "your name is $1" # 对于函数来说还是一样的，$1代表传入的第一个参数
}

echo "this program will print your selection !"
case $1 in
    "one")
        printit 1
        ;;
    "two")
        printit 2
        ;;
    "three")
        printit 3
        ;;
    *)
        echo "usage: $0 {one|two|three}"
        ;;
    esac

