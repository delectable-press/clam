FROM clamp/lib-php-7
MAINTAINER Rob Landers <landers.robert@gmail.com>
VOLUME /var/www/html

RUN apt-get update \
    && apt-get install apache2 \
    && apt-get clean \
    && a2enmod rewrite \
    && ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
    && ln -sf /proc/self/fd/1 /var/log/apache2/error.log

COPY config/php.ini /etc/php5/apache2/php.ini
COPY config/apache.conf /etc/apache2/apache2.conf

ENV APACHE_LOCK_DIR=/tmp APACHE_PID_FILE=/tmp/apache.pid APACHE_RUN_USER=www-data APACHE_RUN_GROUP=www-data APACHE_LOG_DIR=/var/log/apache2

ENTRYPOINT ["apache2", "-DFOREGROUND", "-e", "info"]