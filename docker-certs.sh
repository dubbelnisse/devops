#!/bin/bash

h=${1}
# listen="-H unix:\/\/\/var\/run\/docker.sock -H tcp:\/\/0.0.0.0:2376"
cert_location="\/var\/lib\/docker\/certs\/"
default_options="--default-ulimit nofile=1024:4096"
tls="--tlsverify --tlscacert=${cert_location}ca.crt --tlscert=${cert_location}${h}.crt --tlskey=${cert_location}${h}.key"

# sudo sed -i "s/^OPTIONS=.*/OPTIONS=\"${default_options} ${listen} ${tls}\"/" /etc/systemd/system/docker.service.d/custom.conf

echo "[Service]
Environment="DOCKER_OPTS=-H=0.0.0.0:2376 ${default_options} -H unix:///var/run/docker.sock ${tls}"" > /etc/systemd/system/docker.service.d/custom.conf

sudo service docker restart