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
    # Get the server files
    wget http://freddian.tf/cpma-barebones-server.zip
    unzip cpma-barebones-server.zip

    # Create start script
    touch $HOME/start.sh
    cat > $HOME/start.sh << "EOF"
    #!/bin/bash
    screen -dmS ${screenname} serverfiles/q3ded +set net_port ${port} +set sv_punkbuster 0 +set fs_basepath $HOME/serverfiles +set dedicated 2 +set com_hunkMegs 512 +exec q3server.cfg +map cpm22 +set fs_game cpma
    EOF
    chmod +x start.sh

    # setting up q3server.cfg
    touch $HOME/serverfiles/baseq3/q3server.cfg
    cat > $HOME/serverfiles/baseq3/q3server.cfg << "EOF"
    set sv_hostname "${servername}"
    set sv_maxclients 16
    set g_forcerespawn 15
    set rconpassword "${rconpw}"
    set g_gametype 0
    set g_password "${serverpw}"
    set fraglimit 0
    set timelimit 10

    set mode_start "1v1"
    set server_gameplay "CPM"
    set server_optimiseBW 1
    set ref_password "${refpw}"
    set team_allcaptian 0
    set match_readypercent 100
    set g_allowVote 1
    set vote_percent 51
    seta map_restrict 0
    seta sv_fps 40
    set sv_fps 40
    set sv_allowDownload 1
    set vote_allow_gameplay "CPM"
    set map_delay 30
    set map_rotate 0
    set server_record 0
    set server_motdfile motd.txt
    EOF

    # end script

    echo ""
    echo "Alright, you're now done!"
    echo "From now on you can start the server by running ./start.sh in your home directory."
else
    exit 0
fi
