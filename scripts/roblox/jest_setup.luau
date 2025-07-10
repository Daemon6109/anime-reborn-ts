--!nolint

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local JestGlobals = require(
	ReplicatedStorage:FindFirstChild("rbxts_include")
		:FindFirstChild("node_modules")
		:FindFirstChild("@rbxts")
		:FindFirstChild("jest-globals")
		:FindFirstChild("src")
)

local afterEach = JestGlobals.afterEach

afterEach(function()
	for index, _ in _G do
		pcall(function()
			if index:IsA("ModuleScript") then
				_G[index] = nil
			end
		end)
	end
end)
