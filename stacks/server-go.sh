#!/bin/bash

echo "This script provisions an Azure vm... interactively (right now)..."
echo "Lets get started. PS. Make sure you're root."
echo
echo "Press any key to continue, or hit ctrl-c if not root..."
read -N 1 -s

echo "Creating swap file"
cat > /etc/init.d/swap <<EOF
#!/bin/bash

### BEGIN INIT INFO
# Provides:          swapfile
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Short-Description: Inits dynamic swapfile in cloud env
### END INIT INFO

set -e

if [ ! -f /mnt/swap ]
then
  fallocate -l 50G /mnt/swap
  chmod 600 /mnt/swap
fi

mkswap /mnt/swap
swapon /mnt/swap

# Put in /etc/init.d/swap
# chmod +x /etc/init.d/swap
# update-rc.d swap defaults
EOF

chmod +x /etc/init.d/swap
update-rc.d swap defaults
/etc/init.d/swap

echo "Swap file created"

echo "Updating server"
apt-get update
sleep 5
apt-get upgrade -y
sleep 5
echo "Installing tools"
apt-get install -y htop mdadm btrfs-tools

echo "Installing RAID0"
mdadm --create /dev/md/data --name=data --chunk=8 --level=0 --raid-devices=2 /dev/sdc /dev/sdd
mdadm --detail --verbose --scan > /etc/mdadm/mdadm.conf

echo "Partitioning drive"
fdisk -c -u /dev/md/data << EOF
n
p
1


w
EOF

echo "Creating filesystem"
mkfs.btrfs -f /dev/md127p1
mkdir -p /var/lib/docker
blkid /dev/md127p1

echo "Copy UUID from above and put into fstab... "
echo "UUID=<UUID> /var/lib/docker btrfs defaults 0 0" >> /etc/fstab

nano /etc/fstab

echo "Installing docker"
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list

sleep 5
apt-get update
sleep 5
apt-get install -y linux-image-extra-$(uname -r)
sleep 5
apt-get install -y docker-engine
usermod -aG docker robert
echo "GRUB_CMDLINE_LINUX=\"cgroup_enable=memory swapaccount=1\"" >> /etc/default/grub
update-grub
update-initramfs -u

echo "Adding trim to crontab"
echo "0 * * * * fstab /var/lib/docker" | crontab -

echo "Everything figured out -- rebooting"
reboot