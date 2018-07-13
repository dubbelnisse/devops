#!/bin/bash

h=${1}
cert_location="/var/lib/docker/certs/"
tls="--tlsverify --tlscacert=${cert_location}ca.crt --tlscert=${cert_location}${h}.crt --tlskey=${cert_location}${h}.key"

mkdir /etc/systemd/system/docker.service.d

echo "
[Service]
Environment="DOCKER_OPTS=-H=0.0.0.0:2376 -H unix:///var/run/docker.sock ${tls}"
" >> /etc/systemd/system/docker.service.d/custom.conf

sudo systemctl daemon-reload
sudo systemctl restart docker
