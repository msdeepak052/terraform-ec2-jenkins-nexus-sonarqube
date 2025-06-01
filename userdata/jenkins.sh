#!/bin/bash

# Exit immediately if any command fails
set -e

# set -euxo pipefail   #The set -euxo pipefail in scripts helps catch such issues early
# # Install Jenkins
# sudo yum update -y
# sudo yum install wget unzip -y

# # Install Java 21 (for RHEL 10)
# sudo dnf install -y java-21-openjdk-devel

# # Configure alternatives if needed
# sudo alternatives --set java /usr/lib/jvm/java-21-openjdk-*/bin/java
# sudo alternatives --set javac /usr/lib/jvm/java-21-openjdk-*/bin/javac

# sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
# # sudo yum install jenkins java-11-openjdk-devel -y
# sudo systemctl daemon-reload
# sudo systemctl start jenkins
# sudo systemctl enable jenkins

# # Install Docker
# sudo yum install docker.io -y
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo usermod -aG docker jenkins
# sudo usermod -aG docker ec2-user

# # Install other tools
# sudo yum install -y git maven

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