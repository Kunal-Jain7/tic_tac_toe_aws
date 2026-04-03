#!/bin/bash

# Script to install required tools on Ubuntu for running the Jenkins pipeline and Helm deployment
# Run as root or with sudo

set -e

echo "Updating system packages..."
apt update && apt upgrade -y

echo "Installing Docker..."
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io
systemctl start docker
systemctl enable docker
usermod -aG docker $USER

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

echo "Installing Helm..."
curl https://baltocdn.com/helm/signing.asc | apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list
apt update
apt install -y helm

echo "Installing Jenkins (optional, if running Jenkins on this VM)..."
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
echo "deb https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list
apt update
apt install -y openjdk-11-jdk jenkins
systemctl start jenkins
systemctl enable jenkins

echo "Installing other utilities..."
apt install -y curl wget git vim

echo "Installation complete. Reboot or logout/login for docker group changes."
echo "Jenkins initial password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
