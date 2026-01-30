#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y nginx

systemctl enable --now nginx

echo "OK - terraedge app" > /var/www/html/index.html
