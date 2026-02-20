#!/bin/bash
sudo systemctl start code-server@$USER
docker compose -f "$(dirname "$0")/docker-compose.yml" up -d
