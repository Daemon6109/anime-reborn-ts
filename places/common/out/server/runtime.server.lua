-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
Flamework._addPaths({ { "ReplicatedStorage", "TS_Cl", "components" } })
Flamework._addPaths({ { "ReplicatedStorage", "TS_Cl", "controllers" } })
Flamework._addPaths({ { "ReplicatedStorage", "TS_Shared", "components" } })
Flamework.ignite()
