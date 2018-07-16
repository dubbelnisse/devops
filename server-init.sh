#!/bin/bash

set -e

update () {
  echo "  -> Update system"

  apt-get update -y
  apt-get upgrade -y

  return 0
}

install_docker () {
  echo "  -> Install docker"

  apt-get update -y

  apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

  apt-get update -y

  apt-get install docker-ce -y

  return 0
}

update_hostname () {
  echo "  -> Set hostname"

  hostn=$(cat /etc/hostname)
  echo "Existing hostname is $hostn"

  echo "Enter new hostname: "
  read newhost

  sudo sed -i "s/$hostn/$newhost/g" /etc/hosts
  sudo sed -i "s/$hostn/$newhost/g" /etc/hostname
  echo "Your new hostname is $newhost"

  service hostname restart
  service networking restart

  return 0
}

main () {
  update \
    && update_hostname \
    && install_docker \
    && return 0
}

main && echo "done"