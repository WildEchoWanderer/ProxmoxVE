#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/${GITHUB_USER:-community-scripts}/ProxmoxVE/${GITHUB_BRANCH:-main}/misc/build.func)

# Copyright (c) 2021-2026 community-scripts ORG
# Author: Du
# License: MIT

function header_info {
  clear
  cat <<"EOF"
FileBrowser Quantum
EOF
}

header_info
echo -e "Loading..."
APP="FileBrowser Quantum"
var_disk="4"
var_cpu="1"
var_ram="1024"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  valid_mac=""
  valid_hwaddr=""
  default_mac_address=""
  hwaddr=""
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} is reachable by going to the following URL."
echo -e "         http://${IP}:8080 \n"
