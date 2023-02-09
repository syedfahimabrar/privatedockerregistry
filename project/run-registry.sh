#!/bin/sh
if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi
# Generate self-signed certificate
openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt -subj "/CN=docker-registry" -addext "subjectAltName = IP:$IP"

# Start Docker registry
docker-compose up -d

# Create firewall rule to allow incoming traffic to the Docker registry
sudo ufw allow from any to any port ${REGISTRY_PORT} proto tcp

