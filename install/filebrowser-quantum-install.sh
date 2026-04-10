#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts ORG
# Author: Community
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://github.com/filebrowserspace/quantum

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
# Installieren von FFmpeg und curl gemäß den Linux-Installationsanweisungen 
$STD apt-get install -y curl ffmpeg sudo
msg_ok "Installed Dependencies"

msg_info "Installing FileBrowser Quantum"
# Herunterladen des amd64-Binaries und ausführbar machen 
curl -fsSL https://github.com/gtsteffaniak/filebrowser/releases/latest/download/linux-amd64-filebrowser -o /usr/local/bin/filebrowser
chmod +x /usr/local/bin/filebrowser

# Erstellen des System-Benutzers und der Verzeichnisse 
useradd -r -s /bin/false filebrowser
mkdir -p /opt/filebrowser/data
chown -R filebrowser:filebrowser /opt/filebrowser

# Erstellen der config.yaml im Arbeitsverzeichnis 
cat <<EOF >/opt/filebrowser/config.yaml
server:
  port: 8080
  sources:
    - path: "/opt/filebrowser/data" # Angepasster Pfad, da Root "/" vermieden werden soll 
      config:
        defaultEnabled: true
auth:
  adminUsername: admin
EOF
chown filebrowser:filebrowser /opt/filebrowser/config.yaml
msg_ok "Installed FileBrowser Quantum"

msg_info "Creating and Starting Systemd Service"
# Systemd-Service-Datei anlegen 
cat <<EOF >/etc/systemd/system/filebrowser.service
[Unit]
Description=FileBrowser Quantum
After=network.target

[Service]
Type=simple
User=filebrowser
WorkingDirectory=/opt/filebrowser
ExecStart=/usr/local/bin/filebrowser -c /opt/filebrowser/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Daemon neu laden, Service aktivieren und starten 
systemctl daemon-reload
systemctl enable -q --now filebrowser.service
msg_ok "Systemd Service created and FileBrowser started"

motd_ssh
customize
cleanup_lxc
