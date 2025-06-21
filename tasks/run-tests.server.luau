local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- TEST_PATTERN will be injected here by the Python script when filtering is needed

local runCLI = require(
	ReplicatedStorage:FindFirstChild("rbxts_include")
		:FindFirstChild("node_modules")
		:FindFirstChild("@rbxts")
		:FindFirstChild("jest")
		:FindFirstChild("src")
).runCLI

local processServiceExists, ProcessService = pcall(function()
-- Roblox does not have a ProcessService; use BindToClose for exit handling
local function exitAsync(code)
	-- In Roblox cloud, you can't exit the process, but you can use BindToClose for cleanup
	if typeof(code) == "number" then
		-- Optionally log or handle exit code
	end
end
-- Build Jest options
local jestOptions = {
	verbose = false,
	ci = false,
}

-- Check if TEST_PATTERN was injected and add it to Jest options
if TEST_PATTERN then
	print("🔍 Filtering tests with pattern: " .. TEST_PATTERN)
	jestOptions.testNamePattern = TEST_PATTERN
end

local status, result = runCLI(
	ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project"):FindFirstChild("Common"),
	jestOptions,
	{ ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project"):FindFirstChild("Common"), 
	ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project"):FindFirstChild("Gameplay"), 
	ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project"):FindFirstChild("Lobby"), 
	ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project"):FindFirstChild("AFK")  
  }
):awaitStatus()

if status == "Rejected" then
	print(result)
end

if status == "Resolved" and result.results.numFailedTestSuites == 0 and result.results.numFailedTests == 0 then
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
end

if processServiceExists then
	ProcessService:ExitAsync(1)
end

return nilif totalFailedTests == 0 and totalFailedTestSuites == 0 then
	print("🎉 All tests passed!")
	exitAsync(0)
else
	print("💥 Some tests failed!")
	exitAsync(1)
end
