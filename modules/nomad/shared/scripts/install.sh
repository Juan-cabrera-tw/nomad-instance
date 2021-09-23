#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
if [ -x "$(command -v apt-get)" ]; then
  sudo su -s /bin/bash -c 'sleep 30 && apt-get update && apt-get install unzip' root
else
  sudo yum update -y
  sudo yum install -y unzip wget
fi

echo "Fetching nomad..."
NOMAD=1.0.1
cd /tmp
wget https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_amd64.zip -O nomad.zip --quiet

echo "Fetching Consul..."
CONSUL=1.0.0
cd /tmp
wget https://releases.hashicorp.com/consul/${CONSUL}/consul_${CONSUL}_linux_amd64.zip -O consul.zip --quiet

echo "Installing nomad..."
unzip nomad.zip >/dev/null
chmod +x nomad
sudo mv nomad /usr/local/bin/nomad
sudo mkdir -p /opt/nomad/data

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
sudo mv consul /usr/local/bin/consul
sudo mkdir -p /opt/consul/data

sudo mkdir -p /etc/systemd/system/consul.d

echo "Read from the file we created"
if [ -f /tmp/nomad-server-count ]; then
  SERVER_COUNT=$(cat /tmp/nomad-server-count | tr -d '\n')
else
  CLIENT_COUNT=$(cat /tmp/nomad-client-count | tr -d '\n')
fi

DIR_TO_JOIN=$(cat /tmp/nomad-server-addr | tr -d '\n')
# ACTUAL_DIR=$(cat /tmp/actual-addr | tr -d '\n')
ACTUAL_DIR=$(hostname -I)

echo 'own ip'
echo $ACTUAL_DIR

echo 'Write the flags to a temporary file'
SERVER_FILE=/tmp/nomad-server-count
if [ -f "$SERVER_FILE" ]; then
    echo "$SERVER_FILE exists."
    cat >/tmp/consul_flags << EOF
    CONSUL_FLAGS="-server -bootstrap-expect=1 -join=${DIR_TO_JOIN} -data-dir=/opt/consul/data"
EOF
else 
    echo "$SERVER_FILE does not exist."
    perl -i -pe "s/servers private ips/\"$DIR_TO_JOIN\"/g" /tmp/consul.hcl
    perl -i -pe "s/owm private ip/${ACTUAL_DIR}/g" /tmp/consul.hcl
    sudo mv /tmp/consul.hcl /etc/systemd/system/consul.d/
    cat >/tmp/consul_flags << EOF
    CONSUL_FLAGS="-join=${DIR_TO_JOIN}"
EOF
    echo "installing docker"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    sudo apt-get install docker.io -y

    echo "installing aws cli"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

    echo "installing amazon-ecr-credential-helper"
    sudo apt install amazon-ecr-credential-helper
    sudo chmod +x /usr/bin/docker-credential-ecr-login
    echo "PATH=$PATH:/usr/bin" >> ~/.bashrc
    source ~/.bashrc
    sudo usermod -G docker -a ubuntu
    sudo mv /tmp/docker-auth.json /etc/docker-auth.json
fi

echo "Installing Systemd nomad service..."
sudo mkdir -p /etc/sysconfig
sudo mkdir -p /etc/systemd/system/nomad.d
sudo chown root:root /tmp/nomad.service
sudo mv /tmp/nomad.service /etc/systemd/system/nomad.service
sudo chmod 0644 /etc/systemd/system/nomad.service
sudo mv /tmp/nomad.conf /etc/sysconfig/nomad.conf
sudo mv /tmp/aws.credentials /etc/sysconfig/nomad
sudo chown root:root /etc/sysconfig/nomad.conf
sudo chmod 0644 /etc/sysconfig/nomad.conf

echo "Installing Systemd consul service..."
sudo mkdir -p /etc/sysconfig
sudo chown root:root /tmp/consul.service
sudo mv /tmp/consul.service /etc/systemd/system/consul.service
sudo chmod 0644 /etc/systemd/system/consul.service
sudo mv /tmp/consul_flags /etc/sysconfig/consul
sudo chown root:root /etc/sysconfig/consul
sudo chmod 0644 /etc/sysconfig/consul

