local JestGlobals = require(
	game.ReplicatedStorage
		:FindFirstChild("rbxts_include")
		:FindFirstChild("node_modules")
		:FindFirstChild("@rbxts")
		:FindFirstChild("jest-globals")
		:FindFirstChild("src")
)
-- local jest = JestGlobals.jest
-- local expect = JestGlobals.expect
local afterEach = JestGlobals.afterEach

-- expect.extend({
-- 	newMatcher = function(self, received, expected)
-- 		-- ...
-- 	end)
-- })

afterEach(function()
	for index, _ in _G do
		pcall(function()
			if index:IsA("ModuleScript") then
				_G[index] = nil
			end
		end)
	end
	print("🧹 Cleaned up global module scripts")
	print(_G)
end)
