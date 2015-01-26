#!/bin/sh

set -e

# Dump environment variables into /root
cat >/root/.cronfile <<EOF
export SOURCE_DIR=$SOURCE_DIR
export REMOTE_URL=$REMOTE_URL
export PASSPHRASE=$PASSPHRASE
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
EOF

chmod 400 /root/.cronfile
