#!/bin/bash

# Move existing source elsewhere

datestamp=`date +"%Y-%m-%d"`

logger -t backup "Initiating restore command $REMOTE_URL -> $SOURCE_DIR"

rotate_dir=/var/backups/$datestamp/
mkdir $rotate_dir -p
cd $SOURCE_DIR
mv * $rotate_dir

logger -t backup "Previous version stored as $rotate_dir"

/usr/local/bin/duplicity restore $@ $REMOTE_URL $SOURCE_DIR

logger -t backup "Restore complete."
