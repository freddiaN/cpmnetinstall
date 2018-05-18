#!/bin/bash
screen -dmS .screenname serverfiles/cnq3-server-x64 +set net_port .port +set sv_punkbuster 0 +set fs_basepath .dir/serverfiles +set dedicated 2 +set com_hunkMegs 512 +exec q3server.cfg +map cpm22 +set fs_game cpma
