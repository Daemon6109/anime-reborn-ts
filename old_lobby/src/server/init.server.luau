local Framework = require("@pkgs/framework")

local ServerScriptService = game:GetService("ServerScriptService")

Framework:add(script:GetChildren())
Framework:add(ServerScriptService.CommonProviders:GetChildren())
Framework:init({
	Profiling = true,
})
