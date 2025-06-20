# Release & Deployment Guide

This guide explains how to use the automated release and deployment system for your Roblox TypeScript project.

## 🚀 Release Types

### 🧪 Prerelease (Testing)

- **Purpose**: Deploy to test environment for validation
- **Trigger**: Create a GitHub prerelease
- **Target**: Test universe/place
- **Use Case**: Beta testing, staging validation, feature previews

### 🎉 Full Release (Production)

- **Purpose**: Deploy to live production environment
- **Trigger**: Create a GitHub release (not prerelease)
- **Target**: Production universe/place
- **Use Case**: Public releases, stable versions

## 📋 Release Process

### Creating a Prerelease

1. **Ensure all tests pass** on your main branch
2. **Go to GitHub** → **Releases** → **Create a new release**
3. **Configure the release**:
    - Tag: `v1.0.0-beta.1` (or similar prerelease format)
    - Title: `v1.0.0 Beta 1`
    - ✅ **Check "Set as a pre-release"**
    - Description: What's new in this prerelease
4. **Click "Publish release"**

**What happens automatically**:

- ✅ Builds Docker environment with all tools pre-installed
- ✅ Runs linting and compilation in Docker
- ✅ Runs full test suite on test environment via Docker
- ✅ Builds the project in Docker
- ✅ Deploys to your **test universe/place** using Docker
- ✅ Provides test link for validation

### Creating a Production Release

1. **Validate prerelease** works correctly
2. **Go to GitHub** → **Releases** → **Create a new release**
3. **Configure the release**:
    - Tag: `v1.0.0` (semantic version)
    - Title: `v1.0.0`
    - ❌ **Do NOT check "Set as a pre-release"**
    - Description: Release notes and changelog
4. **Click "Publish release"**

**What happens automatically**:

- ✅ Builds Docker environment with all tools pre-installed
- ✅ Runs full test suite on test environment via Docker
- ✅ Builds the project in Docker
- ✅ Deploys to your **production universe/place** using Docker
- ✅ Runs post-deployment verification in Docker
- ✅ Provides live game link

## 🔄 Workflow Details

### Release Workflow (`release.yml`)

#### 1. Pre-deployment Testing (Docker Environment)

- **Linting** and **compilation** in Docker
- **Build verification** using Docker
- **Full cloud test suite** on test environment via Docker
- **Blocks deployment** if any tests fail

#### 2. Environment-based Deployment

- **Prerelease** → Test environment
- **Full release** → Production environment
- **Automatic environment selection** based on release type
- **Docker-based deployment** ensures consistent tool versions and environment

#### 🐳 Docker-First Advantages

- **✅ Consistent Environment**: Same tools and versions as development
- **✅ No Tool Installation**: Rokit, Rojo, rbxtsc pre-installed in Docker
- **✅ Cross-Platform**: Works identically on any GitHub Actions runner
- **✅ Faster Deployment**: No time spent installing dependencies
- **✅ Reproducible**: Exact same environment every time

#### 3. Post-deployment Verification

- **Production releases only**
- Runs additional verification checks
- Ensures deployment was successful

#### 4. Notifications & Status

- **Success notifications** with game links
- **Failure alerts** if deployment fails
- **Clear status messages** in Actions logs

## 🛡️ Safety Features

### Automated Quality Gates

- ✅ **All tests must pass** before deployment
- ✅ **Build must succeed** before deployment
- ✅ **Linting and type checks** must pass
- ✅ **Test environment validation** before production

### Environment Isolation

- 🧪 **Test environment** for prereleases and CI/CD
- 🚀 **Production environment** only for full releases
- 🔒 **Separate API permissions** for each environment
- 🔍 **Clear deployment targets** and logging

### Rollback Capabilities

- 📝 **Release history** preserved in GitHub
- 🔄 **Easy rollback** by publishing previous release
- 📊 **Deployment logs** for troubleshooting
- ⚡ **Quick redeployment** if needed

## 📚 Best Practices

### Version Naming

```bash
# Prereleases
v1.0.0-alpha.1    # Early development
v1.0.0-beta.1     # Feature complete, testing
v1.0.0-rc.1       # Release candidate

# Production releases
v1.0.0            # Major release
v1.0.1            # Patch release
v1.1.0            # Minor release
```

### Release Schedule

1. **Weekly prereleases** for active development
2. **Test thoroughly** in prerelease environment
3. **Monthly production releases** for stable features
4. **Hotfix releases** for critical issues

### Testing Strategy

1. **Unit tests** run on every commit
2. **Integration tests** on prerelease deployment
3. **User acceptance testing** in prerelease environment
4. **Smoke tests** after production deployment

## 🔧 Configuration

### Required Setup

Ensure you have configured:

- ✅ `ROBLOX_API_KEY` secret
- ✅ `ROBLOX_TEST_UNIVERSE_ID` variable
- ✅ `ROBLOX_TEST_PLACE_ID` variable
- ✅ `ROBLOX_PRODUCTION_UNIVERSE_ID` variable
- ✅ `ROBLOX_PRODUCTION_PLACE_ID` variable

### Permissions Required

Your API key needs these permissions:

- `universe.places:write` for both environments
- `universe.place.luau-execution-session:write` for testing

## 🚨 Troubleshooting

### Deployment Fails

1. **Check Actions logs** for detailed errors
2. **Verify API key permissions** for target environment
3. **Ensure universe/place IDs** are correct
4. **Check Roblox service status**

### Tests Fail Before Deployment

1. **Review test output** in Actions logs
2. **Test locally** to reproduce issues
3. **Fix issues** and push new commits
4. **Create new release** after fixes

### Post-deployment Issues

1. **Check production game** functionality
2. **Monitor error logs** if available
3. **Consider rollback** to previous version
4. **Create hotfix release** if needed

### Common Issues

- **Invalid place/universe IDs**: Double-check variables
- **API rate limits**: Wait and retry, or contact Roblox
- **Permission errors**: Verify API key permissions
- **Build failures**: Check TypeScript/build errors

## 📊 Monitoring

### What to Monitor

- ✅ **Release success rate**
- ✅ **Deployment time duration**
- ✅ **Test execution time**
- ✅ **Post-deployment health**

### Success Metrics

- 🎯 **Green deployments** for all releases
- 🎯 **Fast deployment times** (< 5 minutes)
- 🎯 **High test coverage** and reliability
- 🎯 **Zero production incidents** from releases

---

**💡 Pro Tip**: Always test prereleases thoroughly before creating production releases. Your users will thank you for the stable experience!
