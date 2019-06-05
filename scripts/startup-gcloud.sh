#!/bin/bash

# Local Environment variables
PUID=$(curl -fSs "http://metadata.google.internal/computeMetadata/v1/oslogin/users?pagesize=1" -H "Metadata-Flavor: Google" | python -c "import sys, json; print(json.load(sys.stdin)['loginProfiles'][0]['posixAccounts'][0]['uid'])")
PGID=$(curl -fSs "http://metadata.google.internal/computeMetadata/v1/oslogin/users?pagesize=1" -H "Metadata-Flavor: Google" | python -c "import sys, json; print(json.load(sys.stdin)['loginProfiles'][0]['posixAccounts'][0]['gid'])")
LOCAL_HOME=$(curl -fSs "http://metadata.google.internal/computeMetadata/v1/oslogin/users?pagesize=1" -H "Metadata-Flavor: Google" | python -c "import sys, json; print(json.load(sys.stdin)['loginProfiles'][0]['posixAccounts'][0]['homeDirectory'])")

mkdir -p $LOCAL_HOME
chown $PUID:$PGID $LOCAL_HOME

# Download the Account service key from custom metadata
curl -fSs "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCSKEY" \
-H "Metadata-Flavor: Google" -o "$LOCAL_HOME/gcs-key.json"

# Check if the Service account key has been found
if [ -f "$LOCAL_HOME/gcs-key.json" ]; then
	chown "$PUID:$PGID" "$LOCAL_HOME/gcs-key.json"
else
	ERROR="Please set the custom metadata GCSKEY with your Service account key, or upload it to $LOCAL_HOME/gcs-key.json."
	echo "$ERROR" >&2
fi
