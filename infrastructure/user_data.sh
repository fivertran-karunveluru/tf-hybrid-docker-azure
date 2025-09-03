#!/bin/bash

# Update system packages
apt-get update -y
apt-get upgrade -y

# Install required packages
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    unzip \
    jq

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Create fivetran user
useradd -m -s /bin/bash -G sudo,docker fivetran

# Install Fivetran Agent
cd /home/fivetran
sudo -u fivetran TOKEN="${agent_token}" RUNTIME=docker bash -c "$(curl -sL https://raw.githubusercontent.com/fivetran/hybrid_deployment/main/install.sh)"

# Set proper permissions
chown -R fivetran:fivetran /home/fivetran

# Create log directory
mkdir -p /var/log/fivetran
chown fivetran:fivetran /var/log/fivetran

echo "Fivetran Agent installation completed successfully!"
