#!/usr/bin/env bash

apt-get update
apt-get upgrade -y
reboot
sudo su
fdisk /dev/vdb <<EOF
n
p
1

+90G
n
p
2


t
2
82
w
EOF

mkfs.ext4 /dev/vdb1
fallocate -l 4G /swapfile
mkswap /dev/vdb2
swapon /dev/vdb2
mkdir -p /var/lib/docker
mount /dev/vdb1 /var/lib/docker
echo "/dev/vdb1  /var/lib/docker ext4 defaults 0 0" >> /etc/fstab
echo "/dev/vdb2  none  swap sw 0 0" >> /etc/fstab
# Allow logging in via ssh
# login via ssh
sudo su
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y linux-image-extra-$(uname -r) docker-engin
usermod -aG docker ubuntu
nano /etc/default/grub
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1" # and exit
update-grub
reboot
sudo docker run -e CATTLE_HOST_LABELS='env=dev' -d --privileged -v /var/run/docker.sock:/var/run/docker.sock rancher/agent:v0.8.2 http://10.0.0.4:8080/v1/scripts/3B8A4A9F0D28098B8B83:1453687200000:kDQ0ReYLUmjX0BNTqOpdygqZxQ


