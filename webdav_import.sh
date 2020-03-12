#!/bin/bash -e

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TS=$(date +'%Y%M%D_%H%M%S')
RUBY="/usr/local/rvm/rubies/ruby-2.5.7/bin/ruby"

# prepare directories
WEBDAV="/home/kor/SHARED/webdav"
CURRENT="$WEBDAV/archive/$TS"
rm $WEBDAV/done.txt
mkdir -p $WEBDAV/archive
mv $WEBDAV/new $CURRENT
mkdir -p $WEBDAV/new
sudo chown apache. $WEBDAV/new
sudo chown kor. $CURRENT

# set parameters for import script
export KOR_ROOT="/home/kor/kor"
export SIMULATION="true"
export DO_ENTITIES="true"
export IMAGES_DIR="$CURRENT/images"
export CSV_FILE="$CURRENT/data.csv"

# make a backup
/home/kor/scripts.git/snapshot.sh &> $CURRENT/log.txt

# run the import
sudo -u kor $RUBY $ROOT/import_ALL_2020.rb &>> $CURRENT/log.txt

# clean up
sudo -u kor touch $WEBDAV/done.txt