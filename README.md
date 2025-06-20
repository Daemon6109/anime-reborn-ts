# Roblox TypeScript Project Template

A comprehensive, production-ready template for building Roblox experiences with TypeScript, featuring Docker containerization, cloud testing, and VS Code integration.

## ✨ Features

### 🧪 **Advanced Testing**

- **Jest cloud testing** via Roblox Open Cloud API
- **VS Code Jest extension** integration with Test Explorer
- **Individual test filtering** and execution
- **Automatic test discovery** from TypeScript files

### 🐳 **Cross-Platform Development**

- **Docker containerization** with x86_64 compatibility
- **VS Code dev containers** with pre-configured extensions
- **Consistent environments** across macOS, Windows, and Linux

### ⚡ **Developer Experience**

- **Hot reloading** with Rojo and TypeScript watch mode
- **Integrated linting** with ESLint and Prettier
- **Comprehensive VS Code configuration**
- **Multiple npm scripts** for common tasks

### 🛠️ **Production Ready**

- **TypeScript compilation** with Roblox-TS
- **Rokit tool management** for Roblox ecosystem
- **Environment variable management**
- **CI/CD pipeline** with GitHub Actions

## 🚀 Quick Start

### Prerequisites

- **Docker Desktop** installed and running
- **VS Code** (recommended) with Dev Containers extension

### Setup

1. **Clone and configure**:

    ```bash
    git clone <this-repo>
    cd roblox-ts-project
    cp .env.example .env
    # Edit .env with your Roblox API credentials
    ```

2. **Start development environment**:

    ```bash
    npm run docker:dev
    npm run docker:shell
    ```

3. **Inside the container**:
    ````bash
    npm run build    # Compile TypeScript
    npm test         # Run cloud tests
    npm run watch    # Start hot reloading
    ```## 📁 Project Structure
    ````

```
├── src/
│   ├── client/          # Client-side scripts
│   ├── server/          # Server-side scripts
│   ├── shared/          # Shared modules
│   └── tests/           # Jest test files
├── scripts/
│   ├── js/              # Jest runner and transformer
│   ├── python/          # Cloud API integration
│   └── shell/           # Development scripts
├── .vscode/             # VS Code configuration
├── .devcontainer/       # Dev container setup
├── .github/             # GitHub Actions and docs
│   ├── workflows/       # CI/CD pipelines
│   ├── SECRETS_SETUP.md # Setup guide for secrets
│   └── RELEASE_GUIDE.md # Release workflow guide
├── include/             # Roblox runtime includes
├── tasks/               # Server-side test tasks
├── docker-compose.yml   # Multi-service Docker setup
├── Dockerfile           # Development container
├── default.project.json # Rojo project configuration
├── package.json         # Node.js dependencies
├── tsconfig.json        # TypeScript configuration
├── jest.config.js       # Jest testing configuration
├── rokit.toml           # Rokit tool management
└── .env.example         # Environment variables template
```

## 🧪 Testing

### Run Tests

```bash
# All tests via cloud
npm test

# Jest tests only
npm run test:jest

# Individual test by name
npx jest --testNamePattern="specific test name"
```

### VS Code Integration

- Open **Test Explorer** panel
- Click ▶️ to run individual tests
- View results in real-time
- Debug with VS Code debugger

## 🐳 Docker Commands

| Command                | Description                   |
| ---------------------- | ----------------------------- |
| `npm run docker:dev`   | Start development environment |
| `npm run docker:shell` | Open container shell          |
| `npm run docker:test`  | Run tests in container        |
| `npm run docker:build` | Build Docker images           |
| `npm run docker:down`  | Stop all services             |

## 🚀 Release & Deployment

This template includes automated release and deployment workflows:

### 🧪 Prereleases (Testing)

- Create a **GitHub prerelease**
- Automatically deploys to **test environment**
- Perfect for beta testing and validation

### 🎉 Production Releases

- Create a **GitHub release**
- Automatically deploys to **production environment**
- Includes full test validation and verification

See [**Release Guide**](.github/RELEASE_GUIDE.md) for detailed instructions.

## ⚙️ Configuration

### Environment Variables

Create a `.env` file with:

```bash
export ROBLOX_API_KEY="your_api_key_here"
export ROBLOX_UNIVERSE_ID="your_universe_id"
export ROBLOX_PLACE_ID="your_place_id"
```

### GitHub Secrets & Variables

For CI/CD and automated deployments, configure:

- **Repository Secret**: `ROBLOX_API_KEY`
- **Repository Variables**: Test and production environment IDs

See [**Secrets Setup Guide**](.github/SECRETS_SETUP.md) for detailed instructions.

### VS Code Extensions

Automatically installed in dev container:

- Roblox-TS Language Support
- ESLint & Prettier
- Jest Test Explorer
- Luau LSP
- And more...

## 📚 Documentation

- **[DOCKER.md](DOCKER.md)** - Detailed Docker setup and troubleshooting
- **[JEST_INTEGRATION.md](JEST_INTEGRATION.md)** - Testing framework details
- **[Secrets Setup](.github/SECRETS_SETUP.md)** - CI/CD configuration
- **[Release Guide](.github/RELEASE_GUIDE.md)** - Deployment workflow
- **[Contributing](CONTRIBUTING.md)** - How to contribute to this template

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

See [**Contributing Guidelines**](CONTRIBUTING.md) for detailed information.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🙏 Acknowledgments

- **Roblox-TS Team** for the TypeScript compiler
- **Rojo Team** for the project sync tool
- **Jest-Lua** for the testing framework
- **Rokit** for tool management

---

**⭐ Star this repository if it helped you build amazing Roblox experiences!**
