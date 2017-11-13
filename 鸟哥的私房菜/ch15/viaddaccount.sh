#!/bin/bash
sudo groupadd myquotagrp
for(( i=1;i<=5;i=i+1 ))
do
    username=myquota${i}
    useradd -g myquotagrp $username
    passwd "yxpsaber" $username
    done
