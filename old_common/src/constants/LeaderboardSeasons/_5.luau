local module = {
	Rewards = {

		[NumberRange.new(1,10)] = {
			Items = {
				TraitCrystal = 250;
			};
			
			Titles = {"Top 10"};
			
			Currencies = {
				Gems = 10000
			};
			
			ShinyUnits = {
				["Levi"] = 1;		
			};
		};
		
		[NumberRange.new(11,25)] = {
			Items = {
				TraitCrystal = 100;
			};

			Titles = {"Top 25"};

			Currencies = {
				Gems = 5000
			};
			
			Units = {
				["Levi"] = 1;
			};

			ShinyUnits = {};
		};
		
		[NumberRange.new(26,50)] = {
			Items = {
				TraitCrystal = 50;
			};

			Titles = {"Top 50"};

			Currencies = {
				Gems = 2000
			};
			
			Units = {};
		};
		
		[NumberRange.new(51,100)] = {
			Items = {
				TraitCrystal = 25;
			};

			Titles = {"Top 100"};

			Currencies = {
				Gems = 1000
			};

			Units = {};
		};
	};
}

setmetatable(module, {__index = require(game:GetService("ReplicatedStorage").Registry.LeaderboardData).Metadata})

return module
