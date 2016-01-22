#!/usr/bin/with-contenv bash

printenv

cat > /etc/nginx/upstreams/proxy.conf <<EOF
upstream php {
	server ${PHP_PROXY_1_PORT_9000_TCP_ADDR}:9000;
}
EOF

exec /usr/sbin/nginx