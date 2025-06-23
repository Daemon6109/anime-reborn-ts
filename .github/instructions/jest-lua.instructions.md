# Jest-Lua: Powerful Testing for Luau

Jest-Lua is a modern testing framework for Luau, inspired by the popular JavaScript testing library, Jest. It provides a familiar, expressive API for writing clear, maintainable, and robust tests for your Roblox projects.

This guide provides a comprehensive overview of Jest-Lua, from initial setup to advanced features. It is intended for both developers new to testing and those familiar with Jest in other environments.

## 1. Getting Started

### Installation

Install Jest-Lua into your project using Wally:

**wally.toml**

```toml
[dev-dependencies]
Jest = "jsdotlua/jest@3.10.0"
JestGlobals = "jsdotlua/jest-globals@3.10.0"
```

### Configuration

Create a `jest.config.lua` file in your source directory. This file tells Jest-Lua where to find your tests.

**jest.config.lua**

```lua
-- Find all files ending in .spec.lua or .test.lua inside a __tests__ folder
return {
  testMatch = { "**/__tests__/**/*.spec.lua", "**/__tests__/**/*.test.lua" },
}
```

> See the [Configuration](#configuration) section for more options.

### Writing Your First Test

Create a test file (e.g., `MyModule.spec.lua`) and use the functions exported by `JestGlobals` to write your tests.

**MyModule.spec.lua**

```lua
local JestGlobals = require("@DevPackages/JestGlobals")
local describe = JestGlobals.describe
local it = JestGlobals.it
local expect = JestGlobals.expect

local function sum(a, b)
  return a + b
end

describe("sum", function()
  it("should add two numbers correctly", function()
    expect(sum(1, 2)).toBe(3)
  end)
end)
```

> **Important:** Unlike older versions or other frameworks, Jest-Lua v3+ requires you to explicitly `require` all global functions like `describe`, `it`, and `expect`.

### Running Tests

The main entry point for running tests is `runCLI` from the `Jest` package. Create a bootstrap script (e.g., `spec.lua` or `run-tests.lua`) to configure and execute your test run.

**run-tests.lua**

```lua
local ProjectRoot = script.Parent -- Or your project's root Instance
local runCLI = require("@DevPackages/Jest").runCLI

-- Run tests and get the result
local result = runCLI(ProjectRoot, {
  -- CLI options, e.g., verbose = true
}, { ProjectRoot }):await()

-- Exit with a specific code for CI environments
if game:GetService("ProcessService") then
  local success = result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0
  game:GetService("ProcessService"):ExitAsync(success and 0 or 1)
end
```

You will also need to enable the `EnableLoadModule` fast flag in your Roblox Studio `ClientAppSettings.json` file.

## 2. Core Concepts

### Test Structure

- `describe(name, fn)`: Creates a block that groups together several related tests.
- `it(name, fn)` or `test(name, fn)`: The individual test case.
- `.only`: Run only this test or describe block within the file. `describe.only(...)`, `it.only(...)`.
- `.skip`: Skip this test or describe block. `describe.skip(...)`, `it.skip(...)`.

> **Note:** `.only` and `.skip` only affect the file they are in. To run a single test file, use configuration options like `testMatch`.

### Assertions with `expect`

The `expect` function is used every time you want to test a value. You will almost always use it with a "matcher" function to assert something about a value.

```lua
expect(myValue).toBe(true)
```

### Common Matchers

Here are some of the most frequently used matchers.

- `expect(a).toBe(b)`: Checks for strict equality (using `==`).
- `expect(a).toEqual(b)`: Performs a deep, recursive comparison of two tables.
- `expect(value).toBeTruthy()`: Passes if the value is not `false` or `nil`.
- `expect(value).toBeFalsy()`: Passes if the value is `false` or `nil`.
- `expect(tbl).toContain(item)`: Checks if an item is in an array-like table.
- `expect(str).toContain(substring)`: Checks if a string contains a substring.
- `expect(fn).toThrow(optionalMessage)`: Checks if a function throws an error when called.

> **Deviation:** To negate a matcher, use `.never` instead of `.not`. For example: `expect(1).never.toBe(2)`.

### Setup and Teardown

Jest-Lua provides helper functions to run code before or after tests.

- `beforeEach(fn)` / `afterEach(fn)`: Run before/after each test in a `describe` block.
- `beforeAll(fn)` / `afterAll(fn)`: Run once before/after all tests in a `describe` block.

This is useful for cleaning up state between tests to ensure they are isolated.

## 3. Advanced Features

### Mocking

Mocking allows you to replace dependencies with controlled fakes, making tests simpler and more reliable.

#### `jest.fn()`: Mock Functions

`jest.fn()` creates a mock object that can be used as a function or a callable table. It captures calls, parameters, and return values.

**Deviation:** `jest.fn()` returns two values:

1.  `mock`: A callable table that is the mock object itself.
2.  `mockFn`: A forwarding function that calls the mock. Use this when the code under test requires a real `function` type.

```lua
local jest = require("@DevPackages/JestGlobals").jest

local mock, mockFn = jest.fn()
mock.mockReturnValue(42)

-- Use mockFn if a real function is needed
someFunctionThatNeedsACallback(mockFn)

-- Assertions
expect(mock).toHaveBeenCalled()
expect(mock).toHaveBeenCalledWith("some argument")
expect(mock.mock.results[1].value).toBe(42)
```

#### `jest.spyOn()`: Spying on Methods

`jest.spyOn(table, "methodName")` creates a mock function that also calls through to the original implementation. This is useful for asserting that a method was called without fully replacing it.

```lua
local MyModule = {
  doSomething = function() print("Original implementation") end
}

local spy = jest.spyOn(MyModule, "doSomething")
MyModule.doSomething()

expect(spy).toHaveBeenCalled()

-- Restore the original implementation
spy:mockRestore()
```

#### `jest.globalEnv`: Mocking Globals (Roblox-only)

You can mock global functions like `print` or libraries like `math` by spying on `jest.globalEnv`.

```lua
-- Mock math.random to be deterministic
local mockRandom = jest.spyOn(jest.globalEnv.math, "random")
mockRandom.mockReturnValue(0.5)

expect(math.random()).toBe(0.5)

mockRandom:mockRestore()
```

### Snapshot Testing

Snapshot tests are a way to track changes in large data structures or UI components over time. On the first run, a snapshot file is created. On subsequent runs, the output is compared to the saved snapshot.

```lua
it("should render correctly", function()
  local component = renderComponent()
  expect(component).toMatchSnapshot()
end)
```

If a change is intentional, you can update the snapshot. To do this, run your tests with the `UPDATESNAPSHOT` global set to `"true"`.

#### Property Matchers

For dynamic data like IDs or dates, use property matchers to avoid snapshot failures on every run.

```lua
expect({
  createdAt = DateTime.now(),
  id = math.random(),
  name = "Test"
}).toEqual({
  createdAt = expect.any("DateTime"),
  id = expect.any("number"),
  name = "Test"
})
```

### Timer Mocks

Isolate tests from real-time dependencies like `task.delay` or `os.time`.

- `jest.useFakeTimers()`: Enables fake timers.
- `jest.runAllTimers()`: Executes all pending timers immediately.
- `jest.advanceTimersByTime(ms)`: Advances timers by a specific duration.
- `jest.runOnlyPendingTimers()`: Runs only currently pending timers (useful for recursive timers).
- `jest.useRealTimers()`: Restores real timers.

```lua
jest.useFakeTimers()

it("calls a callback after 1 second", function()
  local callback = jest.fn()
  timerGame(callback)

  expect(callback).never.toBeCalled()
  jest.runAllTimers()
  expect(callback).toBeCalled()
end)
```

#### Roblox Engine Frame Time

To more accurately simulate the Roblox engine's task scheduler, you can set the frame time.

```lua
-- Simulate 60 FPS
jest.setEngineFrameTime(1000/60)
```

## 4. Configuration

Configure Jest-Lua by creating a `jest.config.lua` file in your project's root or relevant sub-directory.

- `testMatch: {string}`: Glob patterns for discovering test files.
- `testPathIgnorePatterns: {string}`: Glob patterns for files to ignore.
- `setupFilesAfterEnv: {string}`: A list of scripts to run after the test framework is installed in the environment, but before tests run. Useful for setting up custom matchers.
- `projects: {Instance}`: For multi-package repositories, an array of Instances pointing to sub-projects that have their own configuration.

> **Note:** All paths are matched against the path of the test in the Roblox datamodel, not the filesystem path.

## 5. Key Deviations from Jest.js

If you're coming from JavaScript, here are the main differences in Jest-Lua:

| Feature             | Jest.js (JavaScript)                                    | Jest-Lua (Luau)                                                                  |
| :------------------ | :------------------------------------------------------ | :------------------------------------------------------------------------------- |
| **Negation**        | `.not`                                                  | `.never`                                                                         |
| **Mock Functions**  | `jest.fn()` returns a single mock function.             | `jest.fn()` returns `mock, mockFn` (a callable table and a forwarding function). |
| **`test.each`**     | Uses tagged template literals.                          | Uses a list of tables or an array of arrays.                                     |
| **Type Checking**   | `expect.any(Number)`                                    | `expect.any("number")` (uses a string for primitive types).                      |
| **Falsiness**       | `0`, `""`, `false`, `null`, `undefined` are falsy.      | Only `false` and `nil` are falsy. `.toBeFalsy()` reflects this.                  |
| **`toHaveLength`**  | Works on strings, arrays, and arguments.                | Uses the `#` operator. Does not work for function arguments.                     |
| **Global Mocks**    | Requires manual setup or helper libraries.              | Built-in via `jest.globalEnv`.                                                   |
| **`toStrictEqual`** | Checks for `undefined` properties and array sparseness. | Checks type/class via metatables, but not `undefined` or sparseness.             |

## 6. Migration Guides

### Migrating from TestEZ

1.  **Dependencies:** Replace `TestEZ` with `Jest` and `JestGlobals` in your `wally.toml`.
2.  **Imports:** You must now explicitly `require` globals like `describe`, `it`, and `expect` from `@DevPackages/JestGlobals`.
3.  **Matchers:** TestEZ matchers have Jest-Lua equivalents.
    - `expect(v).to.equal(x)` -> `expect(v).toBe(x)` (strict equality)
    - `expect(v).to.be.ok()` -> `expect(v).never.toBeNil()` or `expect(v).toBeTruthy()`
    - `expect(v).to.be.near(x)` -> `expect(v).toBeCloseTo(x)`
    - `expect(v).to.be.a("type")` -> `expect(v).toEqual(expect.any("type"))`
    - `expect(fn).to.throw()` -> `expect(fn).toThrow()`

### Migrating from Jest-Lua v2.x to v3.x

1.  **Entry Point:** The test runner is now invoked via `Jest.runCLI(...)` instead of `TestEZ.TestBootStrap:run`. Update your bootstrap script.
2.  **Configuration:** Jest-Lua v3 requires a `jest.config.lua` file.
3.  **Test Files:**
    - Test files no longer need to return a function. You can write your `describe` and `it` blocks at the top level.
    - All globals (`describe`, `it`, `test`, `expect`, `jest`) must be explicitly required from `JestGlobals`. They are no longer injected into the environment.
4.  **`.only` and `.skip`:** These operators now only apply to the file they are in, not the entire test run. Use `testMatch` or `testNamePattern` CLI options to filter runs.
5.  **State Sharing:** State can no longer be passed from the bootstrap script into test files. Each test file runs in its own environment. Use `require` to import shared dependencies or `setupFilesAfterEnv` for shared setup code.
