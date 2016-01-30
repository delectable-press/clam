#!/bin/bash

### BEGIN INIT INFO
# Provides:          swapfile
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Short-Description: Inits dynamic swapfile in cloud env
### END INIT INFO

set -e

if [ ! -f /mnt/swap ]
then
  fallocate -l 50G /mnt/swap
  chmod 600 /mnt/swap
  mkswap /mnt/swap
  swapon /mnt/swap
fi

# Put in /etc/init.d/swap
# chmod +x /etc/init.d/swap
# update-rc.d swap defaults