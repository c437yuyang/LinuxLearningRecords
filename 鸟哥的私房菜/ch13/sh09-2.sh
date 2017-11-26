#!/bin/bash
case $1 in
    "hello")
        echo "hello,how are you ?"
        ;;
    "hi")
        echo "hi,how are you ?"
        ;;
    *)
        echo "usage $0 hello||hi"
        ;;
    esac
