--------------------------------------------------------------------------------
-- collision
--------------------------------------------------------------------------------

local version = { major = 1, minor = 0, patch = 0 }

local PhysicsService = game:GetService("PhysicsService")

-- Collision group name
local COLLISION_GROUP = "GeneralCollisions"

--[=[
   Collision management system for handling physics interactions.

   @class Collision
]=]
local Collision = {
	version = version,
}

--[=[
   Initializes the collision system

   @within Collision

   ```lua
   Collision.init()
   ```
]=]
function Collision.init(): ()
	-- Register collision group
	PhysicsService:RegisterCollisionGroup(COLLISION_GROUP)
	PhysicsService:CollisionGroupSetCollidable(COLLISION_GROUP, COLLISION_GROUP, false)

	-- Set collision group for all unit parts
	local units = game.ReplicatedStorage:FindFirstChild("Units")
	if units then
		for _, descendant in pairs(units:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CollisionGroup = COLLISION_GROUP
			end
		end
	end
end

--[=[
   Sets up collision for a character when they join

   @within Collision

   @param player Player -- The player whose character joined
   @param character Model -- The character model

   ```lua
   Collision.onCharacterAdded(player, character)
   ```
]=]
function Collision.onCharacterAdded(player: Player, character: Model): ()
	for _, descendant in pairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CollisionGroup = COLLISION_GROUP
		end
	end
end

return Collision
