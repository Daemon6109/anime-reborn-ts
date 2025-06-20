# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Initial template release
- Docker containerization with cross-platform support
- Jest cloud testing integration with Roblox Open Cloud
- VS Code Jest extension integration
- Comprehensive development environment setup
- Hot reloading with Rojo and TypeScript watch mode
- ESLint v9 configuration with flat config format
- Dev container support with pre-configured extensions
- GitHub Actions CI/CD pipeline

### Changed

- **ESLint Migration**: Updated to ESLint v9 with new flat config format
- **Configuration**: Migrated from `.eslintrc` to `eslint.config.mjs`
- **Linting**: Simplified linting commands with npm scripts
- **CI/CD Architecture**: Redesigned workflows to use Docker-first approach
- **Docker Commands**: Added fallback support for both Docker Compose V1 and V2
- **Release Workflow**: Updated release pipeline to use Docker-first approach for consistent deployments

### Fixed

- **ESLint Errors**: Fixed constant binary expression issues in test files
- **Code Quality**: Improved test examples to avoid linting warnings
- **GitHub Actions**: Fixed invalid workflow syntax for secret checking
- **CI/CD**: Updated workflows to use proper secret validation and new ESLint commands
- **TypeScript Compilation**: Simplified CI to use build step instead of separate type checking to avoid dependency conflicts
- **Docker Compose**: Added support for both `docker-compose` and `docker compose` commands
- **Tool Installation**: Fixed CI failures by using pre-built Docker environment instead of manual tool installation
- **Workflow Complexity**: Removed redundant legacy fallback jobs in CI and release workflows

### Features

- **Cross-Platform Docker**: Uses `--platform=linux/amd64` for consistent behavior
- **Cloud Testing**: Execute Jest tests via Roblox Open Cloud API
- **VS Code Integration**: Full Test Explorer support with individual test execution
- **Development Tools**: Rokit tool management, environment variables, npm scripts
- **Documentation**: Comprehensive setup and usage guides

## [1.0.0] - 2025-01-XX

### Added

- Initial stable release of the Roblox TypeScript template
- Complete Docker development environment
- Jest testing framework with cloud execution
- VS Code configuration and extensions
- Documentation and contribution guidelines

### Technical Details

- Node.js 20.x LTS support
- TypeScript 5.8+ compatibility
- Jest 29.7.0 for VS Code extension compatibility
- Roblox-TS 3.0+ support
- Cross-platform Docker with AMD64 emulation

---

## Template Usage Notes

When using this template for your own project:

1. **Update package.json** with your project details
2. **Configure .env** with your Roblox API credentials
3. **Modify default.project.json** for your project structure
4. **Update README.md** with your project-specific information
5. **Update README.md** with your project-specific information and branding
