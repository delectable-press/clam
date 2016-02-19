FROM clamp/lib-base:$BUILD_NUMBER
MAINTAINER Rob Landers <landers.robert@gmail.com>

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache \
        php7@testing \
        php7-common@testing \
        php7-mcrypt@testing \
        php7-mysqli@testing \
        php7-gd@testing \
        php7-curl@testing \
        php7-cgi@testing \
        php7-opcache@testing