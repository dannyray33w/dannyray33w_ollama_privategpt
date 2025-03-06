#!/bin/bash
# D. Burkhart
GPT_TAG=gpt
MODEL_DIR=models/blobs
NETWORK=gpt_net

if [ ! -d $MODEL_DIR ]; then
  mkdir -p models/blobs
fi

# Ensure gpt container stopped
podman container rm -f $GPT_ID 

# Build 
podman build -t $GPT_TAG -f Containerfile -v $(readlink -f models):/root/.ollama/models  -v $(readlink -f app):/root/app

# Get container image ID
GPT_ID=$(podman images |grep ago |grep $GPT_TAG |awk '{print $3}')

# Run PrivateGPT
podman run -it --rm  \
    --replace \
    --net $NETWORK \
    -p 8001:8001 \
    -p 11434:11434 \
    -v $(readlink -f models):/root/.ollama/models \
    -v $(readlink -f app):/root/app \
    --name gpt $GPT_ID

podman exec -it $GPT_TAG bash
