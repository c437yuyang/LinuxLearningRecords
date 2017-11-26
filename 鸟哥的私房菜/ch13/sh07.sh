#!/bin/bash

echo "The script name is:$0"
echo "total parameter number is:$@"
[ "$#" -lt 2 ] && echo "The number of parameter is less than 2.Stop here."\
    && exit 0
echo "your whole parameter is '$@'"
echo "first is : $1"
echo "second is: $2"

