#!/usr/bin/env bash
set -e

echo "Starting Consul..."
sudo systemctl enable consul.service
sudo systemctl start consul

echo "Starting nomad..."
sudo systemctl enable nomad.service
sudo systemctl start nomad

