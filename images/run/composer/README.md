# This container composes plugins in docker

# Introduction

This container builds data volumes with a given plugin/mu-plugin/theme and pushes it

## It's terrifying...

Invoking the terrifying shit:

``` bash
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /c/Users/withi/code/clam/images/composer/mkplugin.sh:/mkplugin.sh -v /c/Users/withi/.docker/config.json:/root/.docker/config.json --rm clamp/run-composer wpackagist-plugin/captcha # the composer name of the plugin/theme/etc
```