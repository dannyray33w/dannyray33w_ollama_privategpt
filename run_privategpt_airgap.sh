#!/bin/bash

# Variables
TAG="gpt"
MODEL_DIR="models/blobs"
NETWORK="gpt_net"
CONTAINER_NAME="gpt"
CONTAINER_TARBALL="./images/gpt.tar"
GPT_PORT="8001"
OLLAMA_PORT="11434"

# Ensure podman network exists
NET_CHECK="$(podman network ls |grep gpt_net |awk '{print $2}')"
if [ "$NET_CHECK" != "$NETWORK" ]
then
    podman network create -d bridge $NETWORK
fi

# Load container image
podman load -i $CONTAINER_TARBALL

# Tag imported container image
ID="$(podman images |grep ago |grep none |awk '{print $3}')"
podman tag $ID $TAG

# Get container image ID
CONTAINER_ID=$(podman images |grep ago |grep $TAG |awk '{print $3}')

# Run PrivateGPT
podman run -itd --rm  \
    --replace \
    --net $NETWORK \
    -p $GPT_PORT:8001 \
    -p $OLLAMA_PORT:11434 \
    -v $(readlink -f models):/root/.ollama/models \
    -v $(readlink -f app):/root/app \
    --name gpt $CONTAINER_ID