#!/bin/bash
set -e  # exit on error

#DOMAIN="Fill in with your tailscale domain name the uncomment"
CERT_DIR="/etc/ssl/tailscale"
RESOLV_BACKUP="/tmp/resolv.conf.backup"

# Disable MagicDNS
sudo tailscale set --accept-dns=false

# Backup resolv.conf
sudo cp /etc/resolv.conf "$RESOLV_BACKUP"

# Set DNS to Google temporarily
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

# Create new cert
sudo tailscale cert "$DOMAIN"

# Copy to destination
sudo cp ~/"$DOMAIN".{crt,key} "$CERT_DIR"

# Restart nginx
sudo systemctl restart nginx
sudo systemctl restart gunicorn

# Restore DNS settings
sudo cp "$RESOLV_BACKUP" /etc/resolv.conf
sudo tailscale set --accept-dns=true

echo "✅ SSL certificate for $DOMAIN renewed and installed."


