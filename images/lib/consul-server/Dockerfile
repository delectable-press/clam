FROM clamp/lib-base:$BUILD_NUMBER

RUN apt-get-install-min jq curl

COPY root /

RUN groupadd -r consul \
    && useradd -r -g consul consul \
    && chmod +x /*.sh