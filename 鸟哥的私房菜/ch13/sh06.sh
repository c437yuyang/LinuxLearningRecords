#!/bin/bash
read -p "please input (Y/N):" yn
[ "$yn" == "Y" -o "$yn" == "y" ] && echo -e "OK,you have input Y" && exit 0
[ "$yn" == "N" -o "$yn" == "n" ] && echo -e "OK,you have input N" && exit 0
echo "i dont understand what you have input"


