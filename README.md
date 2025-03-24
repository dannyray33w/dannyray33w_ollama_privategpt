This project is designed to allow for the creation of a simple ollama / private-gpt container to be 
built and shipped to an airgapped network.

The container is designed to bind persistent volumes for private-gpt and ollama models.

# Selecting LLMs
LLMs will be pulled during the build process and can be defined in nested_ollama_setup.sh:

	# Define LLMS to pull ADD desired LLMs in side array (example 'llm' )
	declare -a LLMS=( 'llama3.1' 'nomic-embed-text' )

A tarball of the container image will be saved to the build directory for simple migration to airgap network.

# Getting started:

	- Clone this project

	- cd into project

	- ./build.sh

	- ./run_privategpt_airgap.sh (15 second delay normal for webui to ensure all services start).

# Notes

	- Ensure port 8001 is open (optionally open 11434 for ollama API access).	
	- Adjust run_privategpt_airgap.sh 'podman run' command for GPU passthrough as applicable.	
 

