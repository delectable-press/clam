#!/bin/bash

build=$1
tag=$2

push () {
  image=$1
  docker push $image:$build &

  if [ "$tag" != "" ]
  then
    docker push $image:$tag &
  fi
}

push clamp/lib-base
push clamp/lib-consul-server:$$BUILD_NUMBER
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
wait