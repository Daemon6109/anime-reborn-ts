# Copilot AI Prompt for Lyra DataStore Library

Use this prompt to guide GitHub Copilot (or similar AI assistants) when working with the Lyra DataStore library in Roblox Lua.

---

## 1. Import & Setup

- Require Lyra at the top:

    ```lua
    local Lyra = require(path.to.Lyra)
    ```

- Create a store with:
    - `name`: unique string identifier
    - `template`: table defining default data shape
    - `schema`: `t.strictInterface` matching the template
    - Optional:
        - `migrationSteps`: list of `Lyra.MigrationStep.*`
        - `importLegacyData(key)`: function for migrating existing data

```lua
local store = Lyra.createPlayerStore({
  name = "PlayerData",
  template = { coins = 0, inventory = {} },
  schema = t.strictInterface({ coins = t.number, inventory = t.table }),
  migrationSteps = { /* ... */ },
  importLegacyData = function(key) /* ... */ end,
})
```

## 2. Player Session Lifecycle

- **Player joins** → `store:loadAsync(player)`
- **Player leaves** → `store:unloadAsync(player)`
- **Game shutdown** →

    ```lua
    game:BindToClose(function()
      store:closeAsync()
    end)
    ```

## 3. Reading & Writing Data

- **Never** store data returned from `getAsync` for later use.
- Always modify through `updateAsync`:

    ```lua
    store:updateAsync(player, function(data)
      -- mutate `data`
      return true   -- commit
      -- or return false  -- abort
    end)
    ```

- Do not yield inside the update function.

## 4. Transactions (Atomic Multi‑Player Ops)

- Use `txAsync` for trades or any multi‑player update:

    ```lua
    store:txAsync({player1, player2}, function(state)
      -- modify state[playerX]
      return true  -- commit all
    end)
    ```

## 5. Data Migrations

- **Append only**: never edit, reorder, or remove published migrations.
- **Add fields**:

    ```lua
    Lyra.MigrationStep.addFields("addGems", { gems = 0 })
    ```

- **Transform data**:

    ```lua
    Lyra.MigrationStep.transform("renameInv", function(data)
      data.items = data.inventory
      data.inventory = nil
      return data
    end)
    ```

- Ensure final data matches your schema.

## 6. Change Callbacks & Networking

- Register callbacks during store creation:

    ```lua
    local function syncWithClient(key, newData, oldData)
      -- compare old vs. new, fire RemoteEvent
    end

    local store = Lyra.createPlayerStore({
      changedCallbacks = { syncWithClient },
      -- ...
    })
    ```

## 7. Debugging & Logging

- Provide `logCallback(message)`:

    ```lua
    local function handleLogs(message)
      print("[Lyra]["..message.level.."] "..message.message)
    end

    local store = Lyra.createPlayerStore({ logCallback = handleLogs, ... })
    ```

- In Studio: show all logs; in production: filter to `error` and `fatal`.

## 8. Best Practices

- **Lyra is the single source of truth**; do not mirror persistent state elsewhere.
- Always validate data against your schema.
- Use auto‑sharding for large datasets.
- For ProcessReceipt, wrap purchases in `updateAsync`, then `saveAsync`.

---

_Keep this file at the root of your module or in a central `/docs` folder so Copilot can detect it and suggest context‑aware completions._

---

## 9. Roblox‑TS (TypeScript) Usage

If you’re using the `@rbxts/lyra` fork with roblox-ts, mirror the Lua patterns in TS:

```ts
import { t } from "@rbxts/t";
import Lyra from "@rbxts/lyra";
import { Players } from "@rbxts/services";

const store = Lyra.createPlayerStore({
	name: "PlayerData",
	template: { coins: 0, inventory: {} },
	schema: t.strictInterface({ coins: t.number, inventory: t.table }),
	// Optional migrationSteps, importLegacyData, changedCallbacks, logCallback
});

// Player lifecycle
Players.PlayerAdded.Connect((player) => store.loadAsync(player));
Players.PlayerRemoving.Connect((player) => store.unloadAsync(player));

// Cleanup on shutdown
game.BindToClose(() => store.closeAsync());

// Updating data
store.updateAsync(player, (data) => {
	data.coins += 100;
	return true;
});

// Transactions
store.txAsync([player1, player2], (state) => {
	const amt = 50;
	state.get(player1).coins -= amt;
	state.get(player2).coins += amt;
	return true;
});
```

> **Note:** The roblox‑ts fork is community maintained by `@6ixfalls`. Review its source and typings; support via the roblox-ts Discord.

---

## 10. Resources & Further Reading

- **@rbxts/lyra on npm**
  [https://www.npmjs.com/package/@rbxts/lyra](https://www.npmjs.com/package/@rbxts/lyra)
  Official npm package for the roblox-ts fork, including version info, installation instructions, and release notes.

- **Lyra Official Docs**
  [https://paradoxum-games.github.io/lyra/docs/intro/](https://paradoxum-games.github.io/lyra/docs/intro/)
  Paradoxum Games’ in‑depth documentation for the Luau version: API reference, migration guides, and advanced features.")}]}
