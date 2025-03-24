#!/bin/bash
# D. Burkhart
TAG=gpt
MODEL_DIR=models/blobs
NETWORK=gpt_net
APP_DIRS="app/private-gpt models"
CONTAINER_TARBALL="./images/$TAG.tar"

# Prompt to remove old data
for i in $APP_DIRS
do 
    if [ -d $i ]
    then
      read -p "Remove old data from $i? (y/n): " CHOICE
      if [ "$CHOICE" = "y" ] 
      then
        rm -Rfv $i
      fi
    fi  
done

for dir in models/blobs images app
do
  if [ ! -d $dir ]; then
    mkdir -p $dir
  fi
done

# Build 
podman build -t $TAG -f Containerfile \
  -v $(readlink -f models):/root/.ollama/models \
  -v $(readlink -f app):/root/app

# Get container image ID
CONTAINER_ID=$(podman images |grep ago |grep $TAG |awk '{print $3}')  

if [ -e $CONTAINER_TARBALL ]
then
    rm -fv $CONTAINER_TARBALL && podman save -o $CONTAINER_TARBALL $CONTAINER_ID
else
    podman save -o $CONTAINER_TARBALL $CONTAINER_ID
fi
exit 0
