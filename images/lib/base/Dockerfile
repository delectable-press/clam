FROM clamp/lib-volume:latest

ENV CONSUL_VERSION=0.6.3
ENV VAULT_VERSION=0.4.1
RUN apt-get-install-min wget unzip \
    && wget https://releases.hashicorp.com/consul/$CONSUL_VERSION/consul_${CONSUL_VERSION}_linux_amd64.zip \
    && unzip consul_${CONSUL_VERSION}_linux_amd64.zip \
    && rm -rf consul_${CONSUL_VERSION}_linux_amd64.zip \
    && wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
    && unzip vault_${VAULT_VERSION}_linux_amd64.zip \
    && rm -rf vault_${VAULT_VERSION}_linux_amd64.zip \
    && apt-get remove wget unzip -y --purge \
    && apt-get clean