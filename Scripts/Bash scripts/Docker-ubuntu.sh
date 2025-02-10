#!/bin/sh

# echo "installing docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# echo "adding current user to the docker group"
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
