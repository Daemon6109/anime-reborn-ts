-- Compiled with roblox-ts v2.3.0
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local exports = {}
-- Data template types for the data service
-- This file defines the structure of player data
-- Re-export interfaces from the main data template
exports.DEFAULT_DATA_TEMPLATE = TS.import(script, game:GetService("ReplicatedStorage"), "TS_Shared", "data", "data-template").DATA_TEMPLATE
-- Re-export specific interfaces that might be used elsewhere
return exports
