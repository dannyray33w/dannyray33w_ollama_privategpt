#!/bin/bash
# D. Burkhart
TAG=gpt
MODEL_DIR=models/blobs
NETWORK=gpt_net
APP_DIRS="app models images"
CONTAINER_TARBALL="./images/$TAG.tar"

# Prompt to remove old data
read -p "Purge old app data? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    for i in $APP_DIRS; do rm -Rfv $i/* ;done
    podman image rm --force $TAG
fi

for dir in models/blobs images app
do
  if [ ! -d $dir ]; then
    mkdir -p $dir
  fi
done

# Ensure gpt container stopped
podman container rm -f $TAG 

# Build 
podman build -t $TAG -f Containerfile \
  -v $(readlink -f models):/root/.ollama/models \
  -v $(readlink -f app):/root/app

# Get container image ID
CONTAINER_ID=$(podman images |grep ago |grep $TAG |awk '{print $3}')  

if [ ! -e $CONTAINER_TARBALL ]
then
    rm -fv $CONTAINER_TARBALL && podman save -o $CONTAINER_TARBALL $CONTAINER_ID
else
    podman save -o $CONTAINER_TARBALL $CONTAINER_ID
fi
exit 0
