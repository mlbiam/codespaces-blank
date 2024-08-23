#!/bin/bash

# install pen to setup additional ports to forward
sudo apt-get update
sudo apt-get install pen

# setup pen for the dashboard and API server
pen 10444 127.0.0.1:443
pen 10445 127.0.0.1:443

OU_HOST="$CODESPACE_NAME-443.app.github.dev"
DB_HOST="$CODESPACE_NAME-10444.app.github.dev"
API_HOST="$CODESPACE_NAME-10445.app.github.dev"

echo $OU_HOST
echo $DB_HOST
echo $API_HOST

