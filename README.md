# Cloudflare code-server

Hosting code-server through Cloudflare tunnel, automated

## Requirements

* [Cloudflare](https://dash.cloudflare.com) account and domain
* A Linux machine to host code-server (sudo permission)
* Docker installed with [docker-compose-plugin](https://docs.docker.com/compose/install/linux/)

## Usage

1. Run `setup.sh` once. If prompted, enter your domain to host code-server. Follow the instructions shown afterwards. This will setup a tunnel on your Cloudflare account. If you already have a valid tunnel.json, you do not have to run this again.
2. Run `install.sh` to install code-server on your Linux host. This will install and run code-server via systemd. If prompted, follow the instructions. Enter new password for login.
3. Run `run.sh` to start your code-server.

If your tunnel is down, you can always run `run.sh` to restart. If you want to stop it, run `stop.sh`