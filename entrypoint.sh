#!/bin/bash

# Desired models
LLM="llama3.2:3b"
EMBED="nomic-embed-text"
# Check for desired models
LLM_CHECK="$(ollama ls |grep $LLM |awk '{print $1}')"
EMBED_CHECK="$(ollama ls |grep $EMBED|awk '{print $1}')"

# Start private gpt services
ollama serve &
sleep 3

# Pull LLM model if not already done
if [ "$LLM_CHECK" != "$LLM" ]; then
  ollama pull $LLM
fi

if [ "$EMBED_CHECK" != "$EMBED" ]; then
  ollama pull $EMBED
fi

# Run privategpt
set PGPT_PROFILES=ollama
make run

sleep infinity