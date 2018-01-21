#!/bin/bash

### freddiaN's CPMA 1.50 Server Netinstaller script
## This is an automated script used for

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

read -sp "Please enter the referee password which is used to get admin rights for votes: " refpw
echo ""

read -sp "Please enter the RCon password used to execute commands on a server level: " rconpw
echo ""

read -sp "[OPTIONAL] Enter a serverpassword to stop complete randoms to connect to it (nice for PUG focused servers): " serverpw
echo ""

echo "A recap just to make sure you got everything right:"
echo ""
echo "Servername: ${servername}"
echo "Port: ${port}"
echo "Screenname: ${screenname}"
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


    # TODO: replace with `sed -i -e 's/abc/XYZ/g' /tmp/file.txt`
    # Create start script
    sed -i -e "s/.screenname/${screenname}/g" $HOME/cpma/start.sh
    sed -i -e "s/.port/${port}/g" $HOME/cpma/start.sh
    chmod +x $HOME/cpma/start.sh

    # setting up q3server.cfg
    cd $HOME/cpma/serverfiles/baseq3/
    sed -i -e "s/.servername/${servername}/g" q3server.cfg
    sed -i -e "s/.rconpw/${rconpw}/g" q3server.cfg
    sed -i -e "s/.serverpw/${serverpw}/g" q3server.cfg
    sed -i -e "s/.refpw/${refpw}/g" q3server.cfg

    # end script

    echo ""
    echo "Alright, you're now done!"
    echo "From now on you can start the server by running ./start.sh in your home directory."
else
    exit 0
fi
