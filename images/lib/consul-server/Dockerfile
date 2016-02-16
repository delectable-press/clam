FROM clamp/lib-base:latest

RUN apt-get-install-min jq curl

COPY root /

RUN groupadd -r consul \
    && useradd -r -g consul consul \
    && chmod +x /*.sh