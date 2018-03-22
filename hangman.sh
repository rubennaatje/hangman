#!/bin/bash

while getopts dw: opt
do
 case $opt in
 d)
 echo "random woord"
 ;;
 w)
 echo "gekozen woord: $OPTARG"
 ;;
 \?)
 echo "invalid option: -$OPTARG" >&2
 exit
 ;;
 :)
 echo "-$OPTARG needs parameter" >&2
 exit
 ;;
 esac
done

echo "hangman";
