#!/bin/bash

### freddiaN's CPMA Server Netinstaller script
## This is an automated script used for setting up servers quickly and (hopefully) without any pain points

echo "You are using freddiaN's CPMA 1.50 Server netinstaller."
echo "This script will ask you a few questions and download everything needed to get a server up and running."
echo ""
echo "This script requires you to be on a seperate user (aka. not root) and that wget, screen, unzip and git are installed."
echo "If you are running the server on a debian-based machine, you can run"
echo ""
echo "sudo apt install screen wget unzip"
echo ""
echo "to install it."
echo ""
echo "The script will start executing once you press something"
read -rsn1

SERVERNAME="CPMA 1.50 Server"
read -p "Please enter the future name of your Server here (default: CPMA 1.50 Server): " newname
[ -n "$newname" ] && SERVERNAME=$newname

read -p "Please enter the port you wish to run the server at (default: 27960): " PORT
PORT=${PORT:-27960}

read -p "Please enter a name for the screen session (needed when running multiple servers on the same machine, default: q3): " SCREENNAME
SCREENNAME=${SCREENNAME:-q3}

read -p "Please enter the directory you want the server to be installed in (default: your home dir): " DIR
DIR=${1:-$HOME}

read -p "If known, please enter the country the server is hosted in. (use the 2 character shortcode, use discord's flagemotes for reference): " COUNTRY

read -p "If known, please enter the state the server is hosted in (mainly ment for the USA): " STATE

read -p "If known, please enter the City the server is hosted in: " CITY

read -p "Please enter your Discord username (just username, not the id number): " USERNAME
USERNAME=${USERNAME:-^pfreddia^nn}

read -p "Please enter your Discord ID (number after the Hash-sign): " DC_ID
DC_ID=${DC_ID:-0820}

read -sp "Please enter the referee password which is used to get admin rights for votes: " REFPW
echo ""

read -sp "Please enter the RCon password used to execute commands on a server level: " RCONPW
echo ""

read -p "[OPTIONAL] Enter a serverpassword to stop complete randoms to connect to it (nice for PUG focused servers): " SERVERPW
echo ""

echo "A recap just to make sure you got everything right:"
echo ""
echo "Servername: ${SERVERNAME}"
echo "Port: ${PORT}"
echo "Screenname: ${SCREENNAME}"
echo "Installation directory: ${DIR}"
echo "Country: ${COUNTRY}"
echo "State: ${STATE}"
echo "City: ${CITY}"
echo "Discord user: ${USERNAME} hash ${DC_ID}"
echo "Referee password: ${REFPW}"
echo "RCon password: ${RCONPW}"
echo "Server password (if you didn't set one, this will be blank): ${SERVERPW}"
read -r -p "do you want to continue the installation? [y/N] " RESPONSE

if [[ "$RESPONSE" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    mkdir -p $DIR
    cd $DIR

    # grabbing repo silently in the background to copy stuff from :)
    # The first thing we'll do with it is executing the init.sh script
    echo "Fetching init.sh and running it..."
    TEMP_REPO=$HOME/.temprepoclone
    git clone https://gitlab.com/rehtlaw/cpmnetinstall.git --quiet $TEMP_REPO

    # execing init script
    source $TEMP_REPO/init.sh

    # moving things from $TEMP_REPO/serverfiles into main folder
    mv $TEMP_REPO/start.sh $DIR/start.sh
    mv $TEMP_REPO/serverfiles/cpma/motd.txt $TEMP_REPO/serverfiles/cpma/q3server.cfg $DIR/serverfiles/cpma
    mv $TEMP_REPO/serverfiles/cpma/cfg-maps/* $DIR/serverfiles/cpma/cfg-maps/
    mv $TEMP_REPO/serverfiles/baseq3/q3config.cfg $TEMP_REPO/serverfiles/baseq3/q3key $DIR/serverfiles/baseq3/

    # Create start script
    sed -i -e "s/\.SCREENNAME/${SCREENNAME}/g" start.sh
    sed -i -e "s/\.port/${PORT}/g" start.sh
    sed -i -e "s|\.dir|'$DIR'|g" start.sh
    chmod +x start.sh

    # setting up q3server.cfg
    cd serverfiles/cpma/
    sed -i -e "s/\.servername/${SERVERNAME}/g" q3server.cfg
    sed -i -e "s/\.rconpw/${RCONPW}/g" q3server.cfg
    sed -i -e "s/\.serverpw/${SERVERPW}/g" q3server.cfg
    sed -i -e "s/\.refpw/${REFPW}/g" q3server.cfg
    sed -i -e "s/\.country/${COUNTRY}/g" q3server.cfg
    sed -i -e "s/\.state/${STATE}/g" q3server.cfg
    sed -i -e "s/\.city/${CITY}/g" q3server.cfg
    sed -i -e "s/\.un/${USERNAME}/g" q3server.cfg
    sed -i -e "s/\.id/${DC_ID}/g" q3server.cfg

    if [[ "$STATE" =~ "" ]]
    then
        sed -i -e "s/\.state\.country/${COUNTRY}/g" q3server.cfg
    else
        sed -i -e "s/\.state\.country/${STATE}/g" q3server.cfg
    fi

    # setting up motd.txt
    if [[ "$STATE" =~ "" ]]
    then
        sed -i -e "s/\.state\.country/${COUNTRY}/g" motd.txt
        sed -i -e "s/\.city/${CITY}/g" motd.txt
    else
        sed -i -e "s/\.state\.country/${STATE}/g" motd.txt
        sed -i -e "s/\.city/${CITY}/g" motd.txt
    fi

    sed -i -e "s/\.un/${USERNAME}/g" motd.txt
    sed -i -e "s/\.id/${DC_ID}/g" motd.txt

    # end script

    echo ""
    echo "Alright, you're now (nearly) done!"
    echo "You will still need to manually upload pak0.pk3 to ${DIR}/serverfiles/baseq3/"
    echo "When you are done with that, you can start the server with ./start.sh in ${DIR}."
else
    exit 0
fi
