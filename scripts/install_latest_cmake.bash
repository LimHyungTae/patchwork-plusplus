#!/usr/bin/env bash
set -e

SUDO=${SUDO:=sudo} # SUDO=command in docker (running as root, sudo not available)
if [ "$1" == "assume-yes" ]; then
    APT_CONFIRM="--assume-yes"
else
    APT_CONFIRM=""
fi

$SUDO apt-get update -y
$SUDO apt-get install git libeigen3-dev python3-pip -y

# Install CMake > 3.20 for Open3D 0.18.0 version
# Please refer to 'https://apt.kitware.com/'
$SUDO apt-get install ca-certificates gpg wget -y
test -f /usr/share/doc/kitware-archive-keyring/copyright ||
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | $SUDO tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null

echo "deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | $SUDO tee /etc/apt/sources.list.d/kitware.list >/dev/null
$SUDO apt-get update -y
$SUDO apt-get install cmake -y
