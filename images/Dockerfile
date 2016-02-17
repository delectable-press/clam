FROM clamp/lib-base
MAINTAINER Rob Landers <landers.robert@gmail.com>

COPY . /build
ENV VERSION 0.2.1
LABEL version="0.2.1" description="Builds clamp"

RUN apt-get update \
    && apt-get install -y apt-transport-https \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get purge lxc-docker \
    && apt-get install -y docker-engine subversion \
    && apt-get clean

RUN chmod +x /build/build.all

WORKDIR /build
ENTRYPOINT ["/build/build.all"]