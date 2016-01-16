#!/bin/bash

echo "Mounting share $1 in account $2"

share=$1
account=$2
key=$3
mount=$4

mkdir -p $mount
#mount -t cifs //$account.file.core.windows.net/$share $mount -o username=$account,password=$key,dir_mode=0777,file_mode=0666
mount -t cifs --verbose //donkeykong.file.core.windows.net/test-share /test -o "username=donkeykong,password=ariH8fPYaD3GKPlfQrUruJCRCaJ33ruupdAnTJZav3jU9YrJADQ18o1yaVqopN0Ji0mMOI5IEbgehOZ3dbuYsA==,dir_mode=0777,file_mode=0600,sec=ntlm"
mounted=$?
echo "Mounted"

if [ "$mounted" != "0" ]
then
  exit 1
fi

while true
do
  sleep 3600
done