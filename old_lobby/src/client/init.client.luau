local Framework = require("@pkgs/framework")

Framework:add(script:GetChildren())
Framework:init({
	Profiling = true,
})
