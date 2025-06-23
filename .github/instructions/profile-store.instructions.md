# ProfileStore Documentation

This document provides a comprehensive guide to `ProfileStore`, a powerful Luau module for managing player data in Roblox. It is designed to be easily understood by both developers and AI assistants.

## 1. Introduction to ProfileStore

`ProfileStore` is a wrapper for Roblox's DataStore service that solves many common problems developers face, such as data loss, data corruption, and session locking. It provides a robust framework for handling player data safely and efficiently.

**Key Features:**

- **Session Locking:** Prevents multiple servers from writing to the same player data simultaneously, which is a primary cause of data corruption.
- **Data Protection:** Protects against data loss from server crashes or accidental overwrites by providing versioning and recovery mechanisms.
- **Failsafe Developer Product Handling:** Includes patterns for securely processing developer product purchases to ensure players always receive what they paid for.
- **Simple API:** Offers a high-level API that simplifies common data operations like loading, saving, and reconciling data structures.
- **Data Versioning:** Allows you to query and view the history of a player's data over time.

## 2. Installation

`ProfileStore` is a single `ModuleScript` that should be placed in a server-side location, such as `ServerScriptService`.

- **Option 1: Roblox Library (Recommended)**
    1.  Get the official model from the [Roblox Library](https://www.roblox.com/library/4969354295/ProfileStore).
    2.  Insert the model into your place and move the `ProfileStore` ModuleScript into `ServerScriptService`.

- **Option 2: GitHub**
    1.  Download the `ProfileStore.lua` file from the [official GitHub repository](https://github.com/loleris/ProfileStore).
    2.  Create a new `ModuleScript` in `ServerScriptService` and paste the contents of the file into it.

## 3. Getting Started: Basic Player Data

This example shows a standard implementation for loading and saving player data when they join and leave the game.

```lua
--!strict
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileStore = require(ServerScriptService.ProfileStore)

-- A template for new player profiles. When a player joins for the first time,
-- their data table will be populated with these default values.
local PROFILE_TEMPLATE = {
    Cash = 100,
    Items = {},
    Logins = 0,
}

-- Create a new ProfileStore for player data.
-- The first argument is a unique name for this data store.
-- The second argument is the template for new profiles.
local PlayerStore = ProfileStore.New("PlayerData", PROFILE_TEMPLATE)

-- A table to hold the loaded profiles of active players.
local Profiles: {[Player]: any} = {}

-- This function is called whenever a player is added to the game.
local function onPlayerAdded(player: Player)
    -- Start a session for this player's data.
    -- The key is typically the player's UserId.
    local profile = PlayerStore:StartSessionAsync(tostring(player.UserId))

    if profile then
        -- The profile has been successfully loaded.

        -- Add the player's UserId to the profile for GDPR compliance.
        profile:AddUserId(player.UserId)

        -- Reconcile the profile data. This adds any new fields from the
        -- PROFILE_TEMPLATE that are missing from the loaded data.
        -- This is useful for when you update your game and add new stats.
        profile:Reconcile()

        -- Listen for when the session ends.
        profile.OnSessionEnd:Connect(function()
            Profiles[player] = nil
            player:Kick("Your session has ended. Please rejoin.")
        end)

        -- Check if the player is still in the game before storing the profile.
        if player:IsDescendantOf(Players) then
            Profiles[player] = profile
            profile.Data.Logins += 1
            print(`Profile loaded for {player.DisplayName}! Logins: {profile.Data.Logins}`)
        else
            -- The player left before the profile could be loaded.
            profile:EndSession()
        end
    else
        -- The profile could not be loaded. This may happen if the DataStore
        -- service is down or if the server is shutting down.
        player:Kick("Failed to load your profile. Please rejoin.")
    end
end

-- This function is called whenever a player leaves the game.
local function onPlayerRemoving(player: Player)
    local profile = Profiles[player]
    if profile then
        -- End the session, which saves the data for the last time.
        profile:EndSession()
    end
end

-- Connect the functions to the player events.
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- In case some players joined before this script ran.
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(onPlayerAdded, player)
end
```

## 4. API Reference: `Profile` Object

A `Profile` object is returned by `ProfileStore:StartSessionAsync()` and represents a single player's data session.

### Properties

- `.Data: table`: The table containing the player's data. All changes made to this table will be saved.
- `.LastSavedData: table` (read-only): A copy of the data that was last successfully saved to the DataStore.
- `.Key: string` (read-only): The DataStore key for this profile.
- `.ProfileStore: ProfileStore` (read-only): A reference to the `ProfileStore` object that created this profile.
- `.UserIds: {number}` (read-only): A list of UserIds associated with this profile for GDPR compliance.
- `.FirstSessionTime: number` (read-only): A Unix timestamp of when the profile was first created.
- `.SessionLoadCount: number` (read-only): The number of times this profile has been loaded.

### Methods

- `:IsActive() -> boolean`: Returns `true` if the session is active and data can be saved. This can become `false` at any time (e.g., if the session is stolen by another server).
- `:Reconcile()`: Merges the `PROFILE_TEMPLATE` into `Profile.Data`, adding any missing fields.
- `:EndSession()`: Ends the current session, performs a final save, and releases the session lock.
- `:Save()`: Immediately queues a save of the `Profile.Data` to the DataStore. Use this for critical data changes, like after a product purchase.
- `:AddUserId(userId: number)`: Associates a UserId with the profile for GDPR compliance.
- `:RemoveUserId(userId: number)`: Disassociates a UserId from the profile.

### Signals

- `.OnSave`: Fires just before `Profile.Data` is saved.
- `.OnLastSave`: Fires just before the final save when a session is ending.
- `.OnSessionEnd`: Fires after the session has completely ended and data will no longer be saved.
- `.OnAfterSave`: Fires after data has been successfully saved to the DataStore.

## 5. Handling Developer Products

Handling developer product purchases correctly is critical. You must ensure that players receive their items even if a server crashes. `ProfileStore` enables a very robust pattern for this by caching purchase IDs.

This method is safer than the basic approach because it confirms the purchase has been saved to the DataStore before telling Roblox the transaction is complete.

```lua
--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

-- Assume `Profiles` table and `PlayerStore` are set up as in the basic example.
declare Profiles: {[Player]: any}

-- A map of Product IDs to functions that grant the item.
local ProductFunctions: {[number]: (receipt: any, player: Player, profile: any) -> ()} = {}

-- Example: A product that gives 100 Cash.
ProductFunctions[123456] = function(receipt, player, profile)
    profile.Data.Cash += 100
    -- No need to call profile:Save() here, the outer function handles it.
end

-- This function securely processes a purchase by caching the PurchaseId.
function PurchaseIdCheckAsync(profile: any, purchaseId: string, grantProduct: () -> ()): Enum.ProductPurchaseDecision
    if not profile:IsActive() then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    -- Initialize the cache if it doesn't exist.
    local purchaseIdCache = profile.Data.PurchaseIdCache
    if purchaseIdCache == nil then
        purchaseIdCache = {}
        profile.Data.PurchaseIdCache = purchaseIdCache
    end

    -- Grant the product if it hasn't been already.
    if not table.find(purchaseIdCache, purchaseId) then
        local success, err = pcall(grantProduct)
        if not success then
            warn(`Failed to grant product {purchaseId}: {err}`)
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end

        -- Add the purchase ID to the cache and trim the cache if it's too large.
        table.insert(purchaseIdCache, purchaseId)
        while #purchaseIdCache > 100 do
            table.remove(purchaseIdCache, 1)
        end
    end

    -- Now, wait until we can confirm the purchase ID has been saved to the DataStore.
    local function isPurchaseSaved()
        local savedCache = profile.LastSavedData.PurchaseIdCache
        return savedCache and table.find(savedCache, purchaseId)
    end

    if isPurchaseSaved() then
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end

    -- Force a save and wait for it to complete.
    while profile:IsActive() do
        local lastSaved = profile.LastSavedData
        profile:Save()

        -- Wait for the OnAfterSave signal if the save didn't happen instantly.
        if profile.LastSavedData == lastSaved then
            profile.OnAfterSave:Wait()
        end

        if isPurchaseSaved() then
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end

        -- Add a small delay before retrying to avoid busy-waiting.
        if profile:IsActive() then
            task.wait(2)
        end
    end

    -- The session ended before we could confirm the save.
    return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- The main ProcessReceipt callback.
local function processReceipt(receiptInfo: {[string]: any}): Enum.ProductPurchaseDecision
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    -- Wait for the player's profile to be loaded.
    local profile = Profiles[player]
    while not profile and player:IsDescendantOf(Players) do
        task.wait()
        profile = Profiles[player]
    end

    if profile then
        local productFunction = ProductFunctions[receiptInfo.ProductId]
        if not productFunction then
            warn(`No product function for ProductId {receiptInfo.ProductId}`)
            return Enum.ProductPurchaseDecision.NotProcessedYet
        end

        -- Call the secure processing function.
        return PurchaseIdCheckAsync(
            profile,
            receiptInfo.PurchaseId,
            function()
                productFunction(receiptInfo, player, profile)
            end
        )
    end

    return Enum.ProductPurchaseDecision.NotProcessedYet
end

MarketplaceService.ProcessReceipt = processReceipt
```

## 6. Troubleshooting

- **Studio Testing Issues:** By default, DataStores are not accessible in Studio. You must enable "Enable Studio Access to API Services" in Game Settings to test `ProfileStore` in Studio. Be aware this will write to your live game's DataStores.
- **Data Serialization Errors:** Roblox DataStores can only store certain types of data. You cannot save Instances, Vector3s, CFrames, functions, or tables with mixed key types (string and number). You must convert complex data to serializable formats (tables, strings, numbers, booleans) before saving.
- **Slow Profile Loading:** If profiles take a long time to load, it's often because a previous session was not ended correctly with `profile:EndSession()`. This forces `ProfileStore` to wait for the old session to time out before it can start a new one. Ensure you always call `:EndSession()` when a player leaves.

## 7. Appendix: DataStore API Usage

`ProfileStore` makes calls to the underlying DataStore and MessagingService APIs. Be aware of the following costs to avoid hitting Roblox API limits:

- **`:StartSessionAsync()`**: Typically 1 `:UpdateAsync()` call. If a session is active on another server, it will make repeated calls until the session is released or stolen.
- **Active Session**: 1 `:UpdateAsync()` call every 5 minutes for auto-saving.
- **`:EndSession()`**: 1 `:UpdateAsync()` call for the final save.
- **`:Save()`**: 1 `:UpdateAsync()` call.
- **`:GetAsync()`**: 1 `:GetAsync()` call.
- **`:RemoveAsync()`**: 1 `:RemoveAsync()` call.
