local SSS = game:GetService("ServerScriptService")
local DataAccess = require(SSS.ServerLibs.DataAccessAPI)
local DataAPI = DataAccess:GetAPI()
return {
	[1932432089] = {Type = 'Product',BuyLimit = 3,Giftable = true,Name = 'Starter Bundle',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 2500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 7500)

			local itemService = _G.serverServices.ItemManager
			-- Potential Keys
			itemService:GiveItems(Player, {["PotentialKey"]= 10})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 10})
		end,

		GradientName = "Mythical";
	},

	[1932432091] = {Type = 'Product',BuyLimit = 3,Giftable = true,Name = 'Mega Bundle',
		Callback = function(Player)
			print('Bought!')

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 3500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 12500)


			local itemService = _G.serverServices.ItemManager
			-- Redstone
			itemService:GiveItems(Player, {["Redstone"]= 10})

			-- Potential Keys
			itemService:GiveItems(Player, {["PotentialKey"]= 15})

			-- 15 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 15})
		end,

		GradientName = "Mythical";
	},

	[1932432090] = {Type = 'Product',BuyLimit = 3,Giftable = true,Name = 'Miracle Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 12500)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["PotentialKey"]= 25})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 200})
		end,

		GradientName = "Mythical";
	},



	--restock
	[2660696154] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Headstart Bundle',
		Callback = function(Player)
			print('Bought!')

			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Red Ticket", 12_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["DragonCapsule"]= 5})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 15})


		end,

		GradientName = "Mythical";
	},
	--restock
	[2660696155] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Strongest Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 750)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Red Ticket", 40_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["DragonCapsule"]= 10})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 75})
		end,

		GradientName = "Mythical";
	},
	--restock
	[2660696157] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'BEAST Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 2_500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Red Ticket", 75_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["DragonCapsule"]= 20})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 100})
		end,

		GradientName = "Mythical";
	},

	--restock
	[2660696156] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Glacier Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 15_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["FrostKey"]= 100})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 250})
		end,

		GradientName = "Mythical";
	},



	[2658905525] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Headstart Bundle',
		Callback = function(Player)
			print('Bought!')

			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Red Ticket", 12_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["DragonCapsule"]= 5})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 15})


		end,

		GradientName = "Mythical";
	},

	[2658299206] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Strongest Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 750)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Red Ticket", 40_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["DragonCapsule"]= 10})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 75})
		end,

		GradientName = "Mythical";
	},
	[2658299207] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'BEAST Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 2_500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Red Ticket", 75_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["DragonCapsule"]= 20})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 100})
		end,

		GradientName = "Mythical";
	},

	[2658299208] = {Type = 'Product',BuyLimit = 3,Giftable = true,Name = 'Glacier Bundle',
		Callback = function(Player)
			print('Bought!')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			local Currencies = PlayerProfileClass:GetField("Currencies")

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 15_000)
			local itemService = _G.serverServices.ItemManager

			-- Potential Keys
			itemService:GiveItems(Player, {["FrostKey"]= 100})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 300})
		end,

		GradientName = "Mythical";
	},
}