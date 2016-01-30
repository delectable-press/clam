#!/bin/bash
IP=$( ip addr show dev eth0 to 10.42.0.0/16 | grep -E 'inet' | grep -Po '(\d+\.)+\d+' )
echo "Binding to $IP"
consul agent -bind $IP -advertise $IP $@