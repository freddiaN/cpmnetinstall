#!/usr/bin/env bash

# set script to fail completely if just 1 part fails
set -e

# make sure directories exist
cd $DIR
mkdir -p serverfiles/baseq3
mkdir -p serverfiles/cpma
mkdir -p serverfiles/missionpack


if [ ! -f $DIR/serverfiles/cpma/z-cpma-pak*.pk3 ]; then
    cd $DIR/serverfiles
    CPMA_VERSION=1.51
    echo "Downloading CPMA..."
    wget -Nq https://cdn.playmorepromode.com/files/cpma/cpma-${CPMA_VERSION}-nomaps.zip
    unzip -q cpma-${CPMA_VERSION}-nomaps.zip
    rm -rf cpma/stats cpma/*.txt cpma/*.ico cpma/hud
    rm cpma-${CPMA_VERSION}-nomaps.zip
    echo "CPMA downloaded."
    cd $DIR
else
    echo "CPMA already exists."
fi

if [ ! -f $DIR/serverfiles/baseq3/pak1.pk3 ]; then
    cd $DIR/serverfiles
    echo "Downloading Quake 3 patch data..."
    wget -Nq https://www.ioquake3.org/data/quake3-latest-pk3s.zip --referer https://ioquake3.org/extras/patch-data/
    unzip -nq quake3-latest-pk3s.zip
    mv quake3-latest-pk3s/baseq3/*.pk3 baseq3/
    mv quake3-latest-pk3s/missionpack/*.pk3 missionpack/
    rm -rf quake3-latest-pk3s
    rm quake3-latest-pk3s.zip
    echo "Quake 3 patch data downloaded."
    cd $DIR
else
    echo "Quake 3 patch data already exists."
fi

if [ ! -f $DIR/serverfiles/baseq3/map_cpm3a.pk3 ]; then
    cd $DIR/serverfiles
    echo "Downloading CPMA mappack..."
    wget -Nq https://cdn.playmorepromode.com/files/cpma-mappack-full.zip
    mv cpma-mappack-full.zip baseq3/
    cd baseq3/
    unzip -q cpma-mappack-full.zip
    rm cpma-mappack-full.zip
    cd ..
    echo "CPMA mappack downloaded."
    cd $DIR
else
    echo "CPMA mappack already exists."
fi

if [ ! -f $DIR/serverfiles/cnq3-server-x64 ]; then
    cd $DIR/serverfiles
    echo "Downloading CNQ3 server binary..."
    wget -Nq https://cdn.playmorepromode.com/files/latest/cnq3-1.50.zip
    unzip -q cnq3-1.50.zip
    chmod +x cnq3-server-x64
    rm cnq3-1.50.zip cnq3-server-*.exe cnq3-x* readme.txt changelog.txt
    echo "CNQ3 server binary downloaded."
    cd $DIR
else
    echo "CNQ3 server binary already exists."
fi

if [ ! -f $DIR/serverfiles/baseq3/pak0.pk3 ]; then
    echo "baseq3/pak0.pk3 missing... please upload it manually."
else
    echo "baseq3/pak0.pk3 exists."
fi


