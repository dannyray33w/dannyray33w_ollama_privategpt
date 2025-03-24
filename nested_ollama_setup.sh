#!/bin/bash

# Define LLMS to pull ADD desired LLMs in side array (example 'llm' )
declare -a LLMS=( 'llama3.1' 'nomic-embed-text' )

# Variables
OLLAMA_URL=https://ollama.com/download/ollama-linux-amd64.tgz
OLLAMA_DEST=ollama-linux-amd64.tgz

# Use curl to pull ollama tarball, extract to /usr, and purge tarball.
curl -L $OLLAMA_URL -o $OLLAMA_DEST
tar -C /usr -xzf $OLLAMA_DEST 
rm -f $OLLAMA_DEST 

# Start ollama 
ollama serve &
sleep 5

# Pull each large language model listed in array LLMS
for llm in "${LLMS[@]}"
do
  echo -e "\n *** Pulling $llm ***\n"
  ollama pull $llm
done