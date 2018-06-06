# devops

## Setup to access Swarm

### Create personal docker certificate
Create cert on local machine:

Get key and cert from lastpass and:

Note: Diffrent keys for test and prod.

1. Create file caKey.pem (called docker cert key in lastpass)
2. Create file ca.pem (called docker cert in lastpass)

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
export DOCKER_HOST=tcp://<ip>:<port>
```

## Connect to service

Setup tunnel to a service
```sh
ssh -L 8080:localhost:8080 <alias-to-ssh-config>
```

## Configure a new server

```sh
wget "https://raw.githubusercontent.com/dubbelnisse/devops/master/server-init.sh?token=ADFVniD-O5coHtrKY2mC-THOcwXNqiusks5bGmeGwA%3D%3D" -O server-init.sh && chmod +x server-init.sh && sudo ./server-init.sh && rm server-init.sh
```

## For a new enviroment
Generate key:
```sh
openssl genrsa -aes256 -out ca.key 4096
```
Generate cert:
```sh
openssl req -new -x509 -days 1095 -key ca.key -sha256 -out ca.crt
```

Generate key for docker host:
```sh
wget "https://raw.githubusercontent.com/dubbelnisse/devops/master/cert.sh?token=ADFVnlXPaaO0_6KdkdftWGGYhlAh67TDks5bGnYYwA%3D%3D" -O cert.sh && chmod +x cert.sh && ./cert.sh "manager-01"
```

Cert them up:
```sh
sudo bash -c "mkdir -p /var/lib/docker/certs && mv /root/{ca,manager}* /var/lib/docker/certs/ && chmod 770 /var/lib/docker/certs/ && rm ca.key ca.srl -f"
```

Update docker setup:

```sh
wget "https://raw.githubusercontent.com/dubbelnisse/devops/master/dockerd-certs.sh?token=ADFVnlfmzd3gbXr7S0hLB8rjvIlhP8rUks5bGnadwA%3D%3D" -O cert.sh && chmod +x cert.sh && ./cert.sh "manager-01"
```

## init swarm
docker swarm init

dockerd --tlsverify --tlscacert=ca.crt --tlscert=manager-01.crt --tlskey=manager-01.key \
  -H=0.0.0.0:2376