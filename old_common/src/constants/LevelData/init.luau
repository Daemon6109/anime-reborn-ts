--// Stores data for levels
--// By @ThatOneTusk

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)


type LevelReferenceType = {
	RequiredLevels: number;
	Callback: (Level: number) -> RewardLibrary.RewardType;
}


local LevelData = {}

local CachedData: {[number]: RewardLibrary.RewardType?} = {}

local Reference: {LevelReferenceType} = { -- A reference to procedurally generate Level Rewards, every amount of levels will run the given function. Checks in descending order. Example: 50 must be before 40
										  -- Levels required is checked by Player Level % Required Levels	
										  
	[1] = {
		RequiredLevels = 50;
		
		Callback = function()
			return {
				Items = {
					["TraitCrystal"] = 25;
				}
			}
		end,
	};
	
	[2] = {
		RequiredLevels = 25;

		Callback = function()
			return {
				Items = {
					["PotentialKey"] = 10;
					["FrostKey"] = 3;
				}
			}
		end,
	};
	
	[3] = {
		RequiredLevels = 10;

		Callback = function()
			return {
				Currencies = {
					Gems = 50;
					Gold = 200;
				}
			}
		end,
	};
	
	[4] = {
		RequiredLevels = 5;

		Callback = function(Level)
			local RandomObject = Random.new(Level)
			local ItemPool = {}
			
			for _, itemObject in ReplicatedStorage.Registry.Items:GetChildren() do
				if not itemObject:IsA("ModuleScript") then continue end
				
				local name, item = itemObject.Name, require(itemObject)
				
				if not table.find(item.configuration.Sort, "Food") then continue end
				
				if Level > 40 then
					if item.configuration.Rarity == "Mythical" then
						table.insert(ItemPool, name)
					end
				elseif item.configuration.Rarity == "Rare" then
					table.insert(ItemPool, name)
				end
			end
			
			if not next(ItemPool) then
				return {
					Currencies = {
						Gems = 25;
						Gold = 100;
					}
				}
			end
			
			local ChosenItem = ItemPool[RandomObject:NextInteger(1, #ItemPool)]
			
			return {
				Items = {
					[ChosenItem] = 5
				}
			}
		end,
	};
	
	[5] = {
		RequiredLevels = 1;

		Callback = function()
			return {
				Currencies = {
					Gems = 25;
					Gold = 100;
				}
			}
		end,
	};
}


function LevelData:GetRewardsForLevel(Level: number): RewardLibrary.RewardType
	Level = tonumber(Level)
	
	if CachedData[Level] then
		return CachedData[Level]
	end
	
	for _, LevelReference in ipairs(Reference) do
		if Level % LevelReference.RequiredLevels == 0 then
			CachedData[Level] = LevelReference.Callback(Level)
			
			return CachedData[Level]
		end
	end
end

return LevelData