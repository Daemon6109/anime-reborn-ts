local module = {}
local PhysicsService = game:GetService("PhysicsService")

function module:start()
	PhysicsService:RegisterCollisionGroup("GeneralCollisions")
	PhysicsService:CollisionGroupSetCollidable("GeneralCollisions", "GeneralCollisions", false)

	for i, v in pairs(game.ReplicatedStorage.Registry.Units:GetDescendants()) do
		if v:IsA("BasePart") or v:IsA("MeshPart") then
			v.CollisionGroup = "GeneralCollisions"
		end
	end
end

function module:characterAdded(player: Player, character: Model)
	for _, v in character:GetDescendants() do
		--print("set c group")
		if v:IsA("BasePart") then
			v.CollisionGroup = "GeneralCollisions"
		end
	end
end

return module
