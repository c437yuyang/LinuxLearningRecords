#!/bin/bash
for i in $(seq 10 100) #从10开始到100
do
    echo $i
    i=$(( $i+10 )) # 在这里改i的值是没有用的，因为始终会进入到cond里面,必须在执行步长里面改才有效
    done
