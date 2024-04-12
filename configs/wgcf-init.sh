#!/usr/bin/env bash
set -e

if [ ! -e "/etc/wireguard/wg0.conf" ]; then
  if [ ! -e "wgcf-account.toml" ]; then
    wgcf register --accept-tos
  fi

  if [ ! -e "wgcf-profile.conf" ]; then
    wgcf generate
  fi
  
  DEFAULT_GATEWAY_NETWORK_CARD_NAME=`route  | grep default  | awk '{print $8}' | head -1`
  DEFAULT_ROUTE_IP=`ifconfig $DEFAULT_GATEWAY_NETWORK_CARD_NAME | grep "inet " | awk '{print $2}' | sed "s/addr://"`

  sed -i "/\[Interface\]/a PostDown = ip rule delete from $DEFAULT_ROUTE_IP  lookup main" wgcf-profile.conf
  sed -i "/\[Interface\]/a PostUp = ip rule add from $DEFAULT_ROUTE_IP lookup main" wgcf-profile.conf

  if [ "$1" = "-6" ]; then
    sed -i 's/AllowedIPs = 0.0.0.0/#AllowedIPs = 0.0.0.0/' wgcf-profile.conf
  elif [ "$1" = "-4" ]; then
    sed -i 's/AllowedIPs = ::/#AllowedIPs = ::/' wgcf-profile.conf
    sed -i '/^Address = \([0-9a-fA-F]\{1,4\}:\)\{7\}[0-9a-fA-F]\{1,4\}\/[0-9]\{1,3\}/s/^/#/' wgcf-profile.conf
  fi

  cp wgcf-profile.conf /etc/wireguard/wg0.conf
fi
