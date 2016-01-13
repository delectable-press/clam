#!/usr/bin/env bash

plugin="$1"
others="$2"

type=$(dirname $plugin)
plugin=$(basename $plugin)

echo "Creating plugin $plugin of $type"

mkdir -p /plugin/$plugin

# todo: generate all versions ... :)

writeComposer() {

cat > /plugin/composer.json <<EOF
{
  "repositories":[
    {
      "type":"composer",
      "url":"http://wpackagist.org"
    }
  ],
  "extra": {
    "installer-paths": {
      "/plugin/$1/{\$name}/": ["type:wordpress-muplugin", "type:wordpress-plugin", "type:wordpress-theme"]
    }
  },
  "require": {
    "$2/$1": "*"
  }
}
EOF
}
writeComposer $plugin $type

composerInstall() {
cd /plugin

composer install

version=$(composer show -i $2/$1 | grep versions)
version="${version#*:}"
version="${version#*\* }"
cd /
}
composerInstall $plugin $type

setBasePrefix() {

case "$2" in
  "wpackagist-plugin")
    base="ubuntu:14.04"
    prefix="plugin"
    path="/var/www/html/app/plugins/$1"
  ;;
  "wpackagist-muplugin")
    base="ubuntu:14.04"
    prefix="muplugin"
    path="/var/www/html/app/mu-plugins/$1"
  ;;
  "wpackagist-theme")
    base="ubuntu:14.04"
    prefix="theme"
    path="/var/www/html/app/themes/$1"
  ;;
esac
}
setBasePrefix $plugin $type

writeDockerfile() {

cat > /plugin/$1/Dockerfile <<EOF
FROM $2
COPY ./$1 $3
VOLUME $3

ENTRYPOINT /bin/true
EOF
}
writeDockerfile $plugin $base $path

build() {

fullname="$2-$1"
docker build -t clamp/$fullname:latest /plugin/$1
docker tag -f clamp/$fullname:latest clamp/$fullname:$version
docker push clamp/$fullname
}
build $plugin $prefix $version

built="$prefix-$plugin"

if [[ "$othertype" != "" && "$others" == "" ]]
then
  echo "Need to generate $othertype version"
  setBasePrefix $plugin $othertype
  writeDockerfile $plugin $base $path
  build $plugin $prefix $version
  echo "Generated image: clamp/$prefix-$plugin:latest"
  echo "Generated image: clamp/$prefix-$plugin:$version"
fi

echo "Generated image: clamp/$built:latest"
echo "Generated image: clamp/$built:$version"