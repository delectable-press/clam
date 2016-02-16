#!/bin/bash

token=$1

export VAULT_ADDR=http://127.0.0.1:8200
export project="1a5"
export C1="1h2"
export C2="1h3"

# Authenticate with internal vault using token
vault auth $token

# declare some useful utility functions

function get() {
  data=$(curl -u "${user}:${pass}" -X GET \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{}' \
  "${1}")

  echo $data
}

function post() {
  data=$(curl -u "${user}:${pass}" \
-X POST \
-H 'Accept: application/json' \
-H 'Content-Type: application/json' \
-d "${2}" \
"${1}")
}

function get_running_containers() {
  containers=$(get "http://127.0.0.1:8080/v1/projects/$project/hosts/$1/instances")
  echo $containers | jq --raw-output '.data[].actions.stop'
}

function get_stopped_containers() {
  containers=$(get "http://127.0.0.1:8080/v1/projects/$project/hosts/$1/instances")
  echo $containers | jq --raw-output '.data[].actions.remove'
}

function get_needs_purge() {
  containers=$(get "http://127.0.0.1:8080/v1/projects/$project/hosts/$1/instances")
  echo $containers | jq --raw-output '.data[].actions.purge'
}

# Get the current token for rancher
user=$(vault read -format=json secret/rancher/api | jq --raw-output '.data.user')
pass=$(vault read -format=json secret/rancher/api | jq --raw-output '.data.pass')

function stop_all_hosts() {
  # Stop cowboy-01 and cowboy-02 from launching containers
  echo "Deactivating cowboy-01 and cowboy-02"
  post "http://127.0.0.1:8080/v1/projects/$project/hosts/$C1/?action=deactivate"
  post "http://127.0.0.1:8080/v1/projects/$project/hosts/$C2/?action=deactivate"
}

function stop_containers() {
  # Get running containers on cowboy-01 and stop them all
  containers=( $(get_running_containers $1) )
  for container in "${containers[@]}"
  do
    if [ "$container" != "null" ]
    then
      post $container "{\"remove\": true, \"timeout\": 30}"
    fi
  done

  # Wait for all containers to stop
  echo "Waiting for all containers to stop:"
  sleep 60

  # Get all removable containers
  containers=( $(get_stopped_containers $1) )
  for container in "${containers[@]}"
  do
    if [ "$container" != "null" ]
    then
      post $container
    fi
  done

  # wait for host to be clear of stopped containers
  sleep 60

  # Purge host of any removed containers
  containers=( $(get_needs_purge $1) )
  for container in "${containers[@]}"
  do
    if [ "$container" != "null" ]
    then
      post $container
    fi
  done
}

stop_all_hosts
stop_containers $C1
sleep 300
stop_containers $C2
sleep 300

# Shutdown the actual machines
azure account set "Windows Azure MSDN - Visual Studio Ultimate"
azure config mode arm
azure vm deallocate rancher cowboy-01
azure vm deallocate rancher cowboy-02