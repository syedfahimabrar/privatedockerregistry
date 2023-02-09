#!/bin/sh
#!/bin/bash

# Check if Docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo 'Docker is not installed. Installing...'

  # Update the apt package index and install Docker
  sudo apt-get update
  sudo apt-get install -y docker.io

  # Start the Docker service
  sudo systemctl start docker
  sudo systemctl enable docker
else
  echo 'Docker is already installed.'
fi

# Check if Docker Compose is installed
if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Docker Compose is not installed. Installing...'

  # Download the Docker Compose binary
  sudo curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

  # Set the permissions for the Docker Compose binary
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo 'Docker Compose is already installed.'
fi

# Add the current user to the Docker group
sudo usermod -aG docker $USER

# Create the Docker Compose group if it doesn't exist
if ! grep -q "^docker-compose:" /etc/group; then
  sudo groupadd docker-compose
fi

# Add the current user to the Docker Compose group
sudo usermod -aG docker-compose $USER

#check if any env available then load it
if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi
# Generate self-signed certificate
ip=$(curl ifconfig.me)
sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.key -x509 -days 365 -out registry.crt -subj "/CN=docker-registry" -addext "subjectAltName = IP:$ip"

# Start Docker registry
sudo docker-compose up -d

# Create firewall rule to allow incoming traffic to the Docker registry
sudo ufw allow from any to any port ${REGISTRY_PORT} proto tcp

