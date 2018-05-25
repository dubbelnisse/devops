#!/bin/bash

h=`hostname`
internal=$(echo "IP:$(cat /etc/hosts|grep "${h}"|awk '{print $1}'),")
external=$([[ $h != *work* ]] && echo "IP:$(curl -s ifconfig.co)," || echo "")

main () {
  if [ ! -f ca.crt ]; then
    echo "missing ca.crt"
    return 1
  fi

  if [ ! -f ca.key ]; then
    echo "missing ca.key"
    return 1
  fi

  if [ ! -f "${h}.key" ]; then
    openssl genrsa -out ${h}.key 4096
  fi

  openssl req -subj "/CN=${h}" -new -key ${h}.key -out /tmp/${h}.srl

  echo "subjectAltName = ${internal} ${external} IP:127.0.0.1" > /tmp/extfile.cnf

  openssl x509 -req -days 1095 -in /tmp/${h}.srl -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out ${h}.crt -extfile /tmp/extfile.cnf

  rm /tmp/{extfile.cnf,${h}.srl}

  return 0
}

main && echo "done"