#!/bin/bash

# Exit immediately if any command fails
set -e


sudo apt update -y
sudo apt install wget -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt install openjdk-17-jdk -y
sudo apt-get install jenkins -y

# ---------------------------------------------------------------------------------
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins


# Install Docker

sudo apt install docker.io -y
# sudo chmod 777 /var/run/docker.sock

# Create dedicated docker user (optional)
if ! id "dockeruser" &>/dev/null; then
  sudo useradd -m -s /bin/bash dockeruser
  echo "Created 'dockeruser' account"
fi

# Add users to docker group
sudo groupadd docker 2>/dev/null || true  # Ignore if group exists
for user in "$USER" jenkins dockeruser; do
  if id "$user" &>/dev/null; then
    sudo usermod -aG docker "$user"
    echo "Added $user to docker group"
  fi
done


# Git and maven install

sudo apt install git maven -y

# Verify installations

echo "=== INSTALLATION VERIFICATION ==="
docker --version
java --version
mvn --version
git --version


# Get Jenkins initial admin password
echo "=== JENKINS SETUP ==="
echo "Initial admin password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 2>/dev/null || echo "Could not find Jenkins password"

echo "All packages installed successfully!"
echo "NOTE: Log out and back in for Docker group changes to take effect."
