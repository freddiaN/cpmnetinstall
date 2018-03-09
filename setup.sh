#!/bin/bash

### freddiaN's CPMA 1.50 Server Netinstaller script
## This is an automated script used for setting up servers quickly and (hopefully) without any pain points

echo "You are using freddiaN's CPMA 1.50 Server netinstaller."
echo "This script will ask you a few questions and download everything needed to get a server up and running."
echo ""
echo "This script requires you to be on a seperate user (aka. not root) and that wget, screen and unzip are installed."
echo "If you are running the server on a debian-based machine, you can run"
echo ""
echo "sudo apt install screen wget unzip"
echo ""
echo "to install it."
echo ""
echo "The script will start executing once you press something"
read -rsn1

servername="CPMA 1.50 Server"
read -p "Please enter the future name of your Server here (default: CPMA 1.50 Server): " newname
[ -n "$newname" ] && servername=$newname

read -p "Please enter the port you wish to run the server at (default: 27960): " port
port=${port:-27960}

read -p "Please enter a name for the screen session (needed when running multiple servers on the same machine, default: q3): " screenname
screenname=${screenname:-q3}

read -p "If known, please enter the Country the server is hosted in. (use the 2 character shortcode, use discord's flagemotes for reference): " cntry

read -p "If known, please enter the state the server is hosted in (mainly ment for the USA): " stt

read -p "If known, please enter the City the server is hosted in: " cty

read -p "Please enter your Discord username (just username, not the id number): " username
username=${username:-^Pfreddia^NN}

read -p "Please enter your Discord ID (number after the Hash-sign): " dc_id
dc_id=${dc_id:-1337}

read -sp "Please enter the referee password which is used to get admin rights for votes: " refpw

read -sp "Please enter the RCon password used to execute commands on a server level: " rconpw

read -sp "[OPTIONAL] Enter a serverpassword to stop complete randoms to connect to it (nice for PUG focused servers): " serverpw
echo ""

echo "A recap just to make sure you got everything right:"
echo ""
echo "Servername: ${servername}"
echo "Port: ${port}"
echo "Screenname: ${screenname}"
echo "Country: ${cntry}"
echo "State: ${stt}"
echo "City: ${cty}"
echo "Discord user: ${username} hash ${dc_id}"
echo "Referee password: ${refpw}"
echo "RCon password: ${rconpw}"
echo "Server password (if you didn't set one, this will be blank): ${serverpw}"
read -r -p "do you want to continue the installation? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    # Making sure the server is located in $HOME TODO: change this to a variable path
    cd $HOME

    # Get the server files
    wget http://freddian.tf/cpma-barebones-server.zip -O cpma.zip
    unzip cpma.zip

    # Get the .pk3s from somewhere else because I don't wanna get fucked for hosting them myself
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak0.pk3 -O $HOME/serverfiles/baseq3/pak0.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak1.pk3 -O $HOME/serverfiles/baseq3/pak1.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak2.pk3 -O $HOME/serverfiles/baseq3/pak2.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak3.PK3 -O $HOME/serverfiles/baseq3/pak3.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak4.pk3 -O $HOME/serverfiles/baseq3/pak4.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak5.pk3 -O $HOME/serverfiles/baseq3/pak5.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak6.pk3 -O $HOME/serverfiles/baseq3/pak6.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak7.PK3 -O $HOME/serverfiles/baseq3/pak7.pk3
    wget http://game.pioneernet.ru/dl/q3/files/pk3/pak8.pk3 -O $HOME/serverfiles/baseq3/pak8.pk3

    # Create start script
    sed -i -e "s/.screenname/${screenname}/g" $HOME/start.sh
    sed -i -e "s/.port/${port}/g" $HOME/start.sh
    chmod +x $HOME/start.sh

    # setting up q3server.cfg
    cd $HOME/serverfiles/baseq3/
    sed -i -e "s/.servername/${servername}/g" q3server.cfg
    sed -i -e "s/.rconpw/${rconpw}/g" q3server.cfg
    sed -i -e "s/.serverpw/${serverpw}/g" q3server.cfg
    sed -i -e "s/.refpw/${refpw}/g" q3server.cfg
    sed -i -e "s/.country/${cntry}/g" q3server.cfg
    sed -i -e "s/.state/${stt}/g" q3server.cfg
    sed -i -e "s/.city/${cty}/g" q3server.cfg
    sed -i -e "s/.un/${username}/g" q3server.cfg
    sed -i -e "s/.id/${dc_id}/g" q3server.cfg

    # setting up motd.txt
    if [[ "$state" =~ "" ]]
    then
        sed -i -e "s/.country/${cntry}/g" motd.txt
        sed -i -e "s/.city/${cty}/g" motd.txt
    else
        sed -i -e "s/.country/${stt}/g" motd.txt
        sed -i -e "s/.city/${cty}/g" motd.txt
    fi
    
    sed -i -e "s/.un/${username}/g" motd.txt
    sed -i -e "s/.id/${dc_id}/g" motd.txt

    # end script

    echo ""
    echo "Alright, you're now done!"
    echo "From now on you can start the server by running ./start.sh in your home directory."
else
    exit 0
fi
