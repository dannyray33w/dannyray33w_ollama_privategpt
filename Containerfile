FROM ubi8

# Ports to expose during RUNTIME
EXPOSE 11434
EXPOSE 8001

#### Ollama ####
# Set Vars
ARG DIR=/root
ARG OLLAMA_URL=https://ollama.com/download/ollama-linux-amd64.tgz
ARG OLLAMA_DEST=ollama-linux-amd64.tgz

# Set working directory for following tasks
WORKDIR ${DIR}  
# Install ollama
RUN curl -L ${OLLAMA_URL} -o ${OLLAMA_DEST} &&\
    tar -C /usr -xzf ${OLLAMA_DEST} &&\
    rm -f ${OLLAMA_DEST}

#### PrivateGPT ####

# Set working directory for following tasks
WORKDIR ${DIR}/app

# Install Python
RUN dnf -y install python3.11 git make &&\
    git clone https://github.com/zylon-ai/private-gpt

# Set working directory for following tasks
WORKDIR ${DIR}/app/private-gpt

# Set container environment variables
ENV PGPT_PROFILES="ollama"
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin
ENV PATH=${PATH}:/bin:${DIR}/.local:${DIR}/.local/bin:${DIR}/.cache/pypoetry/virtualenvs

# Setup python virtual environment
RUN python3.11 -m venv . &&\
    chmod +x bin/activate &&\
    ./bin/activate

# setup poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

# poetry install 
RUN poetry install --extras "ui llms-ollama embeddings-ollama vector-stores-qdrant"

# # Setup entrypoint operations with entrypoint.sh
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "bash", "-c", "/entrypoint.sh" ]