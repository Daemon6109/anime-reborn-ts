# Vide Documentation

This document provides a comprehensive guide to Vide, a declarative and reactive UI library for Roblox. It is designed to be easily understood by both developers and AI assistants.

## 1. Introduction to Vide

Vide is a library that allows you to build user interfaces in a declarative way, inspired by modern web frameworks like SolidJS. Instead of manually creating, updating, and destroying UI instances, you describe what the UI _should_ look like based on your application's state. Vide handles the rest, automatically updating the UI when the state changes.

**Key Concepts:**

- **Declarative:** You define your UI as a tree of components. You don't write the step-by-step instructions to manipulate the UI.
- **Reactive:** The UI automatically updates when the underlying data (state) changes. This is achieved through a fine-grained reactivity system.
- **Component-Based:** You build your UI by composing small, reusable functions called components.

## 2. Core Concepts

### 2.1. Reactivity: The `source`, `effect`, and `derive` Triad

Vide's reactivity is built on three fundamental functions:

- **`source(initialValue)`**: Creates a reactive state container. A source is a function that you call to get its value, and you call it with an argument to set its value.

    ```lua
    local count = vide.source(0)

    print(count()) -- Get the value: prints 0
    count(1)       -- Set the value
    print(count()) -- prints 1
    ```

- **`effect(fn)`**: Creates a reactive scope that automatically re-runs a function whenever a source it reads from is updated.

    ```lua
    local count = vide.source(0)

    vide.effect(function()
        -- This effect depends on `count`
        print("The count is:", count())
    end)
    --> The count is: 0

    count(1) --> The count is: 1
    count(2) --> The count is: 2
    ```

- **`derive(fn)`**: Creates a new, read-only source whose value is computed from other sources. The derived source updates automatically whenever its dependencies change.

    ```lua
    local firstName = vide.source("John")
    local lastName = vide.source("Doe")

    local fullName = vide.derive(function()
        return firstName() .. " " .. lastName()
    end)

    print(fullName()) --> John Doe

    firstName("Jane")
    print(fullName()) --> Jane Doe
    ```

### 2.2. Scopes and Lifetime Management

Vide code runs within **scopes**, which control the lifetime of reactive elements. When a scope is destroyed, all effects, derived sources, and other reactive elements created within it are also destroyed and cleaned up.

- **`root(fn)`**: Creates a top-level, non-reactive (**STABLE**) scope. This is the entry point for most Vide applications. It returns a `destructor` function that you can call to clean up everything created inside the scope.

    ```lua
    local destructor = vide.root(function()
        -- All your reactive code goes here
        local count = vide.source(0)
        vide.effect(function() print(count()) end)
    end)

    -- To clean up and stop all effects:
    destructor()
    ```

- **`cleanup(fn)`**: Schedules a function to be called when the current scope is destroyed or re-runs.

### 2.3. Components as Functions

In Vide, a component is simply a Luau function that returns a Roblox Instance. You compose components by calling them within other components.

```lua
local function MyButton(props)
    return vide.create("TextButton")({
        Name = "MyButton",
        Text = props.Text,
        Size = UDim2.fromOffset(100, 30),
        Activated = props.OnClick
    })
end

local function App()
    return vide.create("ScreenGui")({
        MyButton({ Text = "Click Me!", OnClick = function() print("Clicked!") end })
    })
end

-- To mount the App to the screen:
vide.mount(App, game.Players.LocalPlayer.PlayerGui)
```

## 3. API Reference

### 3.1. Core Reactivity

- `source(initialValue)`: Creates a readable/writable reactive value.
- `effect(fn)`: Runs `fn` and re-runs it when its dependencies change.
- `derive(fn)`: Creates a read-only source computed from other sources.
- `root(fn)`: Creates a top-level stable scope.
- `cleanup(fn)`: Schedules a cleanup function for the current scope.
- `untrack(fn)`: Runs `fn` without tracking its dependencies in the current reactive scope.
- `batch(fn)`: Batches multiple source updates, running effects only once after the function completes.

### 3.2. Element Creation & Mounting

- `create(className | instance)`: Creates a function to build UI elements. Takes a class name string or an instance to clone.
- `mount(component, target?)`: Mounts a component to a target instance. If no target is provided, it runs the component in a new root scope.
- `action(fn, priority?)`: Creates a custom action to be run on an instance during creation.
- `changed(propertyName, fn)`: A helper action that runs a function when a specific instance property changes.

### 3.3. Dynamic UI (Conditional & List Rendering)

- `show(source, component, fallback?)`: Shows `component` if `source` is truthy, otherwise shows `fallback` (if provided).
- `switch(source)`: Returns a function that takes a map of keys to components. It renders the component corresponding to the current value of `source`.
- `indexes(source, transform)`: For rendering lists. It maps each **index** of the `source` table to a UI element. Use this when the position in the list is important.
- `values(source, transform)`: For rendering lists. It maps each **value** of the `source` table to a UI element. Use this when the identity of the object is important, regardless of its position.

### 3.4. Animation

- `spring(source, period?, dampingRatio?)`: Creates a new source that smoothly animates towards the value of the input `source` using spring physics.
    - **Returns:** A tuple of `(valueSource, configFn)`.
        - `valueSource`: A read-only source for the current animated value.
        - `configFn`: A function to instantly set the spring's `position`, `velocity`, or apply an `impulse`.
    - **`period`**: The time in seconds for one undamped oscillation.
    - **`dampingRatio`**: The amount of resistance.
        - `> 1`: Overdamped (slowly reaches target).
        - `= 1`: Critically damped (reaches target quickly without overshoot).
        - `< 1`: Underdamped (overshoots and oscillates).
        - `= 0`: Undamped (oscillates forever).

### 3.5. State Management

- `context(defaultValue)`: Creates a context object for providing data deep down a component tree without passing props manually.

## 4. Strict Mode

Vide includes a strict mode to help you catch common errors during development.

`vide.strict = true`

Strict mode is **enabled by default** in development environments (i.e., when not running at O2 optimization level in Roblox). It is automatically disabled in production to maximize performance.

**Strict mode checks for:**

- Accidental yielding within reactive scopes.
- Ensuring computations are pure by running them twice.
- Improper usage of `indexes()` and `values()`.
- And provides better error reporting and stack traces.

It is highly recommended to develop with strict mode enabled.

## 5. Important Rules

- **NO YIELDING IN SCOPES:** You **cannot** use yielding functions (like `task.wait()` or `:WaitForChild()`) inside any reactive or stable scope created by Vide (`effect`, `derive`, `root`, etc.). Doing so will break the reactive graph. Strict mode will throw an error if you do this.
