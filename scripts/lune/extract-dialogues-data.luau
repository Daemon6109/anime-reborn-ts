--!nolint
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")

-- Load the place file
local placeFile = fs.readFile("reborn  lobbby.rbxl")
local game = roblox.deserializePlace(placeFile)

-- Get the Dialogues registry folder
local DialogueRegistryFolder =
	game:GetService("ReplicatedStorage"):FindFirstChild("Registry"):FindFirstChild("Dialogues")

if not DialogueRegistryFolder then
	error("Dialogues folder not found in Registry!")
end

-- Collect all dialogue data
local dialoguesData = {}
local totalProcessed = 0
local successCount = 0

-- Function to find matching closing brace accounting for nested braces, strings, and comments
local function findMatchingBrace(source, startPos)
	local braceCount = 1
	local inString = false
	local stringChar = nil
	local i = startPos + 1

	while i <= #source do
		local char = string.sub(source, i, i)

		if inString then
			if char == "\\" then
				i = i + 2 -- Skip this and the next character
				continue
			elseif char == stringChar then
				inString = false
			end
		else
			local nextChar = string.sub(source, i + 1, i + 1)
			if char == "-" and nextChar == "-" then
				-- Skip comment
				local endIndex = string.find(source, "\n", i)
				if endIndex then
					i = endIndex
				else
					i = #source + 1 -- end of string
				end
				continue
			elseif char == '"' or char == "'" or char == "`" then
				inString = true
				stringChar = char
			elseif char == "{" then
				braceCount = braceCount + 1
			elseif char == "}" then
				braceCount = braceCount - 1
				if braceCount == 0 then
					return i
				end
			end
		end
		i = i + 1
	end
	return nil
end

local function parseTree(treeContent)
	local treeData = {}
	-- Use non-greedy match for text to avoid consuming the whole string if it contains quotes
	treeData.Text = (
		treeContent:match('Text%s*=%s*"(.-)"')
		or treeContent:match("Text%s*=%s*'(.-)'")
		or treeContent:match("Text%s*=%s*`([^`]*)`")
	)
	local waitTime = treeContent:match("WaitTime%s*=%s*(%d+)")
	if waitTime then
		treeData.WaitTime = tonumber(waitTime)
	end

	-- Extract responses
	local responsesStartIndex = string.find(treeContent, "Responses%s*=%s*{")
	if responsesStartIndex then
		local responsesOpenBrace = string.find(treeContent, "{", responsesStartIndex)
		if responsesOpenBrace then
			local responsesCloseBrace = findMatchingBrace(treeContent, responsesOpenBrace)
			if responsesCloseBrace then
				local responsesTableContent = string.sub(treeContent, responsesOpenBrace + 1, responsesCloseBrace - 1)

				local responses = {}
				local i = 1
				while true do
					local rStartIndex = string.find(responsesTableContent, "%[%d+%]%s*=%s*{", i)
					if not rStartIndex then
						break
					end

					local responseIndex = responsesTableContent:match("%[(%d+)%]", rStartIndex)
					local rOpenBrace = string.find(responsesTableContent, "{", rStartIndex)
					if not rOpenBrace then
						break
					end
					local rCloseBrace = findMatchingBrace(responsesTableContent, rOpenBrace)

					if not rCloseBrace then
						break
					end

					local responseContent = string.sub(responsesTableContent, rOpenBrace + 1, rCloseBrace - 1)

					local responseData = {}
					responseData.Text = responseContent:match('Text%s*=%s*"(.-)"')
						or responseContent:match("Text%s*=%s*'(.-)'")
					local responsePush = responseContent:match("Push%s*=%s*(%d+)")
					if responsePush then
						responseData.Push = tonumber(responsePush)
					end
					local buttonColor = responseContent:match("ButtonColor%s*=%s*'(.-)'")
					if buttonColor then
						responseData.ButtonColor = buttonColor
					end

					if responseIndex then
						responses[tonumber(responseIndex)] = responseData
					end

					i = rCloseBrace + 1
				end
				treeData.Responses = responses
			end
		end
	else
		local push = treeContent:match("Push%s*=%s*(%d+)")
		if push then
			treeData.Push = tonumber(push)
		end
	end

	return treeData
end

local function parseDialogue(source)
	local data = {}

	-- Extract top-level properties
	data.Name = source:match('OwnerName%s*=%s*"(.-)"') or source:match("OwnerName%s*=%s*'(.-)'")
	data.PlayerID = 0
	data.Animation = 0

	local bannerColor = source:match("BannerColor%s*=%s*Color3.fromRGB%((.-)%)")
	if bannerColor then
		data.BannerColor = "Color3.fromRGB(" .. bannerColor .. ")"
	end

	-- Extract dialogue trees
	local trees = {}
	local i = 1
	while true do
		local startIndex = string.find(source, "%[%d+%]%s*=%s*{", i)
		if not startIndex then
			break
		end

		local treeIndex = source:match("%[(%d+)%]", startIndex)
		local openBrace = string.find(source, "{", startIndex)
		if not openBrace then
			break
		end

		local closeBrace = findMatchingBrace(source, openBrace)
		if not closeBrace then
			print(
				"[WARNING] Could not find matching brace for tree "
					.. (treeIndex or "unknown")
					.. " starting at "
					.. openBrace
					.. " in dialogue "
					.. (data.Name or "unknown")
			)
			break
		end

		local treeContent = string.sub(source, openBrace, closeBrace)

		if treeIndex then
			local success, treeData = pcall(parseTree, treeContent)
			if success and treeData then
				trees[tonumber(treeIndex)] = treeData
			else
				print(
					"[WARNING] Failed to parse tree "
						.. treeIndex
						.. " in dialogue "
						.. (data.Name or "unknown")
						.. ": "
						.. tostring(treeData)
				)
			end
		end

		i = closeBrace + 1
	end
	data.Trees = trees

	return data
end

local function parseConditionalDialogue(source)
	local data = {}
	local conditionalTrees = {}

	-- Extract base properties from the first dialogue table found
	local dialogueName = source:match('OwnerName%s*=%s*"(.-)"') or source:match("OwnerName%s*=%s*'(.-)'")
	data.Name = dialogueName
	data.PlayerID = 0
	data.Animation = 0
	local bannerColor = source:match("BannerColor%s*=%s*Color3.fromRGB%((.-)%)")
	if bannerColor then
		data.BannerColor = "Color3.fromRGB(" .. bannerColor .. ")"
	end

	-- Find all dialogue tables (Claimed, Decline, etc.)
	local i = 1
	while i <= #source do
		-- Pattern to find "local <var> = {" or "<var> = {"
		local _, endP, condition = source:find("local%s+(%w+)%s*=%s*{", i)
		if not endP then
			_, endP, condition = source:find("(%w+)%s*=%s*{", i)
		end

		if not endP then
			break -- No more matches
		end

		local openBrace = endP
		local closeBrace = findMatchingBrace(source, openBrace)

		if not closeBrace then
			-- This could happen with malformed source, prevent infinite loop
			i = endP + 1
			print(
				"[WARNING] Could not find matching brace for condition "
					.. (condition or "unknown")
					.. " starting at "
					.. openBrace
			)
			continue
		end

		local content = source:sub(openBrace, closeBrace)

		-- A simple heuristic to check if this is a dialogue table
		if content:find("OwnerName") then
			local success, treeData = pcall(parseDialogue, "return " .. content)
			if success and treeData and next(treeData.Trees) ~= nil then
				conditionalTrees[condition] = treeData.Trees
			else
				print(
					"[WARNING] Failed to parse conditional tree "
						.. condition
						.. " in dialogue "
						.. (dialogueName or "unknown")
				)
			end
		end

		i = closeBrace + 1
	end

	data.Trees = conditionalTrees
	return data
end

local function parseGetDialogue(source)
	local data = {}
	-- Extract the content of the table returned by GetDialogue
	local dialogueContent = source:match("return%s*({(.-)});", 1)
	if not dialogueContent then
		-- Fallback for dialogues that define tables and then return them conditionally
		return parseConditionalDialogue(source)
	end

	-- To parse the Luau code statically, we need to remove or simplify
	-- any actual code logic.

	-- 1. Remove Callback functions entirely.
	dialogueContent = dialogueContent:gsub("Callback%s*=%s*function%(.-)end,", "")

	-- 2. Simplify conditional assignments.
	-- Replace any complex assignment to "Push" with a default value like 0.
	dialogueContent = dialogueContent:gsub("(Push%s*=%s*)[^,;]+", "%1 0")

	-- 3. Replace interpolated strings with simple empty strings.
	dialogueContent = dialogueContent:gsub("`[^`]*`", '""')

	-- Now, try to parse the cleaned-up string as a dialogue table.
	local success, dialogueData = pcall(parseDialogue, dialogueContent)
	if success and dialogueData then
		data = dialogueData
	else
		print("[WARNING] Failed to parse dialogue from return statement: " .. tostring(dialogueData))
	end

	return data
end

-- Collect all dialogue data
print("Starting to process dialogues...")

for _, dialogueEntry in pairs(DialogueRegistryFolder:GetChildren()) do
	if dialogueEntry:IsA("ModuleScript") then
		local dialogueName = dialogueEntry.Name
		local scriptSource = dialogueEntry.Source
		totalProcessed = totalProcessed + 1

		-- Check if the script uses the GetDialogue function
		if scriptSource:find("function%s+.-:GetDialogue()") then
			local success, data = pcall(parseGetDialogue, scriptSource)
			if success and data then
				dialoguesData[dialogueName] = data
				successCount = successCount + 1
			else
				print("[WARNING] Failed to parse conditional dialogue: " .. dialogueName .. "\n" .. tostring(data))
			end
		else
			local success, data = pcall(parseDialogue, scriptSource)
			if success and data then
				dialoguesData[dialogueName] = data
				successCount = successCount + 1
			else
				print("[WARNING] Failed to parse dialogue: " .. dialogueName .. "\n" .. tostring(data))
			end
		end
	end
end

print("Processing complete!")
print("Total dialogues processed: " .. totalProcessed)
print("Successfully parsed: " .. successCount)

-- Convert to JSON
local jsonString = serde.encode("json", dialoguesData, true)

-- Post-process to fix number formatting (remove .0 from integers)
jsonString = string.gsub(jsonString, "(%d+)%.0([,%s%}%]])", "%1%2")
-- Post-process to fix empty Trees tables for simple dialogues
jsonString = string.gsub(jsonString, '("Trees":)%s*{}', "%1 []")

-- Ensure the target directory exists
local targetDir = "places/common/src/shared/configuration"
if not fs.isDir(targetDir) then
	fs.writeDir(targetDir)
end

-- Write the JSON file
local jsonPath = targetDir .. "/dialogues-data.json"

if fs.isFile(jsonPath) then
	fs.removeFile(jsonPath)
	print("Deleted existing dialogues-data.json")
end

fs.writeFile(jsonPath, jsonString)

print("Dialogues data JSON written to: " .. jsonPath)
print("Extraction complete!")
