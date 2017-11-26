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

print_green "Watching folder: $AUTO_WATCH_IMPORT files to import (*.osm, *.bz2, *.pbf)"
print_red "Place torrents into $AUTO_IMPORT/torrents to download"
print_red "Administrate the Bittorrents at http://localhost:8080"
print_red "Administrate the database at http://localhost:5050"
print_red "Test the graphiqgl at http://localhost:5000/graphiql"
print_red "Acces the graphql at http://localhost:5000/graphql"

import_planet () {
  FILE=$1
  print_cyan "**** importing planet file: $FILE"
  /usr/bin/osm2pgsql -a -U $POSTGRES_USER -d $POSTGRES_DB --slim $FILE
}
create_planet () {
  FILE=$1
  print_cyan "**** importing planet file: $FILE"
  /usr/bin/osm2pgsql -c -U $POSTGRES_USER -d $POSTGRES_DB --slim $FILE
}
process () {
  PATH=$1
  FILE_NAME=$2
  FILE="$1/$2"
  print_green "*** CHECKING $FILE"
  if [[ $FILE_NAME = changesets-*.osm.bz2 ]]; then 
    print_red "*** Found changeset $FILE_NAME"
    import_planet $FILE
  fi
  if [[ $FILE_NAME = planet-*.osm* ]]; then
    print_red "*** Found planet $FILE_NAME"
    create_planet $FILE
  fi
  if [[ $FILE_NAME = *.osm ]]; then
    print_red "*** Found osm $FILE_NAME"
    import_planet $FILE
  fi
  if [[ $FILE_NAME = *.pbf ]]; then
    print_red "*** Found pbf $FILE_NAME"
    import_planet $FILE
  fi
  if [[ $FILE_NAME = *.bz2 ]]; then
    print_red "*** Found bz2 $FILE_NAME"
    import_planet $FILE
  fi
  /bin/mv "$FILE" "$AUTO_IMPORT/archive/$FILE_NAME"
}

inotifywait -m -r -e create -e moved_to "$1" | 
  while read path action file;
    do
      print_green "*** $action $path $file"
      #process $NEWFILE $FILE_NAME &
      if [[ $action = "MOVED_TO,ISDIR" ]]; then
        print_green "*** DIRECTORY AVAILABLE $path$file for Recursion"
        for f in $path/$file/*
          do
            print_green "*** PROCESSING $f"
            process $path$file $(basename $f)
          done
      fi
      if [[ $action = "CREATE" ]] || [[ $action = "MOVED_TO" ]]; then
        print_green "*** FILE AVAILABLE $path$file for Processing"
        process $path $file
      fi

    done