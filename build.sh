#!/bin/bash
OLLAMA_TAG=myollama
GPT_TAG=gpt
MODEL_DIR=models/blobs
NETWORK=gpt_net


if [ ! -d $MODEL_DIR ]; then
  mkdir -p models/blobs
fi

# Ensure ollama container stopped
podman stop $OLLAMA_TAG

# Built ollama container
podman build -t $OLLAMA_TAG -f Containerfile.ollama . 

# Get container image ID
OLLAMA_ID=$(podman images |grep ago |grep $OLLAMA_TAG |awk '{print $3}')

# Run ollama
podman run -itd --rm  \
    --net $NETWORK \
    -p 11434:11434 \
    -v ./models:/root/.ollama/models:Z \
    --name $OLLAMA_TAG $OLLAMA_ID

# Ensure gpt container stopped
podman container rm -f $GPT_ID 

# Build 
podman build -t $GPT_TAG -f Containerfile.privategpt

# Get container image ID
GPT_ID=$(podman images |grep ago |grep $GPT_TAG |awk '{print $3}')

# Run PrivateGPT
podman run -itd --rm  \
    --replace \
    --net $NETWORK \
    -p 8001:8001 \
    --name $GPT_TAG $GPT_ID bash

podman exec -it $GPT_TAG bash
