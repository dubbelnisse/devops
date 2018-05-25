#!/bin/bash

set -e

user_input_hostname=""

get_user_input () {
  echo
  echo "  -> Set HOSTNAME "
  echo
  while :; do
    read -p "" input
    [[ "$input" != "" ]] && break
  done

  user_input_hostname=$input

  return 0
}

update () {
  set +e
  apt update -y
  set -e

  return 0
}

update_hostname () {
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

set_timezone () {
  echo "  -> Set Timezone Sweden"
  mv /etc/localtime /usr/share/zoneinfo/Etc/
  ln -s /usr/share/zoneinfo/Etc/GMT+2 /etc/localtime
  return 0
}

main () {
  get_user_input \
    && update \
    && update_hostname \
    && set_timezone \
    && return 0
}

main && echo "done"