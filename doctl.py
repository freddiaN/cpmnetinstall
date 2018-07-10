import json
import subprocess
from modules import ssh

# ask for size
sizesList = json.loads((subprocess.run(["doctl", "compute", "size", "list", "--output", "json"], capture_output=True)).stdout)
sizes = []

for size in sizesList:
    sizes.append(size["slug"])

size = input("Which size should the server be (which specs)? " + str(sizes) + ", [s-1vcpu-1gb] ")
if size == "":
    size = "s-1vcpu-1gb"

# get all available regions
regions = []

for i in range(0, len(sizesList)):
    if sizesList[i]["slug"] == size:
        regions = sizesList[i]["regions"]

region = input("Where should the server be hosted? " + str(regions) + " ")

# set used image
imagesList = json.loads((subprocess.run(["doctl", "compute", "image", "list-distribution", "--output", "json"], capture_output=True)).stdout)
images = []

for image in imagesList:
    images.append(image["slug"])

image = input("Which Distrobution should be used? (automatic installation of packages is only supported on Debian and Ubuntu)" + str(images) + " [debian-9-x64] ")
if image == "":
    image = "debian-9-x64"

name = input("What hostname should the Droplet have? (no spaces allowed) ")
print("Name: " + name)
print("Region: " + region)
print("Size: " + size)
print("Distrobution: " + image)
answer = input("Is that OK? [y/n] ")
if answer:
    print("setting up the server")
    output = subprocess.run([
        "doctl", "compute", "droplet", "create",
        name,
        "--image", image,
        "--region", region,
        "--size", size,
        "--ssh-keys", ssh.Key,
        "--output", "json", "--wait"], capture_output=True, encoding="utf-8")

    if "debian" or "ubuntu" in image:
        print(json.loads((subprocess.run(["doctl", "compute", "ssh", name,
                        "--ssh-command", "'apt update; apt dist-upgrade -y; apt install git wget screen unzip -y'"], capture_output=True, encoding="utf-8")).stdout))
    jsonOutput = json.loads(output.stdout)
    print(jsonOutput)
else:
    print(":(")
