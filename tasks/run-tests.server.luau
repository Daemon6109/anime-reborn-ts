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

-- Define all the places to test
local places = {
	{
		name = "Common",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("Common"),
	},
	{
		name = "Gameplay",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("Gameplay"),
	},
	{
		name = "Lobby",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("Lobby"),
	},
	{
		name = "AFK",
		folder = ReplicatedStorage:FindFirstChild("rbxts_include")
			:FindFirstChild("node_modules")
			:FindFirstChild("Project")
			:FindFirstChild("AFK"),
	},
}

local totalFailedTests = 0
local totalFailedTestSuites = 0
local totalPassedTests = 0
local totalTestSuites = 0

print("🧪 Running tests for all places...")
print("=" .. string.rep("=", 50))

-- Run tests for each place
for _, place in ipairs(places) do
	if place.folder then
		print("\n🏢 Running tests for " .. place.name .. "...")
		print("-" .. string.rep("-", 30))

		-- Build Jest options for this place
		local jestOptions = {
			verbose = true,
			ci = false,
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
