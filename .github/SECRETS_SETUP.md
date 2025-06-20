# GitHub Secrets Setup for CI/CD

This document explains how to configure GitHub repository secrets and variables to enable cloud testing and automated deployments.

## 🏗️ Environment Setup

### Create Separate Roblox Environments

You'll need **two separate Roblox experiences**:

1. **Test Environment**: For running automated tests and prerelease validation
2. **Production Environment**: For your actual game/experience

#### Steps:

1. **Create a Test Experience** in Roblox Studio

    - This should be a copy of your production experience
    - Used for CI/CD testing and prerelease validation
    - Can be a simpler version with just core functionality

2. **Keep your Production Experience** separate
    - Your actual game that users play
    - Only updated via the release workflow after full testing

## 🔐 Required Secrets & Variables

### GitHub Repository Secrets

Configure these in **Settings** → **Secrets and variables** → **Actions** → **Repository secrets**:

| Secret Name      | Description                                               | Example Value                             |
| ---------------- | --------------------------------------------------------- | ----------------------------------------- |
| `ROBLOX_API_KEY` | Open Cloud API key with permissions for both environments | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` |

### GitHub Repository Variables

Configure these in **Settings** → **Secrets and variables** → **Actions** → **Variables**:

| Variable Name                   | Description                                 | Example Value |
| ------------------------------- | ------------------------------------------- | ------------- |
| `ROBLOX_TEST_UNIVERSE_ID`       | Universe ID for your test environment       | `1234567890`  |
| `ROBLOX_TEST_PLACE_ID`          | Place ID for your test environment          | `9876543210`  |
| `ROBLOX_PRODUCTION_UNIVERSE_ID` | Universe ID for your production environment | `5555555555`  |
| `ROBLOX_PRODUCTION_PLACE_ID`    | Place ID for your production environment    | `7777777777`  |

## 📋 Setup Instructions

### 1. Get Your Roblox Open Cloud API Key

1. Go to [Roblox Creator Dashboard](https://create.roblox.com/)
2. Navigate to **Open Cloud** → **API Keys**
3. Click **Create API Key**
4. Configure permissions for **both your test and production environments**:
    - **universe.places:write** - Required for publishing places
    - **universe.place.luau-execution-session:write** - Required for running tests
    - Apply these permissions to both your test and production universes
5. **Copy the API key** - you won't be able to see it again!

### 2. Get Your Universe and Place IDs

For **both your test and production environments**:

1. Open each experience in **Roblox Studio**
2. **Universe ID**: Found in Game Settings → Basic Info
3. **Place ID**: Found in the URL when editing the place, or in Place Settings

### 3. Configure GitHub Repository Secrets

1. Go to your **GitHub repository**
2. Click **Settings** → **Security** → **Secrets and variables** → **Actions**

#### Add Repository Secret:

3. Click **New repository secret**:
    - Name: `ROBLOX_API_KEY`
    - Value: `your_api_key_here`

#### Add Repository Variables:

4. Click **Variables** tab, then **New repository variable** for each:
    - Name: `ROBLOX_TEST_UNIVERSE_ID`, Value: `your_test_universe_id`
    - Name: `ROBLOX_TEST_PLACE_ID`, Value: `your_test_place_id`
    - Name: `ROBLOX_PRODUCTION_UNIVERSE_ID`, Value: `your_production_universe_id`
    - Name: `ROBLOX_PRODUCTION_PLACE_ID`, Value: `your_production_place_id`

## 🚀 Testing the Setup

### Verify Configuration

1. **Push a commit** to `main` or `develop` branch
2. Go to **Actions** tab in your repository
3. Check the **CI/CD Pipeline** workflow
4. If secrets are configured correctly, you should see:
    - ✅ "Run cloud tests" step executes against **test environment**
    - ✅ Tests run against actual Roblox environment
    - ✅ Real test results in the logs

### Release Testing

1. **Create a release** (or prerelease) in GitHub
2. Check the **Release** workflow
3. Verify it publishes to the correct environment:
    - 🧪 **Prerelease**: Publishes to test environment
    - 🚀 **Release**: Publishes to production environment

### Without Secrets

If secrets are not configured:

- ⚠️ Pipeline will skip cloud tests
- 💡 Only basic validation will run
- 📝 Helpful message explains what's missing

## 🛡️ Branch Protection (Optional but Recommended)

Set up branch protection rules to ensure code quality:

1. Go to **Settings** → **Branches**
2. Click **Add rule** for `main` branch
3. Configure:
    - ✅ **Require status checks to pass**
    - ✅ **Require branches to be up to date**
    - ✅ Select the CI/CD Pipeline check
    - ✅ **Require review from code owners** (optional)
    - ✅ **Restrict pushes that create files**

## 🔒 Security Best Practices

### API Key Security

- ✅ **Never commit API keys** to your repository
- ✅ **Use dedicated test environments** - don't use production places
- ✅ **Limit API key permissions** to only what's needed
- ✅ **Rotate keys regularly** for security
- ✅ **Use separate keys** for development vs production

### Test Environment Setup

- 🎯 **Create a dedicated test universe** for CI/CD
- 🎯 **Use a simple test place** with minimal assets
- 🎯 **Keep test data separate** from production data
- 🎯 **Monitor API usage** to avoid rate limits

### Repository Access

- 👥 **Limit who can access secrets** - only repository administrators
- 🔐 **Use organization secrets** for shared resources across multiple repositories
- 📊 **Monitor secret usage** in Actions logs

## 🛠️ Troubleshooting

### Common Issues

**"Cloud tests skipped" message**:

- Check that all three secrets are configured
- Verify secret names match exactly (case-sensitive)
- Ensure API key has proper permissions

**API authentication failures**:

- Verify API key is still valid (they can expire)
- Check Universe/Place IDs are correct
- Ensure API key has permissions for the specified Universe/Place

**Test timeout or failures**:

- Check Roblox service status
- Verify test place is published and accessible
- Monitor API rate limits

**Docker test failures**:

- Ensure secrets are properly passed to Docker environment
- Check Docker container has necessary system dependencies
- Verify `.env` file is created correctly in the container

### Debug Tips

1. **Check Action logs** for detailed error messages
2. **Verify API key permissions** in Roblox Creator Dashboard
3. **Test locally first** with same credentials
4. **Use simple test cases** to isolate issues

## 📊 Monitoring

### What to Watch

- **Test execution time** - should be consistent
- **API rate limit usage** - avoid hitting limits
- **Test reliability** - investigate flaky tests
- **Secret rotation** - update keys before expiration

### Success Metrics

- ✅ **Green CI/CD pipeline** on all commits
- ✅ **Consistent test execution** times
- ✅ **Reliable cloud connectivity**
- ✅ **Clear test results** and logging

## 🔄 Next Steps

Once your CI/CD is working with cloud tests:

1. **Add deployment automation** - auto-publish on successful tests
2. **Implement staging environments** - test in multiple places
3. **Add performance monitoring** - track test execution metrics
4. **Set up notifications** - get alerts for test failures

---

**💡 Pro Tip**: Start with a simple test universe and gradually expand your CI/CD capabilities as your project grows!
