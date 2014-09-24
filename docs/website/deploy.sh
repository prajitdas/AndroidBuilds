#!/bin/bash
# This script uses rsync to copies product_site to /home/$user/face_block

server=$1
user=$2
folder=$3

if [ $# -eq 0 ];
  then
    echo "Not enough arguments "
    echo "Usage: ./deploy.sh server user"
    echo "Example: ./deploy.sh ebserv1.cs.umbc.edu kumar1";
else
    rsync -avz --progress production $user@$server:face_block;
fi


