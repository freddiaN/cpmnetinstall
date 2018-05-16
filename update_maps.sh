#!/usr/bin/env bash

# Arctic's script to update/fetch custom maps, currently only a very few amount of maps uploaded.
# Make sure you gave your public SSH key from your server to @ArcticRevrus#0476

if [ -d "$1" ]
then
    sftp -a mapsync@getserved.tv:/sftp/maps/*.pk3 $1
else
    echo "$1 is not a valid directory\nUsage: sh mapsync /path/to/quake/maps/folder/"
fi
