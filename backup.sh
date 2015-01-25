#!/bin/bash

output=$(mktemp)

function finish {
    rm $output
}
trap finish EXIT

backup_type=${1:-incremental}

/usr/local/bin/duplicity $backup_type --allow-source-mismatch $SOURCE_DIR $REMOTE_URL > $output 2>&1

code=$?

if [ "$code" -ne 0 ] ; then
    echo "backup failure - action=$backup_type - exit=$code"
    cat $output
    rm $output
    /usr/bin/duply $profile cleanup --force > /dev/null 2>&1
    exit $code
fi

cat $output

# grab some stats
NewFiles=`grep NewFiles $output | awk '{print $2}'`
DeletedFiles=`grep DeletedFiles $output | awk '{print $2}'`
ChangedFiles=`grep ChangedFiles $output | awk '{print $2}'`

echo "backup success - action=$backup_type - exit=$code - new=$NewFiles - delete=$DeletedFiles - change=$ChangedFiles"
