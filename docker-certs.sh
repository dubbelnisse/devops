#!/bin/bash

h=${1}
default="\/usr\/bin\/dockerd -H fd:\/\/"
host="-H tcp:\/\/0.0.0.0:2376"
cert_location="\/var\/lib\/docker\/certs\/"
tls="--tlsverify --tlscacert=${cert_location}ca.crt --tlscert=${cert_location}${h}.crt --tlskey=${cert_location}${h}.key"

sudo sed -i "s/^ExecStart=.*/ExecStart=${default} ${host} ${tls}/" /lib/systemd/system/docker.service

sudo systemctl daemon-reload
sudo systemctl restart docker
