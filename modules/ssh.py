import subprocess
import json
import getpass
from pathlib import Path

Key = ""

def genNewKey():
    sshKeyPath = input("Enter the path for your new SSH key [/home/username/.ssh/id_rsa] ")
    if sshKeyPath == "":
        sshKeyPath = str(Path.home()) + "/.ssh/id_rsa"
    pw = getpass.getpass(prompt="Enter your SSH key password (leave blank for no password) ")
    keyName = input("What should be the name of the key in DigitalOcean? ")
    print("Creating an SSH key...")
    subprocess.run(["ssh-keygen", "-t", "rsa",
                    "-f", sshKeyPath,
                    "-P", pw])
    print("Uploading the key to DigitalOcean...")
    Key = json.loads(subprocess.run(["doctl", "compute", "ssh-key",
                                     "import", keyName,
                                     "--public-key-file", sshKeyPath + ".pub",
                                     "--output", "json"]))[0]["fingerprint"]

def uploadNewKey():
    path = input("Provide the path to your Public SSH key: ")
    name = input("What should be the name of the key in DigitalOcean? ")
    Key = json.loads(subprocess.run(["doctl", "compute", "ssh-key", "import", name, "--public-key-file", path, "--output", "json"]))[0]["fingerprint"]

# check for SSH keys on DO account
sshKeyList = json.loads((subprocess.run(["doctl", "compute", "ssh-key", "list", "--output", "json"], capture_output=True)).stdout)

# add SSH key to DO account and use it
if len(sshKeyList) == 0:
    a = input("There is no SSH Key on your DigitalOcean account. Do you want to generate a new one? [y/n]")
    if a == "y":
        genNewKey()
    else:
        uploadNewKey()

# either use account on DO account or upload a new one
elif len(sshKeyList) == 1:
    o = input("There's already an SSH key on your DigitalOcean account. Do you want to use it? [y/n] ")
    if o == "y":
        sshKey = sshKeyList[0]["fingerprint"]
    else:
        a = input("Do you want to use an existing key or generate a new one? [existing/generate]")
        if a == "existing":
            uploadNewKey()
        elif a == "generate":
            genNewKey()
        else:
            print("Please choose either 'existing' or 'generate'")
            a = input("Do you want to use an existing key or generate a new one? [existing/generate]")

# if there are more than 1 SSH key in the DO account, let the user choose one (and leave the upload option still open)
elif len(sshKeyList) > 1:
    print("There's more than 1 SSH key on your DigitalOcean account. Which one do you want to choose? (type 'new' if you want to upload a new SSH key and 'gen' if you want to generate a new key)")
    list = []
    for key in sshKeyList:
        list.append(key["name"])
    o = input(list + " ")
    if o == "new":
        uploadNewKey()
    elif o == "gen":
        genNewKey()
    else:
        for i in range(0, len(sshKeyList)):
            if sshKeyList[i]["name"] == o:
                Key = sshKeyList[i]["fingerprint"]
