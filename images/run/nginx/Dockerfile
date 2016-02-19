FROM clamp/lib-base:$BUILD_NUMBER
MAINTAINER Robert Landers <rlanders@boomtownroi.com>

# Install nginx and have it forward logs to Docker
RUN apk add --no-cache nginx \
    && mkdir -p /var/log/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Add the files
COPY config/ /etc/nginx
COPY serve.sh /etc/services.d/nginx/run
COPY finish.sh /etc/services.d/nginx/finish

# Expose the ports for nginx
EXPOSE 80
EXPOSE 443