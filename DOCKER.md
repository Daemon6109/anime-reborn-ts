# Docker Setup for Roblox TypeScript Project

This document explains how to use Docker for development with this Roblox TypeScript project, focusing on the primary development environment managed by `docker-compose.yml`.

## Prerequisites

- Docker Desktop installed and running.
- Docker Compose (typically included with Docker Desktop).
    - Supports both Docker Compose V1 (`docker-compose`) and V2 (`docker compose`)
    - All npm scripts automatically fallback between versions
- A `.env` file created at the root of the repository by copying `.env.example` and filling in the required values.

## Quick Start

### 1. Build the Docker Image (Optional)

The development environment will build images automatically when started if they don't exist. However, you can explicitly build them:

```bash
npm run docker:build
```

This command refers to the services defined in `docker-compose.yml`.

### 2. Start Development Environment

```bash
npm run docker:dev
```

This starts the `roblox-ts-dev` container in the background with your project code mounted as a volume. This is the primary container for development.

### 3. Access the Development Shell

```bash
npm run docker:shell
```

This opens a bash shell inside the running `roblox-ts-dev` container.

## Available Docker Commands (using `docker-compose.yml`)

The following `npm` scripts interact with the Docker environment defined in `docker-compose.yml`:

| Command                        | Description                                                                    |
| ------------------------------ | ------------------------------------------------------------------------------ |
| `npm run docker:build`         | Build images for the main development environment.                             |
| `npm run docker:dev`           | Start the main development container in the background.                        |
| `npm run docker:shell`         | Open a bash shell in the main development container.                           |
| `npm run docker:test`          | Run tests (as defined in `package.json`'s `test` script) in a fresh container. |
| `npm run docker:build-project` | Build the Roblox project (e.g., `rbxtsc`) in a container.                      |
| `npm run docker:lint`          | Run linting in a container.                                                    |
| `npm run docker:logs`          | View logs from the main development container.                                 |
| `npm run docker:down`          | Stop all containers related to `docker-compose.yml`.                           |
| `npm run docker:clean`         | Stop containers and remove associated volumes (node_modules, rokit_cache).     |

## Development Workflow

1.  **Ensure Docker is running and your `.env` file is configured.**
2.  **Start the development environment:**
    ```bash
    npm run docker:dev
    ```
3.  **Open a shell in the container:**
    ```bash
    npm run docker:shell
    ```
4.  **Inside the container (now in `/workspace`), you can run any project commands:**

    ```bash
    # Compile TypeScript
    npm run build

    # Run tests (these are the full, Roblox-integrated tests)
    npm run test

    # Watch for TypeScript changes
    npm run watch
    ```

5.  Your local project files are mounted into `/workspace` in the container, so changes made locally are immediately reflected inside the container.
6.  **When done, stop the environment:**
    ```bash
    npm run docker:down
    ```

## Container Details (`roblox-ts-dev` service)

### Base Image

- **Node.js 20-slim** (Debian-based slim image).
- Includes Python 3 for test runners and other scripts.
- Contains necessary system dependencies for Roblox development with Rokit.

### Installed Tools (as `node` user)

- **Rokit**: Roblox toolchain manager, installed in `/home/node/.rokit`.
- **Rojo**: Roblox project syncing tool.
- **Lune**: Luau scripting runtime.
- Other tools installed by Rokit based on `rokit.toml`.

### User

- The container runs as the `node` user (UID 1000) for enhanced security.
- This user has its shell set to `/bin/bash`.

### Volumes

- **Source Code**: Your project directory (where `docker-compose.yml` resides) is mounted to `/workspace` inside the container.
- **Node Modules**: A named volume (`node_modules_volume`) is used to persist `node_modules` across container restarts for better performance.
- **Rokit Cache**: A named volume (`rokit_cache`) is used to persist Rokit's downloaded tools and cache in `/home/node/.rokit`.

### Ports

- **3000**: Exposed on the host, mapping to port 3000 inside the container (configurable in `docker-compose.yml`).

## Custom Environment Variables

A `.env` file at the root of the project is **required** for defining environment variables used by scripts and tools, particularly for interacting with Roblox services. Copy `.env.example` to `.env` and fill in your values.

Example content for `.env`:

```bash
export ROBLOX_API_KEY=your_api_key_here
export ROBLOX_UNIVERSE_ID=your_universe_id_here
export ROBLOX_PLACE_ID=your_place_id_here
```

These variables are primarily used for API key-based authentication and specifying target Universe/Place IDs.

## Troubleshooting

### Container won't start

1.  Ensure Docker Desktop (or Docker daemon) is running.
2.  Try rebuilding the images: `npm run docker:build`.
3.  Check logs for errors: `npm run docker:logs roblox-ts-dev` (or the specific service name if different).

### Permission issues with mounted volumes

The container runs as the `node` user (UID 1000 by default in the image). Ensure files created in mounted volumes are compatible with your host user's permissions if you edit them both inside and outside the container. Docker's volume mounting behavior can vary by OS. Using `COPY --chown=node:node` in the Dockerfile for initial file copies helps set baseline ownership within the image.

### Performance issues

- Ensure you are using named volumes for `node_modules` and Rokit cache as configured in `docker-compose.yml`.
- Adjust Docker Desktop's resource allocation (CPU, memory) if needed.
- On Windows, ensure your project files are located within your WSL2 filesystem if using Docker Desktop with the WSL2 backend, or consider performance implications of Hyper-V mounts.

### Rokit tools not found or not working

1.  Ensure `rokit.toml` is present in the `/workspace` directory inside the container (root of your project).
2.  The Rokit installation happens when the image is built, as the `node` user. Verify that `/home/node/.rokit/bin` is in the `PATH` (it's set in the Dockerfile).
3.  If issues persist, try rebuilding the image without cache: `npm run docker:build -- --no-cache`.
4.  Access the shell (`npm run docker:shell`) and check Rokit's status: `rokit list`, `which rokit`.

## Advanced Usage

### Running specific one-off commands

You can execute commands in a fresh, temporary container instance of a service (e.g., `roblox-ts-dev`):

```bash
docker compose -f docker-compose.yml run --rm roblox-ts-dev npm run build
```

(Note: `npm run docker:test`, `npm run docker:build-project`, etc., already use this pattern.)

### Accessing Logs for a Specific Service

```bash
docker compose -f docker-compose.yml logs -f roblox-ts-dev
```

### Debugging Scripts

To run a shell script with `bash -x` for debugging:

```bash
docker compose -f docker-compose.yml run --rm roblox-ts-dev bash -x /workspace/scripts/shell/test.sh
```

## Clean Up

To stop and remove containers, networks, and volumes defined in `docker-compose.yml`:

```bash
npm run docker:clean
```

To remove the Docker image for the `roblox-ts-dev` service (replace `projectname` with your actual project directory name if it influences the image name):

```bash
docker rmi projectname_roblox-ts-dev
# Or use the image ID. The exact image name might vary based on your project's directory name.
# Check `docker images` to list image names.
```

For information on additional, standalone Docker services (like `js-scripts`, `python-scripts`, `ts-src`), refer to the main `README.md` section "Additional Docker Services (`compose.yaml`)".
