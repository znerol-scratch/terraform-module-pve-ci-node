#!/usr/bin/sh

set -eu

if [ "$(id -u)" -ne "0" ]; then
  exec sudo "$0" "$@"
fi

grep --quiet --fixed-strings 'source /etc/network/interfaces.d/sdn' /etc/network/interfaces || \
  echo 'source /etc/network/interfaces.d/sdn' | tee -a /etc/network/interfaces > /dev/null
