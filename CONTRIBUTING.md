# Contributing to Roblox TypeScript Template

Thank you for your interest in contributing! This guide will help you get started.

## 🚀 Development Setup

1. **Fork and clone the repository**
2. **Set up your development environment**:
    ```bash
    cp .env.example .env
    # Configure your Roblox API credentials
    npm run docker:dev
    npm run docker:shell
    ```

## 📋 How to Contribute

### 🐛 Bug Reports

- Use the **Bug Report** issue template
- Include steps to reproduce
- Provide Docker/system information
- Include error logs and screenshots

### ✨ Feature Requests

- Use the **Feature Request** issue template
- Explain the use case clearly
- Consider backwards compatibility
- Discuss implementation approach

### 🔧 Code Contributions

#### Pull Request Process

1. **Create a feature branch** from `main`
2. **Make your changes** following the coding standards
3. **Add tests** for new functionality
4. **Update documentation** if needed
5. **Ensure all checks pass**:
    ```bash
    npm run build      # TypeScript compilation
    npm run lint       # Linting
    npm test           # Run tests
    ```
6. **Submit the pull request**

#### Coding Standards

- **TypeScript**: Follow existing patterns and use strict typing
- **Formatting**: Use Prettier (configured via `.prettierrc`)
- **Linting**: Follow ESLint rules (configured via `eslint.config.mjs`)
- **Commits**: Use conventional commit messages:
    ```
    feat: add new Docker service for production builds
    fix: resolve Jest extension compatibility issue
    docs: update installation instructions
    ```

#### Testing Guidelines

- **Add tests** for new features and bug fixes
- **Cloud tests**: Test against actual Roblox environment when possible
- **Jest tests**: Use the existing test structure in `src/tests/`
- **Integration tests**: Verify Docker and VS Code setups work

## 🏗️ Architecture Guidelines

### Docker Changes

- **Maintain cross-platform compatibility** with `--platform=linux/amd64`
- **Keep images minimal** - avoid unnecessary dependencies
- **Test on different architectures** when possible
- **Update documentation** for any new services

### Jest Integration

- **Preserve VS Code compatibility** when modifying the custom runner
- **Maintain test discovery** functionality
- **Keep cloud integration** working with Roblox Open Cloud
- **Test with both individual and batch test execution**

### VS Code Configuration

- **Keep extensions minimal** but comprehensive
- **Maintain dev container** compatibility
- **Test with fresh VS Code installations**
- **Document any new required extensions**

## 📁 Project Structure

When adding new features, follow this structure:

```
├── src/                    # Main source code
├── scripts/
│   ├── js/                # Jest runner and build scripts
│   ├── python/            # Roblox API integration
│   └── shell/             # Development and build scripts
├── .vscode/               # VS Code configuration
├── .devcontainer/         # Dev container setup
├── docs/                  # Additional documentation
└── .github/               # GitHub templates and workflows
```

## 🧪 Testing Your Changes

### Local Testing

```bash
# Test Docker setup
npm run docker:build
npm run docker:dev

# Test Jest integration
npm run test:jest
npm test

# Test VS Code setup
# Open in VS Code and verify extensions work
```

### Manual Testing Checklist

- [ ] Docker builds successfully on clean system
- [ ] Jest extension shows tests in VS Code
- [ ] Individual test execution works
- [ ] Cloud tests execute properly
- [ ] Hot reloading works with `npm run watch`
- [ ] All npm scripts function correctly

## 📖 Documentation

### Required Documentation Updates

- **README.md**: Update for user-facing changes
- **DOCKER.md**: Update for Docker/container changes
- **JEST_INTEGRATION.md**: Update for testing changes
- **Code comments**: Add for complex logic
- **CHANGELOG.md**: Add entry for significant changes

### Documentation Standards

- **Clear and concise** explanations
- **Step-by-step instructions** where applicable
- **Code examples** for complex setups
- **Screenshots** for VS Code/UI changes

## 🎯 Priority Areas

Current areas where contributions are especially welcome:

### High Priority

- **CI/CD improvements** - GitHub Actions optimization
- **Performance optimizations** - Docker build times, Jest execution
- **Cross-platform testing** - Windows, Intel Mac, ARM Mac
- **Documentation improvements** - Video tutorials, troubleshooting

### Medium Priority

- **Additional Roblox integrations** - Asset management, publishing
- **Development tools** - Debugging support, profiling
- **Template variations** - Different project types, frameworks

### Low Priority

- **UI improvements** - Better VS Code themes, icons
- **Advanced features** - Custom build pipelines, deployment

## 🚨 Breaking Changes

If your contribution includes breaking changes:

1. **Document the breaking change** clearly
2. **Provide migration instructions**
3. **Update the major version** in package.json
4. **Consider backwards compatibility** options

## 💬 Getting Help

- **GitHub Discussions** - For questions and ideas
- **GitHub Issues** - For bug reports and feature requests
- **Discord/Community** - Link to relevant Roblox-TS communities

## 🏷️ Release Process

1. **Update version** in package.json
2. **Update CHANGELOG.md** with changes
3. **Create release** on GitHub
4. **Tag the release** following semantic versioning

Thank you for contributing to make this template better for the entire Roblox-TS community! 🎉
