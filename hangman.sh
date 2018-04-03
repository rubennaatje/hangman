#!/bin/bash
WORD=        #te raden woord
TRIES=0      #aantal keren geraden
UNGUESSEDLETTERS=abcdefghijklmnopqrstuvwxyz   #ongeraden letters
CURRENT=    #woord waarmee je speelt
GUESSEDLETTERS=0
MESSAGE=
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'


while getopts dw: opt
do
 case $opt in
 d)
 WORD=`grep -v  "[^abcdefghijklmnopqrstuvwxyz]" /usr/share/dict/words | sort -R | head -n 1`
 ;;
 w)
 WORD=$OPTARG
 ;;
 \?)
 WORD=`grep -v  "[^abcdefghijklmnopqrstuvwxyz]" /usr/share/dict/words | sort -R | head -n 1`
 ;;
 :)
 exit
 ;;
 esac
done

convert(){
  for((i=0;i<${#WORD}; i++))
  do
    CURRENT="${CURRENT}.";
  done
}

getuserinput(){
  builtin read -p "Do a guess: " guess
  # clean the input
  case "$guess" in
    [$UNGUESSEDLETTERS])
      echo "hit"
      #vergelijk
      MESSAGE=
      compare
    ;;
    [abcdefghijklmnopqrstuvwxyz])
      MESSAGE="Letter already guessed"
    ;;
    *) MESSAGE="Wrong input"
    ;;
  esac
}
removeUnTriedLetter(){
  UNGUESSEDLETTERS=${UNGUESSEDLETTERS/$guess/}
}
compare(){
  count=false
  echo "comparing"
    for letter in $(seq 1 ${#WORD})
    do
      currentLetter=${WORD:letter-1:1}
      if test $guess = $currentLetter
      then
        letterFound
        GUESSEDLETTERS=$((GUESSEDLETTERS+1))
        count=true
      fi
    done
    if test $count = false
    then
    TRIES=$((TRIES+1))
    fi

}

letterFound(){
  for dot in $(seq 1 ${#CURRENT})
  do
      if test $letter = $dot
      then
        CURRENT=$(echo $CURRENT | sed s/./$guess/$letter)
      fi
  done
}

checkGameEnd(){
  if  test ${#WORD}  = $GUESSEDLETTERS
  then
    echo " hej gewonnen"
    exit
  fi
  if test $TRIES = "10"
  then
    echo " sukkel verloren"
    exit
  fi
}
print(){
  printf "\ec"
  echo -e ${RED}$MESSAGE${NC}
  echo "Unguessed letters:" $UNGUESSEDLETTERS
  case $TRIES in
     [0-4])
        echo -e ${GREEN}
      ;;
      [5-7])
        echo -e ${YELLOW}
      ;;
      [8-9])
        echo -e ${RED}
      ;;
      10)
        echo -e ${RED}
      ;;
  esac
  echo  "TRIES LEFT:"  $((10-TRIES))
  echo -e ${NC}
  echo $CURRENT
}
convert
while true
do
  print
  getuserinput
  removeUnTriedLetter
  checkGameEnd
done
