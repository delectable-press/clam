FROM clamp/lib-base:latest

RUN apt-get-install-min glusterfs-server glusterfs-client jq curl

EXPOSE 24007
EXPOSE 24007/udp
EXPOSE 24008
EXPOSE 24008/udp
EXPOSE 49152

# Add Giddyup and stuff
COPY root /

RUN chmod +x /giddyup

