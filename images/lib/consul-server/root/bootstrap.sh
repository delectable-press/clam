#!/usr/bin/with-contenv bash

source /common.sh

self=$(curl -s -H 'Accept: application/json' ${META_URL}/self/container| jq -r .name)

echo "Starting bootstrap server"
consul agent $(DC) -config-dir /etc/consul.d/bootstrap -advertise $(get_container_primary_ip $self) &
SERVER="$!"
sleep 5

echo "Waiting for cluster to come online"

online=1
while [ $online -lt 4 ]
do
    online=$(consul members | grep alive | grep server | wc -l)
    echo "Only $online servers, waiting for at least 4"
    sleep 5
done

echo "Enough nodes are online, preparing to rejoin as client"
sleep 30
consul leave
wait $SERVER

consul agent $(DC) -config-dir /etc/consul.d/client -advertise $(get_container_primary_ip $self) -retry-join consul &
CLIENT="$!"
wait $CLIENT