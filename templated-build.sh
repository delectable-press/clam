#!/bin/bash

apply_shell_expansion() {
    declare file="$1"
    declare data=$(< "$file")
    declare delimiter="__apply_shell_expansion_delimiter__"
    declare command="cat <<$delimiter"$'\n'"$data"$'\n'"$delimiter"
    eval "$command"
}

BUILD_NUMBER=$3
BUILD_TYPE=$1
BUILD_NAME=$2
BUILD=images/$BUILD_TYPE/$BUILD_NAME
IMAGE=clamp/$BUILD_TYPE-$BUILD_NAME
$(cat $BUILD/Dockerfile | grep ENV | cut -d \  -f 2 | cut -d = -f 1 | xargs -L1 ./export.sh)
apply_shell_expansion $BUILD/Dockerfile > $BUILD/Dockerfile-store
mv $BUILD/Dockerfile-store $BUILD/Dockerfile
docker build -t $IMAGE:$$BUILD_NUMBER $BUILD