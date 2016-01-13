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

composer show -i $type/$plugin | grep versions
cd /

case "$type" in
  "wpackagist-plugin")
    base="clam/plugin"
    path="/var/www/html/app/plugins"
  ;;
  "wpackagist-muplugin")
    base="clam/mu-plugin"
    path="/var/www/html/app/mu-plugins"
  ;;
  "wpackagist-theme")
    base="clam/theme"
    path="/var/www/html/app/themes"
  ;;
esac

cat > /plugin/$plugin/Dockerfile <<EOF
FROM $base
COPY ./$plugin $path
VOLUME $path/$plugin
EOF

docker build -t clam/$plugin:latest /plugin/$plugin
echo "Generated image: clam/$plugin"