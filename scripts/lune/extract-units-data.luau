--!nolint
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local placeFile = fs.readFile("reborn  lobbby.rbxl")
local game = roblox.deserializePlace(placeFile)

local UnitRegistryFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("Units")

for _, entry in pairs(UnitRegistryFolder) do
	if entry:IsA("ModuleScript") then
		local scriptSource = entry.Source
	end
end
