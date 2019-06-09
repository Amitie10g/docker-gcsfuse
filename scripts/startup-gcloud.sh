#!/bin/bash

# Local Environment variables
HOME=/mnt/disks/qbittorrent
CONF_PATH="$HOME/config"
PUID="1000"
PGID="1000"

# Create the directories
mkdir -p "$CONF_PATH"

# Download the Service account key from custom metadata
curl -fSs "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCS_KEY" \
-H "Metadata-Flavor: Google" -o "$CONF_PATH/gcs-key.json"

chown -R "$PUID:PGID" "$HOME"
chmod -R 700 $CONF_PATH
