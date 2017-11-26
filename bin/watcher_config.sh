#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'

print_red () {
  echo -e ${RED}$1
}
print_green () {
  echo -e ${GREEN}$1
}
print_cyan () {
  echo -e ${CYAN}$1
}

print_green "Watching folder: $AUTO_WATCH_CONFIG files to import (*.sql)"

update_postgres () {
  FILE=$1
  print_cyan "**** updating sql file: $FILE"
  /usr/bin/psql -U $POSTGRES_USER -d $POSTGRES_DB -f $FILE
}

process () {
  PATH=$1
  FILE_NAME=$2
  FILE="$1$2"
  print_green "*** CHECKING $FILE"
  if [[ $FILE_NAME = *.sql ]]; then
    print_red "*** Found sql $FILE_NAME"
    update_postgres $FILE
  fi
}

inotifywait -m -r -e create -e moved_to -e close_write "$1" | 
  while read path action file;
    do
      print_green "*** $action $path $file"
      #process $NEWFILE $FILE_NAME &
      if [[ $action = "MOVED_TO,ISDIR" ]]; then
        print_green "*** DIRECTORY AVAILABLE $path$file for Recursion"
        for f in $path/$file/*
          do
            print_green "*** PROCESSING $f"
            process $path$file $(basename $f) &
          done
      fi
      if [[ $action = "CREATE" ]] \
      || [[ $action = "MOVED_TO" ]] \
      || [[ $action = "CLOSE_WRITE,CLOSE" ]]; then
        print_green "*** FILE AVAILABLE $path$file for Processing"
        process $path $file &
      fi
    done