# Jest-Lua Cloud Test Integration

This project integrates the VS Code Jest extension with a Roblox-TS/Jest-Lua project using a custom cloud test pipeline.

## ✅ Features

- **VS Code Test Explorer Integration**: Full support for VS Code Jest extension
- **Dynamic Test Discovery**: Automatically discovers tests from TypeScript files
- **Single Test Execution**: Run individual tests via `--testNamePattern`
- **Cloud Pipeline Execution**: All tests execute through the cloud pipeline
- **Console Output Capture**: Test outputs are captured and displayed
- **Cross-Platform Support**: Works on Windows and Unix systems

## 🚀 Usage

### Running Tests

```bash
# Run all tests
npx jest

# Run a specific test
npx jest --testNamePattern="math calculations"

# List all tests
npx jest --listTests
```

### VS Code Integration

1. **Test Explorer**: Open the Test Explorer panel in VS Code
2. **Run Tests**: Click the play button next to any test or test suite
3. **Debug Tests**: Use the debug button for debugging support
4. **View Output**: Console output appears in the Console section

## 📁 Key Files

- `scripts/js/jest-runner.js` - Custom Jest runner for cloud execution
- `scripts/js/jest-transformer.js` - TypeScript transformer for Jest
- `scripts/shell/test-with-output.sh` - Shell script for cloud test execution
- `jest.config.js` - Jest configuration with custom runner
- `.vscode/settings.json` - VS Code Jest extension settings

## 🔧 Architecture

1. **Jest Discovery**: Jest discovers tests using the custom transformer
2. **Cloud Execution**: The custom runner executes tests via shell scripts
3. **Output Parsing**: Test outputs are parsed and mapped back to individual tests
4. **VS Code Display**: Results are displayed in the VS Code Test Explorer

## ⚡ Performance

- **Test Discovery**: Near-instant using TypeScript AST parsing
- **Cloud Execution**: ~10-15 seconds per test run (includes build + upload)
- **Output Processing**: Real-time parsing and mapping

## 🛠️ Troubleshooting

### Tests Not Appearing

- Ensure Jest extension is enabled
- Check that `jest.config.js` points to the correct runner
- Verify test files match the `testMatch` pattern

### Console Output Issues

- Console output appears in the main Console section
- Individual test output may not show in VS Code due to extension limitations
- Use command line execution for detailed output debugging

### Cloud Pipeline Errors

- Check `test-output.log` for detailed error information
- Verify shell scripts have proper permissions
- Ensure all dependencies are installed (`npm install`)

## 📚 Dependencies

- `@rbxts/jest-globals` - Jest globals for Roblox-TS
- `@rbxts/compiler-types` - TypeScript compiler types
- `ts-jest` - TypeScript support for Jest
- Node.js and npm for local execution
