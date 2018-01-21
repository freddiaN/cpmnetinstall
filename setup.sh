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
    # Making sure the server is located in $HOME @TODO: change this to a variable path
    cd $HOME

    # Get the server files
    wget http://freddian.tf/cpma-barebones-server.zip
    unzip cpma-barebones-server.zip


    # Create start script
    touch $HOME/start.sh
    echo "#!/bin/bash" >> $HOME/start.sh
    echo "screen -dmS ${screenname} serverfiles/q3ded +set net_port ${port} +set sv_punkbuster 0 +set fs_basepath $HOME/serverfiles +set dedicated 2 +set com_hunkMegs 512 +exec q3server.cfg +map cpm22 +set fs_game cpma" >> $HOME/start.sh
    chmod +x start.sh

    # setting up q3server.cfg
    touch $HOME/serverfiles/baseq3/q3server.cfg
    echo "sv_hostname ${servername}" > $HOME/serverfiles/baseq3/q3server.cfg
    echo "set sv_maxclients 16" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set g_forcerespawn 15" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set rconpassword "${rconpw}"' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set g_gametype 0" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set g_password "${serverpw}"' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set fraglimit 0" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set timelimit 10" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set mode_start "1v1"' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set server_gameplay "CPM"' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set server_optimiseBW 1" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set ref_password "${refpw}"' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set team_allcaptian 0' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set match_readypercent 100" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set g_allowVote 1" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set vote_percent 51" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "seta map_restrict 0" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "seta sv_fps 40" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set sv_fps 40" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo "set sv_allowDownload 1" >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set vote_allow_gameplay "CPM"' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set map_delay 30' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set map_rotate 0' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set server_record 0' >> $HOME/serverfiles/baseq3/q3server.cfg
    echo 'set server_motdfile motd.txt' >> $HOME/serverfiles/baseq3/q3server.cfg

    # end script

    echo ""
    echo "Alright, you're now done!"
    echo "From now on you can start the server by running ./start.sh in your home directory."
else
    exit 0
fi
