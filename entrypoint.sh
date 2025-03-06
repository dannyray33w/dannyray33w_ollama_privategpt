#!/bin/bash

# Start private gpt services

ollama serve &

sleep 7

set PGPT_PROFILES=ollama
make run

sleep infinity