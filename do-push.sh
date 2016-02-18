#!/bin/bash

build=$1
tag=$2
pids=""
WAITALL_DELAY=10

push () {
  image=$1
  docker push $image:$build &
  pids="$pids $!"

  if [ "$tag" != "" ]
  then
    docker push $image:$tag &
    pids="$pids $!"
  fi
}

debug() { echo "DEBUG: $*" >&2; }

waitall() { # PID...
  ## Wait for children to exit and indicate whether all exited with 0 status.
  local errors=0
  while :; do
    debug "Processes remaining: $*"
    for pid in "$@"; do
      shift
      if kill -0 "$pid" 2>/dev/null; then
        debug "$pid is still alive."
        set -- "$@" "$pid"
      elif wait "$pid"; then
        debug "$pid exited with zero exit status."
      else
        debug "$pid exited with non-zero exit status."
        exit 1
        ((++errors))
      fi
    done
    (("$#" > 0)) || break
    # TODO: how to interrupt this sleep when a child terminates?
    sleep ${WAITALL_DELAY:-1}
   done
  ((errors == 0))
}

push clamp/lib-base
push clamp/lib-consul-server
push clamp/lib-mysql
push clamp/lib-php-7
push clamp/lib-volume
push clamp/run-haproxy
push clamp/run-memcached
push clamp/run-mysql
push clamp/run-nginx
push clamp/run-php-fpm
push clamp/run-plugin
push clamp/run-wordpress
push clamp/srv-composer
waitall $pids