FROM --platform=linux/amd64 debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    passwd \
    python3 \
    python3-pip \
    python3-venv \
    sudo \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g npm@latest

RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip

RUN useradd -ms /bin/bash node \
    && chsh -s /bin/bash node \
    && echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER node
ENV HOME=/home/node
WORKDIR /home/node

ENV PATH="/opt/venv/bin:/home/node/.local/bin:$PATH"

RUN curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash

ENV PATH="/home/node/.rokit/bin:$PATH"

WORKDIR /workspace
COPY --chown=node:node package*.json ./
RUN npm install --legacy-peer-deps

COPY --chown=node:node rokit.toml ./
RUN rokit install --no-trust-check

COPY --chown=node:node . .
RUN find scripts/shell -name "*.sh" -type f -exec chmod +x {} \; || true

ENV PATH="/home/node/.rokit/bin:/workspace/node_modules/.bin:/opt/venv/bin:/home/node/.local/bin:$PATH"
ENV NODE_ENV=development

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node --version && npm --version || exit 1

ENTRYPOINT ["/workspace/scripts/shell/docker-entrypoint.sh"]
CMD ["bash"]