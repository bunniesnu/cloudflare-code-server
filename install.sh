#!/bin/bash
set -e
SERVICE="code-server"
if ! command -v code-server >/dev/null 2>&1; then
	echo "code-server not found. Installing..."
	curl -fsSL https://code-server.dev/install.sh | sh
fi
sudo systemctl enable $SERVICE@$USER
read -s -p "Enter new password for code-server: " PASSWORD
echo
read -s -p "Confirm password: " PASSWORD2
echo
if [[ "$PASSWORD" != "$PASSWORD2" ]]; then
	echo "Passwords do not match."
	exit 1
fi
if ! command -v argon2 >/dev/null 2>&1; then
	echo "argon2 not found. Installing..."

	if command -v apt >/dev/null 2>&1; then
		sudo apt update
		sudo apt install -y argon2
	elif command -v dnf >/dev/null 2>&1; then
		sudo dnf install -y argon2
	elif command -v yum >/dev/null 2>&1; then
		sudo yum install -y argon2
	elif command -v pacman >/dev/null 2>&1; then
		sudo pacman -Sy --noconfirm argon2
	else
		echo "Unsupported package manager. Install argon2 manually."
		exit 1
	fi
fi
HASH=$(echo -n "$PASSWORD" | argon2 "$(openssl rand -hex 16)" -id -e)
if [[ -z "$HASH" ]]; then
	echo "Failed to generate hash."
	exit 1
fi
CONFIG="$HOME/.config/code-server/config.yaml"
mkdir -p "$(dirname "$CONFIG")"
if [ -f "$CONFIG" ]; then
	BACKUP="$CONFIG.bak.$(date +%F_%H%M%S)"
	cp "$CONFIG" "$BACKUP"
	echo "Backup created: $BACKUP"
else
	touch "$CONFIG"
fi
sed -i '/^password:/d' "$CONFIG"
sed -i '/^hashed-password:/d' "$CONFIG"
sed -i '/^auth:/d' "$CONFIG"
{
    echo "auth: password"
    echo "hashed-password: $HASH"
} >> "$CONFIG"
