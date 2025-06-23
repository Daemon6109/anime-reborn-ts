# Blink Documentation

This document provides instructions on how to use Blink, a tool for generating networking code for Roblox games. It is intended to be a comprehensive guide for developers, and also to be easily understandable by AI assistants to help with development.

## 1. Introduction to Blink

Blink is a powerful tool that simplifies network communication in Roblox games. It uses a custom definition language (in `.blink` files) to define data structures, events, and functions. From these definitions, Blink generates optimized Luau code for both the server and the client, as well as TypeScript type definitions.

**Key Features:**

- **Strongly Typed:** Define your network interface with a rich type system.
- **Efficient:** Generates optimized code for serialization and deserialization, reducing network overhead.
- **Organized:** Use scopes and imports to structure your network definitions across multiple files.
- **Flexible:** Supports various event calling conventions (sync, async, polling) and function yielding mechanisms (coroutines, promises, futures).
- **Cross-platform:** Can be used via a command-line interface (CLI) or a Roblox Studio plugin.

## 2. Getting Started

This guide will walk you through creating and using your first Blink network description. This guide is aimed towards CLI users, but the syntax applies to the Studio plugin as well.

### Writing Your First Network Description

Blink's language is simple. Create a file named `mynetwork.blink` and add the following content:

```blink
-- These options specify the output paths for the generated files.
-- They can be ignored if you are using the Studio plugin.
option ClientOutput = "src/client/network.luau"
option ServerOutput = "src/server/network.luau"
option TypesOutput = "src/types/network.luau"

-- Define a simple event that sends a string from the server to the client.
event MyFirstEvent {
    From: Server,
    Type: Reliable,
    Call: SingleSync,
    Data: string
}
```

### Compiling Your Network Description

Open a terminal in the directory where you created your file and run the following command:

```sh
blink mynetwork
```

This will generate three Luau files: `src/client/network.luau`, `src/server/network.luau`, and `src/types/network.luau`. You can now use these files in your project.

### Using The Generated Code

Blink generates a table with all your events and functions. You can use this table to connect to and fire events.

**Server-side script (`someservercript.server.luau`):**

```lua
-- require the generated server module
local Net = require(game.ServerScriptService.src.server.network)

-- Fire the event for all players
Net.MyFirstEvent.FireAll("Hello World from the server!")
```

**Client-side script (`someclientscript.client.luau`):**

```lua
-- require the generated client module
local Net = require(game.ReplicatedStorage.src.client.network)

-- Listen for the event from the server
Net.MyFirstEvent.On(function(message)
    print(message) -- "Hello World from the server!"
end)
```

## 3. Language Reference

This section provides a detailed reference for the `.blink` definition language.

### Options

Options configure the output of Blink and are placed at the top of a source file.

`option [OPTION] = [VALUE]`

**Available Options:**

- `Casing`: Controls the casing of generated method names.
    - Values: `Pascal` (default), `Camel`, `Snake`.
    - Example: `option Casing = Camel`
- `ServerOutput`, `ClientOutput`, `TypesOutput`: Specify the output file paths.
    - Example: `option ServerOutput = "../Network/Server.luau"`
- `Typescript`: If `true`, generates `.d.ts` files alongside Luau files.
    - Default: `false`.
    - Example: `option Typescript = true`
- `UsePolling`: If `true`, all events will have a polling API (`.Iter()`).
    - Default: `false`.
- `FutureLibrary`, `PromiseLibrary`: Path to the Future and Promise libraries for function yielding.
    - Example: `option PromiseLibrary = "ReplicatedStorage.Packages.Promise"`
- `SyncValidation`: If `true`, Blink checks if a sync call yielded.
    - Default: `false`.
- `WriteValidations`: If `true`, Blink validates types when firing an event or invoking a function. Useful for debugging, but may impact performance.
    - Default: `false`.
- `ManualReplication`: If `true`, disables automatic event replication and exposes a `StepReplication` function for manual control.
    - Default: `false`.
- `RemoteScope`: Adds a prefix to the generated `RemoteEvent` names to avoid conflicts when using Blink in packages.
    - Example: `option RemoteScope = "MyPackage"`

### Scopes

Scopes allow you to group related types, events, and functions.

```blink
scope MyScope {
    type MyType = u8
    event MyEvent { ... }
}

-- Usage
struct Example {
    Reference = MyScope.MyType
}
```

In Luau, scoped items are accessed through a nested table: `Blink.MyScope.MyEvent`. Luau types are prefixed with the scope name: `Blink.MyScope_MyType`.

### Imports

Imports allow you to split your Blink configuration into multiple files. The imported file's contents are placed into a new scope.

```blink
-- import ./common.blink into a scope named "common"
import "./common"

-- import ./external.blink into a scope named "Shared"
import "./external" as "Shared"

type MyType = common.SomeType
type OtherType = Shared.AnotherType
```

### Types

Blink supports a rich set of types for data serialization.

#### Ranges

Ranges constrain the values of numbers, strings, arrays, and buffers.

- Full range: `0..100`
- Half range (minimum): `0..`
- Half range (maximum): `..100`
- Exact value: `100`

#### Numbers

- **Unsigned Integers**: `u8`, `u16`, `u32`
- **Signed Integers**: `i8`, `i16`, `i32`
- **Floating Points**: `f16`, `f32`, `f64`

Numbers can be bounded with ranges: `type Health = u8(0..100)`.

#### `string`

A sequence of characters. Can be bounded by length: `type Username = string(3..20)`.

#### `boolean`

A `true` or `false` value.

#### `buffer`

A raw byte buffer for custom data. Can be bounded by length: `buffer(..900)`.

#### `vector`

A 3D vector. Can be bounded by magnitude: `vector(0..1)`. The encoding number type can be specified: `vector<i16>`.

#### `CFrame`

A CFrame. Encoding for position and rotation can be specified: `CFrame<i16, f16>`.

#### Optionals

Any type can be made optional by appending a `?`: `type OptionalHealth = u8?`.

#### Arrays

A list of homogeneous types. Defined with `[]`. Can be bounded by length.

`type Scores = f64[]`
`type PlayerIds = f64[1..50]`

#### Maps

Key-value pairs. Can be bounded by the number of elements.

`map UserIdToUsername = { [f64]: string }`
`map Inventory = { [string]: u32 }(..100)`

Maps also support generics: `map Map<K, V> = {[K]: V}`.

#### Sets

A map of static string keys to `true`.

`set Flags = { FeatureA, FeatureB }`

#### Enums

- **Unit Enums**: A set of named values.
  `type CharacterState = enum { Idle, Walk, Run }`
- **Tagged Enums**: A set of variants, each with associated data. This is a powerful way to create unions.
    ```blink
    enum InputEvent = "Type" {
        KeyPress { Key: string },
        MouseMove { Position: vector }
    }
    ```

Enums also support generics.

#### Structs

A collection of named fields with their own types.

```blink
struct PlayerData {
    Health: u8(0..100),
    Position: vector
}
```

Structs can merge other structs and support generics.

#### `Instance`

A Roblox instance. Can be narrowed by class: `type MyPart = Instance(Part)`. Always mark instances as optional (`?`) if they might not exist on the receiving end to prevent errors.

#### Other Roblox Types

Blink also supports `BrickColor`, `Color3`, `DateTime`, `DateTimeMillis`.

#### `unknown`

Represents a value whose type is not known at compile time. Uses Roblox's default serialization, which is less efficient. Use sparingly.

### Exports

You can export `Read` and `Write` functions for a type to handle serialization/deserialization manually.

`export struct MyData { field: u8 }`

This generates `Blink.MyData.Write(data)` and `Blink.MyData.Read(buffer)`.

### Events

Events are used for one-way communication between the server and client.

```blink
event PlayerJoined {
    From: Server,      -- Server or Client
    Type: Reliable,    -- Reliable or Unreliable
    Call: ManySync,    -- SingleSync, ManySync, SingleAsync, ManyAsync, Polling
    Data: (f64, string) -- Data payload (can be a single type or a type pack)
}
```

- **`From`**: The origin of the event.
- **`Type`**: Reliability of the event. `Unreliable` events are faster but may not arrive.
- **`Call`**: The listener API on the receiving end. `Sync` listeners cannot yield. `Async` listeners can. `Polling` provides an iterator.
- **`Data`**: The data to be sent. Can be a single type, a type pack `(type1, type2)`, or omitted.

### Functions

Functions are used for two-way communication (request/response), initiated by the client.

```blink
function GetPlayerData {
    Yield: Coroutine, -- Coroutine, Future, or Promise
    Data: f64,        -- Data from client to server (PlayerId)
    Return: PlayerData -- Data from server to client
}
```

- **`Yield`**: The yielding mechanism for the client-side call.
- **`Data`**: The arguments passed from the client.
- **`Return`**: The value returned from the server.

## 4. Luau API Usage

Blink generates Luau modules with a simple API to interact with your network definitions.

### Firing Events

- **From Server:**
    - `Net.MyEvent.Fire(player, data)`
    - `Net.MyEvent.FireAll(data)`
    - `Net.MyEvent.FireList(players, data)`
    - `Net.MyEvent.FireExcept(player, data)`
- **From Client:**
    - `Net.MyEvent.Fire(data)`

### Listening to Events

```lua
-- On the receiving end
local connection = Net.MyEvent.On(function(player, data)
    -- ... (player argument is only present on the server)
end)

-- To disconnect the listener
connection:Disconnect()
```

### Iterating Polling Events

If an event has `Call: Polling`, you can iterate through incoming events.

```lua
for _, player, data in Net.MyPollingEvent.Iter() do
    -- ... (player argument is only present on the server)
end
```

### Invoking Functions (Client)

```lua
-- Coroutine
local result = Net.MyFunction.Invoke(arg1, arg2)

-- Future
local future = Net.MyFunction.Invoke(arg1, arg2)
local result = future:Await()

-- Promise
local promise = Net.MyFunction.Invoke(arg1, arg2)
local result = promise:await()
```

### Handling Function Calls (Server)

```lua
Net.MyFunction.On(function(player, arg1, arg2)
    -- ... process request ...
    return result
end)
```

## 5. Command-Line Usage

The Blink CLI is used to compile `.blink` files.

- **Compile a file:**
  `blink file-name` (looks for `file-name.blink` or `file-name.txt`)

- **Watch for changes:**
  `blink file-name --watch` (recompiles automatically when the file or its imports change)
