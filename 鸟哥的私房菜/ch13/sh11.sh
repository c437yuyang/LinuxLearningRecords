#!/bin/bash
read -p "Please input your demobilization date :" date2

date_d=$( echo $date2 |grep '[0-9]\{8\}' )
if [ date_d == "" ]; then
    echo "You input the wrong date format...,format like :20171111"
    exit 1
fi

# 计算日期
declare -i date_dem=`date --date="$date2" +%s` # 退伍日期秒数
declare -i date_now=`date +%s` # 现在日期秒数
declare -i date_total_s=$(( $date_dem-$date_now )) #剩余秒数计算
declare -i date_d=$(( $date_total_s/60/60/24 )) # 转换为天数
if [ "$date_total_s" -lt "0" ];then
    echo "你已经退役了:" $(( -1*$date_d )) "天."
else
    echo "你还有:" ${date_d} "天退役."
fi

