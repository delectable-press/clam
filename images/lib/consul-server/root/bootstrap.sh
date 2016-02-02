#!/usr/bin/with-contenv bash

source /common.sh

self=$(curl -s -H 'Accept: application/json' ${META_URL}/self/container| jq -r .name)

echo "Starting bootstrap server"
consul agent $(DC) -config-dir /etc/consul.d/bootstrap -bind $(get_container_primary_ip $self) &
SERVER="$!"
sleep 5

echo "Waiting for cluster to come online"

online=$(consul members | grep alive | grep server | wc -l)
while [ $online -lt 3 ]
do
    echo "Only $online servers, waiting for at least 3"
    sleep 5
done

echo "Enough nodes are online, preparing to rejoin as client"
consul leave
wait $SERVER

consul agent $(DC) -config-dir /etc/consul.d/client -bind $(get_container_primary_ip $self) &
CLIENT="$!"

echo "Client started - entering self-heal mode"
online=$(consul members | grep alive | grep server | wc -l)
while [ $online -gt 2 ]
do
    sleep 30
done

echo "Lost enough nodes to require self-healing"
echo "Dieing in order to recreate cluster state..."
consul leave
wait $CLIENT