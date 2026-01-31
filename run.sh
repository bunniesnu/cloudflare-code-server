#!/bin/bash
c_UID=$(id -u) c_GID=$(id -g) docker compose run --rm init-permissions
c_UID=$(id -u) c_GID=$(id -g) docker compose up -d cloudflared
