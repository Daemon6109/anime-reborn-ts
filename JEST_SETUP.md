# Jest Testing Setup for Roblox TypeScript Project

## Overview

This project now has a fully working Jest test setup that supports both local VS Code development and cloud Roblox execution. The setup handles TypeScript, decorators, and Roblox-specific APIs seamlessly.

## Available Test Commands

### Primary Commands

1. **`npm run test:jest`** - Main testing command for VS Code Jest extension
   - Runs tests locally in Node.js with Roblox API mocks
   - VS Code Test Explorer integration
   - Fast execution and debugging support
   - No coverage collection (for speed)

2. **`npm run test:coverage`** - Coverage collection
   - Runs tests with coverage reporting
   - Uses a separate config to avoid Babel parsing issues
   - Generates HTML, LCOV, and text reports
   - Coverage files: `coverage/` directory

3. **`npm run test:shell`** - Cloud execution
   - Builds project and runs tests in actual Roblox environment
   - Uses custom Jest runner for cloud execution
   - Slower but tests against real Roblox APIs

### Utility Commands

- **`npm run test`** - Basic Jest (mainly for CI/CD)
- **`npm run test:debug`** - Debug mode with `--runInBand`

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

- **Local execution**: ~0.7s for all tests
- **With coverage**: ~1.1s for all tests  
- **Cloud execution**: ~10-30s depending on build time

## Next Steps

1. **Expand Coverage**: Gradually add more file patterns to coverage config
2. **Better Babel Config**: Improve TypeScript parsing for coverage
3. **More Roblox Mocks**: Add missing APIs as needed
4. **Integration Tests**: Add tests that exercise actual game logic
5. **CI/CD Integration**: Use `npm run test:coverage` in automated builds

---

The Jest setup is now production-ready for both local development and cloud testing!
