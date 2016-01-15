FROM ubuntu:14.04
RUN apt-get update \
    && apt-get install -y cifs-utils \
    && apt-get clean

COPY serve.sh /serve.sh

RUN chmod +x /serve.sh && chmod +s /sbin/mount.cifs

ENTRYPOINT /serve.sh
