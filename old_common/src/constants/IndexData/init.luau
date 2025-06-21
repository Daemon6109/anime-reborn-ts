--// Stores data for Index
--// By @ThatOneTusk

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RewardLibrary = require(ReplicatedStorage.Libs.RewardLibrary)

type LevelReferenceType = {
	RequiredLevels: number;
	Callback: (Level: number) -> RewardLibrary.RewardType?;
}


local IndexData = {
	XPData = {
		["Rare"] = 15,
		["Epic"] = 75,
		["Legendary"] = 600,
		["Mythical"] = 1500,
		["Secret"] = 3500,
		["Exclusive"] = 0,
		["Reborn"] = 0,
	}
}

local CachedData: {[number]: RewardLibrary.RewardType?} = {}

local Reference: {LevelReferenceType} = { -- A reference to procedurally generate Level Rewards, every amount of levels will run the given function. Checks in descending order. Example: 50 must be before 40
										  -- Levels required is checked by Player Level % Required Levels	
	
	[1] = {
		RequiredLevels = 35;

		Callback = function()
			return {
				Currencies = {
					Gems = 7500;
				};

				Items = {
					PotentialKey = 14;
				};
			}
		end,
	};
	
	[2] = {
		RequiredLevels = 34;

		Callback = function()
			return {
				Currencies = {
					Gems = 2900;
				};
			}
		end,
	};
	
	[3] = {
		RequiredLevels = 33;

		Callback = function()
			return {
				Currencies = {
					Gems = 2800;
				};

				Items = {
					FrostKey = 14;
				};
			}
		end,
	};
	
	[4] = {
		RequiredLevels = 32;

		Callback = function()
			return {
				Currencies = {
					Gems = 2700;
				};

				Items = {
					Redstone = 10;
				};
			}
		end,
	};
	
	[5] = {
		RequiredLevels = 31;

		Callback = function()
			return {
				Currencies = {
					Gems = 2600;
				};
			}
		end,
	};
	
	[6] = {
		RequiredLevels = 30;

		Callback = function()
			return {
				Currencies = {
					Gems = 2500;
				};

				Items = {
					PotentialKey = 12;
				};
			}
		end,
	};
	
	[7] = {
		RequiredLevels = 29;

		Callback = function()
			return {
				Currencies = {
					Gems = 2400;
				};
			}
		end,
	};
	
	[8] = {
		RequiredLevels = 28;

		Callback = function()
			return {
				Currencies = {
					Gems = 2300;
				};
			}
		end,
	};
	
	[9] = {
		RequiredLevels = 27;

		Callback = function()
			return {
				Currencies = {
					Gems = 2200;
				};

				Items = {
					FrostKey = 12;
				};
			}
		end,
	};
	
	[10] = {
		RequiredLevels = 26;

		Callback = function()
			return {
				Currencies = {
					Gems = 2100;
				};
			}
		end,
	};
	
	[11] = {
		RequiredLevels = 25;

		Callback = function()
			return {
				Currencies = {
					Gems = 2000;
				};

				Items = {
					PotentialKey = 10;
				};
			}
		end,
	};
	
	[12] = {
		RequiredLevels = 24;

		Callback = function()
			return {
				Currencies = {
					Gems = 1900;
				};
			}
		end,
	};
	
	[13] = {
		RequiredLevels = 23;

		Callback = function()
			return {
				Currencies = {
					Gems = 1800;
				};

				Items = {
					FrostKey = 10;
				};
			}
		end,
	};
	
	[14] = {
		RequiredLevels = 22;

		Callback = function()
			return {
				Currencies = {
					Gems = 1700;
				};

				Items = {
					Redstone = 8;
				};
			}
		end,
	};
	
	[15] = {
		RequiredLevels = 21;

		Callback = function()
			return {
				Currencies = {
					Gems = 1600;
				};
			}
		end,
	};
	
	[16] = {
		RequiredLevels = 20;

		Callback = function()
			return {
				Currencies = {
					Gems = 1500;
				};

				Items = {
					PotentialKey = 8;
				};
			}
		end,
	};
	
	[17] = {
		RequiredLevels = 19;

		Callback = function()
			return {
				Currencies = {
					Gems = 1400;
				};
			}
		end,
	};
	
	[18] = {
		RequiredLevels = 18;

		Callback = function()
			return {
				Currencies = {
					Gems = 1300;
				};
			}
		end,
	};
	
	[19] = {
		RequiredLevels = 17;

		Callback = function()
			return {
				Currencies = {
					Gems = 1200;
				};

				Items = {
					FrostKey = 8;
				};
			}
		end,
	};
	
	[20] = {
		RequiredLevels = 16;

		Callback = function()
			return {
				Currencies = {
					Gems = 1100;
				};
			}
		end,
	};
	
	[21] = {
		RequiredLevels = 15;

		Callback = function()
			return {
				Currencies = {
					Gems = 1000;
				};

				Items = {
					PotentialKey = 6;
				};
			}
		end,
	};
	
	[22] = {
		RequiredLevels = 14;

		Callback = function()
			return {
				Currencies = {
					Gems = 950;
				};
			}
		end,
	};
	
	[23] = {
		RequiredLevels = 13;

		Callback = function()
			return {
				Currencies = {
					Gems = 900;
				};

				Items = {
					FrostKey = 6;
				};
			}
		end,
	};
	
	[24] = {
		RequiredLevels = 12;

		Callback = function()
			return {
				Currencies = {
					Gems = 850;
				};

				Items = {
					Redstone = 6;
				};
			}
		end,
	};
	
	[25] = {
		RequiredLevels = 11;

		Callback = function()
			return {
				Currencies = {
					Gems = 750;
				};
			}
		end,
	};
	
	[26] = {
		RequiredLevels = 10;

		Callback = function()
			return {
				Currencies = {
					Gems = 650;
				};

				Items = {
					PotentialKey = 4;
				};
			}
		end,
	};
	
	[27] = {
		RequiredLevels = 9;

		Callback = function()
			return {
				Currencies = {
					Gems = 550;
				};
			}
		end,
	};
	
	[28] = {
		RequiredLevels = 8;

		Callback = function()
			return {
				Currencies = {
					Gems = 400;
				};

				Items = {
					FrostKey = 4;
				};
			}
		end,
	};
	
	[29] = {
		RequiredLevels = 7;

		Callback = function()
			return {
				Currencies = {
					Gems = 350;
				};

				Items = {
					Redstone = 4;
				};
			}
		end,
	};
	
	[30] = {
		RequiredLevels = 6;

		Callback = function()
			return {
				Currencies = {
					Gems = 300;
				};
			}
		end,
	};
	
	[31] = {
		RequiredLevels = 5;

		Callback = function()
			return {
				Currencies = {
					Gems = 250;
				};

				Items = {
					PotentialKey = 2;
				};
			}
		end,
	};
	
	[32] = {
		RequiredLevels = 4;

		Callback = function()
			return {
				Currencies = {
					Gems = 200;
				};

				Items = {
					FrostKey = 2;
				};
			}
		end,
	};
	
	[33] = {
		RequiredLevels = 3;

		Callback = function()
			return {
				Currencies = {
					Gems = 150;
				};

				Items = {
					Redstone = 2;
				};
			}
		end,
	};
	
	[34] = {
		RequiredLevels = 2;

		Callback = function()
			return {
				Currencies = {
					Gems = 100;
				};
			}
		end,
	};
	
	[35] = {
		RequiredLevels = 1;

		Callback = function()
			return {
				Currencies = {
					Gems = 50;
				}
			}
		end,
	};
}


function IndexData:GetRewardsForLevel(Level: number): RewardLibrary.RewardType
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

return IndexData