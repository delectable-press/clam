#!/usr/bin/with-contenv bash

echo "Starting memcached"
exec memcached -u memcache -m "$SIZE" -c "$MAX_CONN" -R "$MAX_REQ" -f "$FACTOR" -n "$KEY_SIZE" -v -t "$THREADS" -D "$DELIMETER" -B "$PROTOCOL" -I "$SLAB"