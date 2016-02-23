# A truly dockerized WordPress

[![Build Status](http://home.withinboredom.info:8090/api/badges/delectable-press/clam/status.svg)](http://home.withinboredom.info:8090/delectable-press/clam)

The goal is to make wordpress hyper-scalable for production use in Docker. There's still work to do; please feel free
to contribute in any way by opening an issue or a PR.

**I spend my day job on OSX and my night work on Windows, so this repo will remain OS agnostic.** 

## How it works

Each plugin is a docker container, built by the image in `images/composer`, allowing for some plugin isolation. You can
find examples of how to build them in `images/build.all`. Then WordPress itself is in another container, using the 
roots/bedrock plugins and folder structure. WordPress is a git subtree from `johnpbloch/wordpress`.
   
The database is served via `tutum/mysql` and includes replication out of the box. Using the hyperdb plugin from the
wordpress.com folks, reads come from the replicas and writes go to the master. Even if the master were to go down, the
replicas would still be serving clients.

Local development is done using `docker-compose` ...

To get started, simply clone this repo and edit any variables (such as WP_HOME, WP_SITEURL), then run `docker-compose up`.

It's designed to be run with docker swarm.

## Still to do

- plugins and hooks
- automatic builds
- documentation
- other things I can't remember right now

If you want to contribute, you have two options:

1. Fork the repository and open a pull request
2. Open an issue with bugs you find or feedback

# Getting started in Windows

This will get you set up for development

1. Get cmdr
1. Get docker toolbox

## Running it

``` powershell
./stacks/start-swarm.ps1
docker-compose up
```

## Building from source

``` powershell
./stacks/start-swarm.ps1
docker build -t clamp/builder images
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /c/Users/YourUserName/.docker/config.json:/root/.docker/config.json --rm clamp/builder --bases --libs --runs --services --plugins --themes --cleanup --seq
docker-compose up
```

# Getting started in OSX

This will get you set up for development

1. get docker toolbox

Bash:
``` bash
./stacks/start-swarm.sh
eval "$(docker-machine env --shell bash default)"
```

FiSH:
``` fish
./stacks/start-swarm.sh
eval (docker-machine env --shell fish default)
```

## Running it

``` bash
docker-compose up
```

## Building from source

``` bash
docker build -t clamp/builder images
docker run -v /var/run/docker.sock:/var/run/docker.sock -v ~/.docker/config.json:/root/.docker/config.json --rm clamp/builder --bases --libs --runs --services --plugins --themes --cleanup --seq
docker-compose up
```

# Available builder options

- `--bases`: Builds base images
- `--libs`: Builds all library containers
- `--runs`: Builds all runable containers that provide continuous services, like web servers.
- `--services`: Builds all infrastructure services, these are single run containers that usually are triggered by events
- `--plugins`: Builds a default set of plugins
- `--themes`: Builds a default set of themes
- `--cleanup`: Runs spotify/docker-gc and removes stale containers and images
- `--push`: Pushes the current version tag (What passes for a release right now)
- `--seq`: Runs builds sequentially instead of in parallel

# License

While this is available to be read for free, I retain all copywrite. It's like a book in the library, you can borrow it,
but you can't steal it. Just kidding. It follows the WordPress license: GPLv2