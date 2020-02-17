# Docker swarm setup
This repo contains setup instructions and scripts to setup a docker swarm environment on Ubuntu server.

## Configure a new server

```sh
wget "https://raw.githubusercontent.com/dubbelnisse/docker-swarm-setup/master/server-init.sh" -O server-init.sh && chmod +x server-init.sh && sudo ./server-init.sh && rm server-init.sh
```

Then reboot system
```sh
reboot
```

## Docker cert setup

### First server
Generate key:
```sh
openssl genrsa -aes256 -out ca.key 4096
```
Generate cert:
```sh
openssl req -new -x509 -days 1095 -key ca.key -sha256 -out ca.crt
```

### For all servers
In order to run this script you need to copy the root cert and key to the directory where you will run this script.

Generate key and cert for docker host:
```sh
wget "https://raw.githubusercontent.com/dubbelnisse/docker-swarm-setup/master/cert.sh" -O cert.sh && chmod +x cert.sh && ./cert.sh "manager-01"
```

Move cert adn key files:
```sh
sudo bash -c "mkdir -p /var/lib/docker/certs && mv /root/{ca,manager}* /var/lib/docker/certs/ && chmod 770 /var/lib/docker/certs/ && rm ca.key ca.srl -f"
```

Update docker setup to use cert:
```sh
wget "https://raw.githubusercontent.com/dubbelnisse/docker-swarm-setup/master/docker-certs.sh" -O cert.sh && chmod +x cert.sh && ./cert.sh "manager-01"
```

## Docker swarm
Create new swarm
```sh
docker swarm init --advertise-addr <host>
```

Join swarm
```sh
docker swarm join --token <token> <host>:2377
```

Forgot token?
```sh
docker swarm join-token <manager/worker>
```

## Setup to access Swarm

### Create personal docker certificate
Create cert on local machine:

Get key and cert from lastpass and:

Note: Diffrent keys for test and prod.

1. Create file caKey.pem (root key, ca.key)
2. Create file ca.pem (root cert, ca.crt)

Then you run the following commands:
```sh
1. openssl genrsa -out key.pem 4096

2. openssl req -subj '/CN=client-YOURNAME' -new -key key.pem -out client.csr

3. echo extendedKeyUsage = clientAuth >extfile.cnf

4. openssl x509 -req -days 365 -in client.csr -CA ca.pem -CAkey caKey.pem -CAcreateserial -out cert.pem -extfile extfile.cnf

5. rm ca.srl caKey.pem client.csr extfile.cnf
```

### Connect to server:
```sh
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=PATH_TO_WHERE_CERT_IS
export DOCKER_HOST=tcp://<ip>:2376
```
