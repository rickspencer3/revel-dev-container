#!/bin/bash

#call useful embedded functions
source /opt/bitnami/stacksmith-utils.sh
print_welcome_page
check_for_updates &

#set app name to ENV or default
AP="my-app"

if [ "$APP_NAME" != "" ]; then
    AP=$APP_NAME
fi

#set path to github user or default
P=""
if [ "$GITHUB_USER" != "" ]; then
  P="github.com/$GITHUB_USER/$AP"
else
  P="$AP"
fi

echo "Using $P for application path"

#create the app if necessary
if [ ! -d "/app/src/" ]; then
  echo -e  "Creating Revel App"
  revel new $P
else
  echo -e "App found, reusing"
fi

#run the app
revel run $P
