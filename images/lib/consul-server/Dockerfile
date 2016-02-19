FROM clamp/lib-base:$BUILD_NUMBER

RUN apk add --no-cache jq curl

COPY root /

RUN adduser -S consul \
    && chmod +x /*.sh