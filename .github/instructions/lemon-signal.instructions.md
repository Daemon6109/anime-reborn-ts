# LemonSignal Documentation

This document provides a comprehensive guide to LemonSignal, a high-performance, pure Luau signal implementation. It is designed to be easily understood by both developers and AI assistants.

## 1. Introduction to LemonSignal

LemonSignal is a signal implementation written entirely in Luau, designed for high performance in any environment, including Roblox. It aims to be a superior replacement for existing solutions like `GoodSignal` and `BindableEvent` by offering significant performance improvements and powerful new features.

**Key Advantages:**

- **Performance:** Faster than most other signal implementations due to its use of a doubly linked list and innovative thread recycling.
- **Rich Feature Set:** Includes unique features like reconnecting disconnected connections and passing variadic arguments on connection.
- **Conventional API:** Follows the standard Roblox signal API, making it easy to swap in as a replacement for other signal libraries.
- **Pure Luau:** Works inside and outside of Roblox without any dependencies.

## 2. Getting Started

Using LemonSignal is straightforward. Here is a basic example:

```lua
local LemonSignal = require(Path.To.LemonSignal)

-- 1. Create a new signal
local signal = LemonSignal.new()

-- 2. Connect a function to the signal
local connection = signal:Connect(function(message)
    print("Received:", message)
end)

-- 3. Fire the signal
signal:Fire("Hello from LemonSignal!")
--> Received: Hello from LemonSignal!

-- 4. Disconnect the connection
connection:Disconnect()

-- This will no longer print anything
signal:Fire("This message will not be received.")
```

## 3. API Reference

### `LemonSignal.new() -> Signal`

Creates and returns a new signal object.

### `signal:Connect(callback: function, ...: any) -> Connection`

Connects a function (`callback`) to the signal. Any additional arguments passed to `:Connect` will be prepended to the arguments passed during `:Fire`. Returns a `Connection` object.

### `signal:Once(callback: function, ...: any) -> Connection`

Similar to `:Connect`, but the connection will automatically disconnect after being fired once.

### `signal:Fire(...: any)`

Fires the signal, calling all connected functions. Any arguments passed to `:Fire` will be passed to the connected functions.

### `connection:Disconnect()`

Permanently disconnects the connection from the signal.

### `connection:Reconnect() -> boolean`

Reconnects a previously disconnected connection. The original function passed to `:Connect` or `:Once` is reused. Returns `true` if reconnected successfully.

**Note:** A `:Once` connection that is reconnected will still only fire once before disconnecting again.

### `LemonSignal.wrap(rbxSignal: RBXScriptSignal) -> Signal`

Wraps a Roblox `RBXScriptSignal` (like from a `BindableEvent` or `RemoteEvent`) in a LemonSignal object. This allows you to use the LemonSignal API, such as `:Reconnect`, on native Roblox events.

```lua
local bindable = Instance.new("BindableEvent")
local wrappedSignal = LemonSignal.wrap(bindable.Event)

wrappedSignal:Connect(function(str)
    print("Wrapped:", str)
end)

bindable:Fire("signal")
--> Wrapped: signal
```

### `LemonSignal.is(value: any) -> boolean`

Checks if the given `value` is a LemonSignal object. This is a deviation from the standard Roblox-TS signal API.

### `connection.Connected: boolean`

A read-only property on a `Connection` object that is `true` if the connection is currently active.

## 4. Key Features Explained

### Variadic Connections

You can pass arguments directly to `:Connect` or `:Once`. These arguments will be passed to the callback function every time the signal is fired, _before_ any arguments from the `:Fire` call. This allows for clean, flyweight code design.

```lua
local function greet(greeting, name)
    print(greeting .. ", " .. name .. "!")
end

local signal = LemonSignal.new()

-- Pass "Hello" as the first argument to the greet function
signal:Connect(greet, "Hello")

signal:Fire("World")
--> Hello, World!

signal:Fire("Developer")
--> Hello, Developer!
```

### Reconnecting Connections

Unlike most signal implementations, LemonSignal allows you to reconnect a connection that has been disconnected. This avoids the need to create a new connection with a new function object.

```lua
local connection = signal:Connect(function() print("Connected!") end)
signal:Fire() --> Connected!

connection:Disconnect()
signal:Fire() -- (nothing happens)

connection:Reconnect()
signal:Fire() --> Connected!
```

## 5. Performance Deep Dive

LemonSignal's performance edge comes from two main optimizations: its underlying data structure and its thread recycling mechanism.

### Doubly Linked List Implementation

LemonSignal uses a doubly linked list to manage connections. This provides an excellent balance of performance characteristics:

- **Fast Iteration (`:Fire`)**: Firing events is as fast as using an array.
- **Fast Disconnection (`:Disconnect`)**: Disconnecting is an O(1) operation, which is much faster than the O(n) time required by singly linked lists.
- **Ordered Firing**: Events are fired in the order they were connected.

### Thread Recycling

When a connected function yields (e.g., uses `task.wait()`), signal implementations typically have to spawn a new thread for subsequent connections. LemonSignal improves on this by caching and recycling threads.

When a connection's callback is asynchronous, it might hold onto its thread. Instead of creating a new thread for the next async callback and discarding the old one, LemonSignal caches the thread once it's free. The next time an async callback needs a thread, it can reuse a cached one, which is significantly faster than creating a new one (~70% faster).

This provides a notable performance increase (around 33% in simulated benchmarks), especially in long-running games where async connections are common.

```lua
-- Other signal libraries might create two new threads here.
-- LemonSignal creates one, then recycles it for the third connection.
signal:Connect(function() print("sync") end)
signal:Connect(function() task.wait(); print("async") end)
signal:Connect(function() print("sync, but on a recycled thread") end)
signal:Fire()
```

## 6. Memory Usage

The thread recycling feature does use memory to cache threads. However, the impact is minimal. A thread is only created and cached when a free one isn't available for an asynchronous connection. The system quickly reaches an equilibrium where existing threads are recycled, and no new ones are created.

It would take over 100,000 cached threads to increase memory usage by approximately 100MB. A typical game will never create this many, so the performance benefits far outweigh the negligible memory cost.

## 7. Usage with Roblox-TS

LemonSignal provides full typing support for Roblox-TS.

You can define the type signature of the signal's payload in several ways:

```typescript
import Signal from "@rbxts/lemon-signal";

// Callback signature
const callbackSignal = new Signal<(foo: string, bar: number) => void>();
callbackSignal.Fire("hello", 123);

// Tuple signature
const tupleSignal = new Signal<[string, number]>();
tupleSignal.Fire("hello", 123);

// Single value signature
const valueSignal = new Signal<string>();
valueSignal.Fire("hello");

// No value (empty)
const emptySignal = new Signal(); // equivalent to Signal<() => void>
emptySignal.Fire();
```
