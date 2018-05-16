#!/usr/bin/env bash

if [ -d "$1" ]
then
    sftp -a mapsync@getserved.tv:/sftp/maps/*.pk3 $1
else
    echo "$1 is not a valid directory\nUsage: sh mapsync /path/to/quake/maps/folder/"
fi
