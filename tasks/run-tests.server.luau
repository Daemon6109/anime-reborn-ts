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
	return game:GetService("ProcessService")
end)

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
	ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project"),
	jestOptions,
	{ ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("Project") }
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

return nil
