FROM --platform=linux/amd64 debian:trixie-slim

# Install system dependencies including Node.js
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
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && node --version \
    && npm --version

# Ensure Node.js is in system PATH
RUN ln -sf /usr/bin/node /usr/local/bin/node \
    && ln -sf /usr/bin/npm /usr/local/bin/npm

# Create Python virtual environment
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip

# Create user and set permissions
RUN useradd -ms /bin/bash node \
    && chsh -s /bin/bash node \
    && echo "node ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to node user
USER node
ENV HOME=/home/node
WORKDIR /home/node

# Set up environment paths
ENV PATH="/opt/venv/bin:/home/node/.local/bin:$PATH"

# Install rokit
RUN curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash

# Add rokit to PATH
ENV PATH="/home/node/.rokit/bin:$PATH"

# Set up workspace
WORKDIR /workspace
COPY --chown=node:node package*.json ./
RUN npm ci --only=production=false

COPY --chown=node:node rokit.toml ./
RUN rokit install --no-trust-check

COPY --chown=node:node . .
RUN find scripts/shell -name "*.sh" -type f -exec chmod +x {} \; || true

# Final environment setup
ENV PATH="/home/node/.rokit/bin:/workspace/node_modules/.bin:/opt/venv/bin:/home/node/.local/bin:$PATH"
ENV NODE_ENV=development

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD node --version && npm --version || exit 1

# For devcontainer, we'll let VS Code manage the container lifecycle
# ENTRYPOINT ["/workspace/scripts/shell/docker-entrypoint.sh"]
CMD ["bash"]
