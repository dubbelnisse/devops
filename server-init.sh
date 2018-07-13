#!/bin/bash

set -e

update () {
  echo "  -> Update system"

  apt update -y

  return 0
}

install_docker () {
  echo "  -> Install docker"

  apt -y install docker.io

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