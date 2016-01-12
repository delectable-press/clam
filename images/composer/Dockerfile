FROM ubuntu:14.04

MAINTAINER Robert Landers <landers.robert@gmail.com>

RUN apt-get update \
    && apt-get install -y php5-cli php5-mysql php-apc php5-curl php5-gd \
       php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcached php5-ming \
       php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xdebug curl wget git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT [ "/usr/local/bin/composer" ]
