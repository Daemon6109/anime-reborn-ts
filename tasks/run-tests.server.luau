local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- TEST_PATTERN will be injected here by the Python script when filtering is needed
local TEST_PATTERN = nil

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

-- Define all the places to test with their correct folder structures
-- Note: Currently only testing Common place in cloud to avoid Jest runtime conflicts
-- Local Jest testing covers all places comprehensively
local places = {
	{
		name = "Common",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("Common"),
		enabled = true, -- Always test Common place for cloud validation
	},
	-- Disabled for cloud testing due to Jest runtime conflicts
	-- All places are still tested locally via npm run test:jest
	--[[
	{
		name = "Gameplay",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("Gameplay")
			:FindFirstChild("gameplay")
			:FindFirstChild("src"),
		enabled = false,
	},
	{
		name = "Lobby",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("Lobby")
			:FindFirstChild("lobby")
			:FindFirstChild("src"),
		enabled = false,
	},
	{
		name = "AFK",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("AFK")
			:FindFirstChild("afk")
			:FindFirstChild("src"),
		enabled = false,
	},
	--]]
}

local totalFailedTests = 0
local totalFailedTestSuites = 0
local totalPassedTests = 0
local totalTestSuites = 0

print("🧪 Running cloud tests for enabled places...")
print("💡 Note: Only Common place tested in cloud to avoid Jest runtime conflicts")
print("🔍 All places are tested locally via 'npm run test:jest'")
print("=" .. string.rep("=", 50))

-- Run tests for each enabled place
for _, place in ipairs(places) do
	if place.folder and (place.enabled == nil or place.enabled == true) then
		print("\n🏢 Running tests for " .. place.name .. "...")
		print("-" .. string.rep("-", 30))

		-- Build Jest options for this place (optimized for cloud execution)
		local jestOptions = {
			verbose = true,
			ci = true, -- Non-interactive mode for cloud
			forceExit = true, -- Force exit after completion
			runInBand = true, -- Sequential execution to avoid conflicts
			testTimeout = 30000, -- 30 second timeout per test
			bail = 1, -- Exit on first failure to prevent hanging
		}

		-- Check if TEST_PATTERN was injected and add it to Jest options
		if TEST_PATTERN then
			print("🔍 Filtering tests with pattern: " .. TEST_PATTERN)
			jestOptions.testNamePattern = TEST_PATTERN
		end

		-- Run tests for this specific place
		local status, result = runCLI(place.folder, jestOptions, { place.folder }):awaitStatus()

		if status == "Rejected" then
			print("❌ Error running tests for " .. place.name .. ": " .. tostring(result))
			totalFailedTestSuites = totalFailedTestSuites + 1
		elseif status == "Resolved" then
			-- Accumulate results
			if result.results then
				totalFailedTests = totalFailedTests + (result.results.numFailedTests or 0)
				totalFailedTestSuites = totalFailedTestSuites + (result.results.numFailedTestSuites or 0)
				totalPassedTests = totalPassedTests + (result.results.numPassedTests or 0)
				totalTestSuites = totalTestSuites + (result.results.numTestSuites or 0)

				if result.results.numFailedTests > 0 or result.results.numFailedTestSuites > 0 then
					print("❌ " .. place.name .. " tests failed!")
				else
					print("✅ " .. place.name .. " tests passed!")
				end
			end
		end
	else
		print("⚠️  " .. place.name .. " folder not found, skipping...")
	end
end

print("\n" .. "=" .. string.rep("=", 50))
print("📊 Test Summary:")
print("Total Test Suites: " .. totalTestSuites)
print("Total Passed Tests: " .. totalPassedTests)
print("Total Failed Tests: " .. totalFailedTests)
print("Total Failed Test Suites: " .. totalFailedTestSuites)

if totalFailedTests == 0 and totalFailedTestSuites == 0 then
	print("🎉 All tests passed!")
	if processServiceExists then
		ProcessService:ExitAsync(0)
	end
else
	print("💥 Some tests failed!")
	if processServiceExists then
		ProcessService:ExitAsync(1)
	end
end

return nil
