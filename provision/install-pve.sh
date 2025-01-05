#!/usr/bin/sh

set -eu

if [ "$(id -u)" -ne "0" ]; then
  exec sudo "$0" "$@"
fi

DEBIAN_FRONTEND=noninteractive apt-get install --yes extrepo cpio
extrepo enable proxmox-pve
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install --yes proxmox-ve
