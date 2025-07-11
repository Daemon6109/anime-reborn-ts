local module = {}
local DSS = game:GetService("DataStoreService")
local DataStore = DSS:GetDataStore("TeamEvent")
local RS = game:GetService("ReplicatedStorage")
local TeamEventFolder = RS.TeamEventCount

function module:Increment(Type: "Aliens" | "Spirits", Amount)
	local AliensSoulContent = 0
	local SpiritsSoulContent = 0

	local AddAliensSoulContent = 0
	local AddSpiritsSoulContent = 0

	if not Type or (Type == "Aliens") then
		if Type then
			AddAliensSoulContent += Amount
		end

		DataStore:UpdateAsync("Aliens", function(Value)
			AliensSoulContent = Value or AliensSoulContent
			AliensSoulContent += AddAliensSoulContent
			return AliensSoulContent
		end)
		TeamEventFolder:SetAttribute("Aliens", AliensSoulContent)
	end

	if not Type or (Type == "Spirits") then
		if Type then
			AddSpiritsSoulContent += Amount
		end

		DataStore:UpdateAsync("Spirits", function(Value)
			SpiritsSoulContent = Value or SpiritsSoulContent
			SpiritsSoulContent += AddSpiritsSoulContent
			return SpiritsSoulContent
		end)
		TeamEventFolder:SetAttribute("Spirits", SpiritsSoulContent)
	end
end

function module:start()
	local AliensSoulContent = DataStore:GetAsync("Aliens") or 0
	local SpiritsSoulContent = DataStore:GetAsync("Spirits") or 0
	--[[self:Increment()
	task.spawn(function()
		while task.wait(300) do
			self:Increment()
		end
	end)]]
end

return module
