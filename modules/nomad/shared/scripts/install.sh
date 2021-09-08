#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
if [ -x "$(command -v apt-get)" ]; then
  sudo su -s /bin/bash -c 'sleep 30 && apt-get update && apt-get install unzip' root
fi

echo "Fetching nomad..."
NOMAD=1.0.1
cd /tmp
wget https://releases.hashicorp.com/nomad/${NOMAD}/nomad_${NOMAD}_linux_amd64.zip -O nomad.zip --quiet

echo "Installing nomad..."
unzip nomad.zip >/dev/null
chmod +x nomad
sudo mv nomad /usr/local/bin/nomad
sudo mkdir -p /opt/nomad/data

echo "Read from the file we created"
SERVER_COUNT=$(cat /tmp/nomad-server-count | tr -d '\n')
NOMAD_JOIN=$(cat /tmp/nomad-server-addr | tr -d '\n')

echo 'Write the flags to a temporary file'
cat >/tmp/nomad_flags << EOF
NOMAD_FLAGS="-server -bootstrap-expect=${SERVER_COUNT} -join=${NOMAD_JOIN} -data-dir=/opt/nomad/data"
EOF

echo "Installing Systemd service..."
sudo mkdir -p /etc/sysconfig
sudo mkdir -p /etc/systemd/system/nomad.d
sudo chown root:root /tmp/nomad.service
sudo mv /tmp/nomad.service /etc/systemd/system/nomad.service
sudo mv /tmp/nomad*json /etc/systemd/system/nomad.d/ || echo
sudo chmod 0644 /etc/systemd/system/nomad.service
sudo mv /tmp/nomad_flags /etc/sysconfig/nomad
sudo chown root:root /etc/sysconfig/nomad
sudo chmod 0644 /etc/sysconfig/nomad

