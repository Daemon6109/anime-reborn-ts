# Jest Testing Setup for Roblox TypeScript Project

## Overview

This project has a comprehensive Jest test setup that supports both local VS Code development and cloud Roblox execution. The setup handles TypeScript, decorators, and Roblox-specific APIs seamlessly, with a robust CI/CD pipeline that uses cloud testing for maximum accuracy.

## Testing Strategy

### Local Development

- **Fast iteration**: Local Jest with Roblox API mocks for quick development
- **Full coverage**: All places tested locally for comprehensive validation
- **VS Code integration**: Test Explorer, debugging, and watch mode support

### CI/CD Pipeline

- **Two-stage approach**: Local tests first (fast feedback), then cloud tests (accuracy)
- **Cloud validation**: Uses actual Roblox environment for deployment gating
- **Production-ready**: Only deploy if cloud tests pass

### Cloud Testing Limitations

Due to Jest runtime global conflicts when running multiple places in the same Roblox environment, **only the Common place is tested in the cloud**. This is sufficient for CI/CD validation as:

- Common contains shared utilities and core functionality
- Place-specific logic is thoroughly tested locally
- Cloud tests validate Roblox API compatibility and runtime behavior

## Available Test Commands

### Primary Commands

1. **`npm run test`** - **Main CI/CD command**
   - Runs cloud tests using actual Roblox environment
   - Uses `./scripts/shell/test.sh` for cloud execution
   - Preferred for deployment validation and accuracy

2. **`npm run test:jest`** - Local development command
   - Runs tests locally in Node.js with Roblox API mocks
   - VS Code Test Explorer integration
   - Fast execution and debugging support
   - Tests all places locally

3. **`npm run test:coverage`** - Coverage collection
   - Runs tests with coverage reporting
   - Uses a separate config to avoid Babel parsing issues
   - Generates HTML, LCOV, and text reports
   - Coverage files: `coverage/` directory

4. **`npm run test:shell`** - Alias for cloud execution
   - Same as `npm run test`
   - Builds project and runs tests in actual Roblox environment

### Utility Commands

- **`npm run test:local`** - Alias for `npm run test:jest`
- **`npm run test:debug`** - Debug mode with `--runInBand`
- **`npm run test:local-build`** - Build then run local tests
- **`npm run lint`** - Run ESLint on all TypeScript files
- **`npm run lint:fix`** - Run ESLint with auto-fix for formatting issues

## CI/CD Integration

### GitHub Actions Workflow

The project uses a two-stage testing approach in CI/CD with Docker containers that include all necessary tools (rokit, rbxtsc, etc.):

#### 1. Local Tests Job (`test-local`)

- **Purpose**: Fast feedback and comprehensive validation
- **What it does**:
  - Builds Docker environment with rokit and all tools
  - Installs dependencies in Docker container
  - Linting with auto-fix (`npm run lint:fix`)
  - Build verification (`npm run build`)
  - Local Jest execution (all places)
  - Coverage collection and reporting
- **Speed**: ~3-5 minutes (including Docker build)
- **Scope**: All places tested with mocked Roblox APIs

#### 2. Cloud Tests Job (`test-cloud`)

- **Purpose**: Roblox environment validation
- **What it does**:
  - Builds Docker environment (runs after local tests pass)
  - Uses `npm run test` (cloud execution)
  - Tests in actual Roblox environment
  - Only tests Common place (see limitations above)
- **Speed**: ~7-12 minutes (including Docker build and cloud execution)
- **Scope**: Common place with real Roblox APIs

#### Environment Variables Required

For cloud testing in CI/CD, set these GitHub secrets:

```bash
ROBLOX_API_KEY=your_api_key
PLACE_ID=your_place_id
UNIVERSE_ID=your_universe_id
```

### Deployment Strategy

- **Pre-deployment**: Cloud tests must pass
- **Post-deployment**: Cloud tests verify deployment
- **Gating**: Only cloud-validated code reaches production

## Configuration Files

### Core Configs

1. **`jest.config.js`** - Main Jest configuration
   - Auto-detects VS Code Jest extension
   - Routes to appropriate runners and configs
   - Disables coverage by default to avoid Babel issues

2. **`jest.vscode.config.js`** - VS Code-specific configuration
   - Optimized for VS Code Jest extension
   - Includes Roblox mocks for Node.js execution
   - Fast execution, no coverage

3. **`jest.coverage.config.js`** - Coverage-specific configuration
   - Targeted coverage collection avoiding problematic files
   - Uses custom transformer for TypeScript
   - Excludes complex files that cause Babel parsing errors

### Supporting Files

- **`babel.config.js`** - Babel configuration for coverage instrumentation
- **`scripts/js/jest-transformer.js`** - Custom TypeScript transformer (Jest 28+ compatible)
- **`scripts/js/jest-setup-roblox-mocks.js`** - Roblox API mocks for Node.js
- **`scripts/shell/jest-vscode-wrapper.sh`** - Argument filtering for VS Code integration

## VS Code Integration

### Jest Extension

The setup works seamlessly with the VS Code Jest extension:

1. **Test Discovery**: Automatically finds all test files
2. **Test Execution**: Click to run individual tests or suites
3. **Test Results**: Shows pass/fail status in Test Explorer
4. **Debug Support**: Set breakpoints and debug tests
5. **Watch Mode**: Automatically re-runs tests on file changes

### Settings

VS Code Jest extension settings are configured in `.vscode/settings.json`:

```json
{
  "jest.jestCommandLine": "npm run test:jest",
  "jest.autoRun": "off"
}
```

## Coverage

### How to Use Coverage

```bash
# Run tests with coverage
npm run test:coverage

# View HTML coverage report
open coverage/lcov-report/index.html
```

### Coverage Limitations

Currently, coverage is limited to basic files to avoid Babel TypeScript parsing issues:

- ✅ Test files (`**/*.spec.ts`, `**/*.test.ts`)
- ✅ Runtime files (`runtime.*.ts`)
- ✅ Module files (`module.ts`)
- ❌ Data types and interfaces (cause "flow syntax" errors)
- ❌ Files with decorators (parsing issues)
- ❌ Complex TypeScript features (generics, etc.)

### Expanding Coverage

To include more files in coverage, edit `jest.coverage.config.js` and add patterns to `collectCoverageFrom`. Test with `npm run test:coverage` to ensure no Babel errors.

## Roblox API Mocking

The setup includes comprehensive Roblox API mocks for local testing:

### Mocked APIs

- **string.size()** - Roblox string method
- **typeOf()** - Roblox type checking function
- **Basic Services**: Players, ReplicatedStorage, etc.
- **Global objects**: game, workspace, script, etc.

### Mock Configuration

Mocks are defined in `scripts/js/jest-setup-roblox-mocks.js` and automatically applied when running locally.

## File Structure

```text
places/
├── common/src/tests/test.spec.ts
├── lobby/src/tests/test.spec.ts
├── gameplay/src/tests/test.spec.ts
└── afk/src/tests/test.spec.ts

scripts/
├── js/
│   ├── jest-runner.js              # Cloud execution runner
│   ├── jest-transformer.js         # TypeScript transformer
│   └── jest-setup-roblox-mocks.js  # Roblox API mocks
└── shell/
    ├── jest-vscode-wrapper.sh       # VS Code argument filtering
    └── test.sh                      # Cloud execution script

jest.config.js                      # Main Jest config
jest.vscode.config.js               # VS Code-specific config
jest.coverage.config.js             # Coverage-specific config
babel.config.js                     # Babel config for coverage
```

## Troubleshooting

### Common Issues

1. **Tests not discovered in VS Code**
   - Ensure Jest extension is installed
   - Check that `jest.jestCommandLine` points to `npm run test:jest`
   - Restart VS Code Jest extension

2. **Coverage collection fails**
   - Use `npm run test:coverage` (not `npm run test:jest -- --coverage`)
   - Check `jest.coverage.config.js` for file exclusions
   - Some TypeScript files may need to be excluded due to Babel limitations

3. **Roblox API errors in local tests**
   - Ensure mocks are loaded by checking `setupFilesAfterEnv` in config
   - Add new APIs to `jest-setup-roblox-mocks.js` if needed

4. **Transform errors (Jest 28+)**
   - Custom transformer always returns `{ code, map }` object
   - Should work with Jest 28+ out of the box

5. **Cloud tests fail with Jest conflicts**
   - This is expected behavior - only Common place runs in cloud
   - Verify other places pass locally with `npm run test:jest`
   - Check `/tasks/run-tests.server.luau` for current cloud test configuration

6. **CI/CD failures**
   - Local tests failing: Check linting, build, and Jest locally
   - Cloud tests failing: Verify Roblox API credentials and environment
   - Deployment issues: Ensure cloud tests pass before merge

### Testing Workflow Best Practices

1. **Development**: Use `npm run test:jest` for fast local iteration
2. **Pre-commit**: Run `npm run test:coverage` for full validation  
3. **Linting**: Use `npm run lint:fix` to auto-fix formatting issues locally
4. **CI/CD**: Let GitHub Actions handle the two-stage testing with auto-fix
5. **Debugging**: Use VS Code Jest extension for breakpoint debugging
6. **Cloud validation**: Use `npm run test` to manually verify cloud behavior

**Note**: CI/CD automatically fixes linting issues using `npm run lint:fix`, ensuring consistent code formatting across the project.

### Adding New Tests

1. Create test files in `places/*/src/tests/` directories
2. Use `.spec.ts` or `.test.ts` extension
3. Import and use Jest globals (`describe`, `it`, `expect`)
4. Mock Roblox APIs as needed (or use existing mocks)

### Adding New Roblox APIs

To mock a new Roblox API:

1. Edit `scripts/js/jest-setup-roblox-mocks.js`
2. Add the API to the global object or extend existing mocks
3. Test with `npm run test:jest`

## Performance

### Local Testing

- **Jest execution**: ~0.7s for all tests (all places)
- **With coverage**: ~1.1s for all tests  
- **VS Code integration**: Near-instant test discovery and execution

### Cloud Testing

- **Build time**: ~5-10s (TypeScript compilation)
- **Upload and execution**: ~10-30s depending on Roblox API response
- **Total cloud test time**: ~15-40s for Common place validation

### CI/CD Performance

- **Local tests job**: ~3-5 minutes (Docker build, lint, build, test, coverage)
- **Cloud tests job**: ~7-12 minutes (Docker build, upload, execute)
- **Total pipeline**: ~10-17 minutes for full validation

## Future Improvements

### Potential Enhancements

1. **Multi-place cloud testing**:
   - Investigate Jest global isolation techniques
   - Consider separate Roblox sessions for each place
   - Explore alternative test runners for cloud execution

2. **Enhanced coverage**:
   - Gradually add more file patterns to coverage config
   - Improve TypeScript parsing for complex files
   - Better Babel configuration for decorators

3. **Performance optimizations**:
   - Parallel cloud test execution (if multi-place support added)
   - Incremental builds for faster CI/CD
   - Smarter test selection based on changed files

4. **Developer experience**:
   - More comprehensive Roblox API mocks
   - Better VS Code debugging integration
   - Automated test generation tools

### Current Limitations

- **Cloud testing**: Only Common place due to Jest global conflicts
- **Coverage**: Limited to basic files due to Babel TypeScript parsing
- **Performance**: Cloud tests are slower but provide accuracy
- **Complexity**: Two-stage testing requires understanding of both local and cloud workflows

## Next Steps

1. **Immediate**:
   - Monitor CI/CD performance and adjust as needed
   - Add more comprehensive tests to Common place for better cloud validation
   - Document any new Roblox APIs that need mocking

2. **Short-term**:
   - Expand coverage collection to include more file types
   - Investigate solutions for multi-place cloud testing
   - Optimize build and upload times for cloud tests

3. **Long-term**:
   - Consider alternative testing frameworks that handle Roblox environments better
   - Implement integration tests that exercise cross-place functionality
   - Explore automated performance testing in cloud environment

---

The Jest setup now provides a robust, production-ready testing framework with comprehensive local development support and accurate cloud validation for CI/CD workflows!
