#!/usr/bin/env python

import pysftp
from pathlib import Path

server = "getserved.tv"
user = "mapsync"

with pysftp.Connection(server, username=user, private_key=str(Path.home()) + "/.ssh/id_rsa") as sftp:
    for file in sftp.listdir("/sftp/maps/"):
        if ".pk3" in file:
            sftp.get("/sftp/maps" + file, ".dir/serverfiles/baseq3/")
