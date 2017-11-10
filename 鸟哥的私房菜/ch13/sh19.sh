#!/bin/bash
read -p "please input a number , and i will count for 1 + 2 + .. + num:" number

s=0
for(( i=1;i<=$number;i=i+1 ))
do
    s=$(( $s+i ))
done

echo "the result is $s"
