# Building all the things

Run from the project root directory:

``` bash
docker build -t clamp/builder images
docker run -v /var/run/docker.sock:/var/run/docker.sock -v /c/Users/withi/.docker/config.json:/root/.docker/config.json --rm clamp/builder
```