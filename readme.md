# Getting started in Windows

1. Get cmdr
1. Get docker toolbox

``` powershell
docker-machine create --driver virtualbox --virtualbox-memory=2048 --virtualbox-cpu-count=2 default
docker-machine.exe env --shell powershell default | Invoke-Expression
docker build -t clamp/builder images
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /c/Users/withi/.docker/config.json:/root/.docker/config.json --rm clamp/builder

