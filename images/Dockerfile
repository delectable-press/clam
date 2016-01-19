FROM clamp/lib-base
MAINTAINER Rob Landers <landers.robert@gmail.com>

COPY . /build
ENV VERSION 0.1
LABEL version="0.1" description="Builds clamp"

RUN chmod +x /build/build.all

WORKDIR /build
ENTRYPOINT ["/build/build.all"]