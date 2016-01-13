#!/usr/bin/env bash

plugin="$1"

type=$(dirname $plugin)
plugin=$(basename $plugin)

echo "Creating plugin $plugin of $type"

mkdir -p /plugin/$plugin

# todo: generate all versions ... :)

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
      "/plugin/$plugin/{\$name}/": ["type:wordpress-muplugin", "type:wordpress-plugin", "type:wordpress-theme"]
    }
  },
  "require": {
    "$type/$plugin": "*"
  }
}
EOF

cd /plugin

composer install

version=$(composer show -i $type/$plugin | grep versions)
version="${version#*:}"
version="${version#*\* }"
cd /

case "$type" in
  "wpackagist-plugin")
    base="ubuntu:14.04"
    path="/var/www/html/app/plugins"
  ;;
  "wpackagist-muplugin")
    base="ubuntu:14.04"
    path="/var/www/html/app/mu-plugins"
  ;;
  "wpackagist-theme")
    base="ubuntu:14.04"
    path="/var/www/html/app/themes"
  ;;
esac

cat > /plugin/$plugin/Dockerfile <<EOF
FROM $base
COPY ./$plugin $path
VOLUME $path/$plugin
EOF

docker build -t clamp/$plugin:latest -t clamp/$plugin:$version /plugin/$plugin
docker push clamp/$plugin
echo "Generated image: clamp/$plugin:$version"