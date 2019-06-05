# docker-gcsfuse

This is an attemp to create an Alpine-based image for the [Google's](https://github.com/GoogleCloudPlatform) [gcsfuse](https://github.com/GoogleCloudPlatform/gcsfuse).

## Instructions

### Before begin

* Get your [Service Account Key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys) for your bucket, and upload to gcsfuse-key.json. (if you're running the VM at Google Cloud, the key can be reteived as custom metadata, see bellow).

* Don't forget to set the right permissions for your bucket.

* If you're running the VM at Google Cloud,

  * You must configure your [Service account](https://cloud.google.com/compute/docs/access/service-accounts) accordingly.

  * You **should** enable [OS Login](https://cloud.google.com/compute/docs/instances/managing-instance-access#enable_oslogin) and choose the proper Service account.
 
  * *User ID*, *Gruop ID*, *Username* and *Home* directory belongs to the **OS Login** account (that are the same for every instance under the same Service account). `scripts/startup-gcloud.sh` provides those environment variables.
  
  * Provide the contents from ``scripts/startup-gcloud.sh`` as startup script.
  
  * Save your Service Account key as a custom metadata named `GCSKEY`
  
### Running:
  
#### Command line
```
CONTAINER_NAME="gcsfuse"
CONTAINER_IMAGE="amitie10g/gcsfuse"
TZ="UTC"
PUID=<User ID>
PGID=<Group ID>

docker run -t -i -d \
  --name="$CONTAINER_NAME" \
  -e PUID="$PUID" \
  -e PGID="$PGID" \
  -e TZ="$TZ" \
  -e BUCKET="$BUCKET" \
  -v "$LOCAL_HOME/gcs-key.json":/etc/gcs-key.json \
  --device=/dev/fuse \
  --restart no \
  --privileged \
  $CONTAINER_IMAGE
```

#### docker-compose style
```
version: "3.3"
services:
  gcsfuse:
    image: amitie10g/gcsfuse
    container_name: gcsfuse
    environment:
      - PUID=<PUID>
      - PGID=<PGID>
      - BUCKET=<BUCKET>
      - TZ=UTC
    volumes:
      - <path to gcs-key.json>:/etc/gcs-key.json
    restart: no
```
