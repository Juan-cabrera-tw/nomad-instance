#!/usr/bin/env bash
set -e

echo "Starting fabio..."
SERVER_FILE=/tmp/nomad-server-count
if [ -f "$SERVER_FILE" ]; then
nomad job run /tmp/fabio.nomad
fi
