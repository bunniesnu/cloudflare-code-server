#!/bin/bash
docker compose -f "$(dirname "$0")/docker-compose.yml" down
sudo systemctl stop code-server@$USER
