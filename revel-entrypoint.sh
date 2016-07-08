#!/bin/bash

#call useful embedded functions
source /opt/bitnami/stacksmith-utils.sh
print_welcome_page
check_for_updates &

#create the app
revel new github.com/githubuser/myapp

#run the app
revel run github.com/githubuser/myapp
