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
  sed -i "s/^HOST.*/HOSTNAME=$user_input_hostname/" /etc/sysconfig/network

  return 0
}

set_timezone () {
  echo "  -> Set Timezone Stockholm"
  mv /etc/localtime /etc/localtime.bak
  ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
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