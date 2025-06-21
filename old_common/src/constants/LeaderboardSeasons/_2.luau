local module = {
	Rewards = {

		[NumberRange.new(1,10)] = {
			Items = {
				TraitCrystal = 250;
				ShinyDeltaCapsule = 1
			};
			
			Titles = {"Top 10"};
			
			Currencies = {
				Gems = 20000
			};
			
			ShinyUnits = {};
		};
		
		[NumberRange.new(11,25)] = {
			Items = {
				TraitCrystal = 150;
				ShinyDeltaCapsule = 1
			};

			Titles = {"Top 25"};

			Currencies = {
				Gems = 15000
			};

			ShinyUnits = {};
		};
		
		[NumberRange.new(26,50)] = {
			Items = {
				TraitCrystal = 75;
				DeltaCapsule = 1
			};

			Titles = {"Top 50"};

			Currencies = {};
			
			Units = {};
		};
		
		[NumberRange.new(51,100)] = {
			Items = {
				TraitCrystal = 50;
				DeltaCapsule = 1
			};

			Titles = {"Top 100"};

			Currencies = {
				Gems = 5000
			};

			Units = {};
		};
	};
}

setmetatable(module, {__index = require(game:GetService("ReplicatedStorage").Registry.LeaderboardData).Metadata})

return module
