-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = TS.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
Flamework._addPaths({ { "ReplicatedStorage", "rbxts_include", "node_modules", "Project", "afk", "src", "client", "components" } })
Flamework._addPaths({ { "ReplicatedStorage", "rbxts_include", "node_modules", "Project", "afk", "src", "client", "controllers" } })
Flamework._addPaths({ { "ReplicatedStorage", "rbxts_include", "node_modules", "Project", "afk", "src", "shared", "components" } })
Flamework.ignite()
