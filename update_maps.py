#!/usr/bin/env python

import pysftp
import re
from pathlib import Path

server = "getserved.tv"
user = "mapsync"

with pysftp.Connection(server, username=user, private_key=str(Path.home()) + "/.ssh/id_rsa") as sftp:
    with sftp.cd("/sftp/maps"):
        sftp.get(re.compile("^[^\s]*.pk3$"), ".dir/serverfiles/baseq3/")
