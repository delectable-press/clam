#!/usr/bin/with-contenv bash

# This service monitors the service for scaling actions and adds the server (if its the leader)

source /common.sh

probe_hosts() {
  while [ true ]
  do
    echo "I AM LEADER"
    sleep 60
  done
}