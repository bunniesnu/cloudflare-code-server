#!/bin/bash
set -e
cd "$(dirname "$0")" || exit 1
mkdir -p ./cf-admin
sudo chown 65532:65532 ./cf-admin
read -p "Enter domain to host: " DOMAIN
sed "s|code.example.com|$DOMAIN|g" config_orig.yml > config.yml
docker run --rm -it -v ./cf-admin:/home/nonroot/.cloudflared cloudflare/cloudflared:latest tunnel login
docker run --rm -it -v ./cf-admin:/home/nonroot/.cloudflared cloudflare/cloudflared:latest tunnel create code-server
docker run --rm -it -v ./cf-admin:/home/nonroot/.cloudflared cloudflare/cloudflared:latest tunnel route dns code-server $DOMAIN
sudo mv $(find ./cf-admin -type f -name "*.json") ./tunnel.json
sudo rm -r ./cf-admin
