--// Template
-- NAME OF SCRIPT MUST BE A number

local Template = {
	Rewards = { -- i = NumberRange (ranks to give the prizes to (INCLUSIVE)), v = prizes, follows the template of the prize library
		
		[NumberRange.new(1,25)] = {
			Items = {
				TraitCrystal = 10;
			}
		}
	};
	
	LeaderboardSpecificRewards = { -- Optional, same format of the normal prizes. Specific leaderboards can have their own prizes, if this table isnt there, or if there isnt a leaderboard 
								   -- in this table, the normal prizes are given instead
									
		Gems = { -- leaderboard name
			-- format of the normal prizes
		}
	}
}

setmetatable(Template, {__index = require(game:GetService("ReplicatedStorage").Registry.LeaderboardData).Metadata})

return Template