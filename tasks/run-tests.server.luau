local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- TEST_PATTERN will be injected here by the Python script when filtering is needed
local TEST_PATTERN = nil
-- SINGLE_PLACE will be injected here when running a single place
local SINGLE_PLACE = nil

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

-- Force single place execution to avoid runtime conflicts
if SINGLE_PLACE then
	local filteredPlaces = {}
	for _, place in ipairs(places) do
		if place.name == SINGLE_PLACE then
			table.insert(filteredPlaces, place)
			break
		end
	end
	places = filteredPlaces

	if #places == 0 then
		print("❌ Error: SINGLE_PLACE '" .. SINGLE_PLACE .. "' not found!")
		if processServiceExists then
			ProcessService:ExitAsync(1)
		end
		return nil
	end
else
	-- If no SINGLE_PLACE specified, default to running only the first place
	-- This prevents runtime conflicts - use shell script to run all places
	print("⚠️  No SINGLE_PLACE specified, running only " .. places[1].name)
	print("⚠️  To run all places, use the shell script which will call this multiple times")
	places = { places[1] }
end

local totalFailedTests = 0
local totalFailedTestSuites = 0
local totalPassedTests = 0
local totalTestSuites = 0

print("🧪 Running tests for " .. (#places > 1 and "all places" or places[1].name) .. "...")
print("=" .. string.rep("=", 50))

-- Get Jest runtime once for this execution
local runCLI = require(
	ReplicatedStorage:FindFirstChild("rbxts_include")
		:FindFirstChild("node_modules")
		:FindFirstChild("@rbxts")
		:FindFirstChild("jest")
		:FindFirstChild("src")
).runCLI

-- Run tests for each place (should only be one if SINGLE_PLACE is used properly)
for i, place in ipairs(places) do
	if place.folder then
		print("\n🏢 Running tests for " .. place.name .. " (" .. i .. "/" .. #places .. ")...")
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

		print("✅ Completed " .. place.name .. " tests")
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
