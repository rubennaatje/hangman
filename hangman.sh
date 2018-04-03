#!/bin/bash
WORD=`grep -v  "[^abcdefghijklmnopqrstuvwxyz]" /usr/share/dict/words | sort -R | head -n 1`       #te raden woord
TRIES=0      #aantal keren geraden
UNGUESSEDLETTERS=abcdefghijklmnopqrstuvwxyz   #ongeraden letters
CURRENT=    #woord waarmee je speelt
GUESSEDLETTERS=0
MESSAGE=
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'


while getopts d:w: opt
do
 case $opt in
 d)
   if test -f $OPTARG
   then
      WORD=`grep -v  "[^abcdefghijklmnopqrstuvwxyz]" $OPTARG | sort -R | head -n 1`
      if test -z $WORD
      then
        echo -e "${RED}No correct dictionary file: $OPTARG"
        exit
      fi
   else
       echo -e "${RED}Can not find file: $OPTARG"
       exit
   fi
   ;;
 w)
   WORD=$OPTARG
   ;;
 \?)
   echo "invalid option: -$OPTARG" >&2
   exit
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
    printWinner
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
        printf ${GREEN}
      ;;
      [5-7])
        printf ${YELLOW}
      ;;
      [8-9])
        printf ${RED}
      ;;
      10)
        printf ${RED}
      ;;
  esac
  echo  "TRIES LEFT:"  $((10-TRIES))
  printf ${NC}
  echo $CURRENT
}

printWinner(){
currentcolor = ${RED}
countWin=0
while true
do
  case $countWin in
    0) currentcolor=$RED
      countWin=$((countWin+1))
      ;;
    1) currentcolor=$YELLOW
      countWin=$((countWin+1))
      ;;
    2) currentcolor=$GREEN
      countWin=0
      ;;
  esac

  printf "\ec"
  printf ${currentcolor}
  echo ' _    _ _____ _   _  _   _  ___________ '
  echo '| |  | |_   _| \ | || \ | ||  ___| ___ \'
  echo '| |  | | | | |  \| ||  \| || |__ | |_/ /'
  echo '| |/\| | | | | . ` || . ` ||  __||    /'
  echo '\  /\  /_| |_| |\  || |\  || |___| |\ \ '
  echo ' \/  \/ \___/\_| \_/\_| \_/\____/\_| \_|'
  printf ${NC}
  sleep .4
done
}
convert

killGame(){
  printf "\ec"
  echo "The word was: $WORD"
  exit
}

trap killGame SIGINT
while true
do
  print
  getuserinput
  removeUnTriedLetter
  checkGameEnd
done
