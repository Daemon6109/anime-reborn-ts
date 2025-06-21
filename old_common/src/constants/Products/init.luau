export type ProductDataType = {
	Type: "Gamepass" | "Product"; -- if it's Gamepass, it'll run Callback when player joins the game
	BuyLimit: number?; -- The buy limit. MUST be 1 (IT DOES NOT DEFAULT) if it's a Gamepass. If none, no limit will be applied. Stores it in player.data.ProductsBought only if it exists
	
	Giftable: boolean?; -- Whether the product can be gifted or not
	Name: string; -- The name of the product
	
	Callback: (Player) -> ()?; -- Runs when bought, and when type is Gamepass and player joins the game
	RunOnceCallback: (Player) -> ()?; -- Runs only once when bought, useful for Gamepass
	GradientName: string?; -- Used for gifting 
	GradientColors: {Color3}?; -- Used for gifting  
	AlsoAward: number?
}

local SSS = game:GetService("ServerScriptService")
local DataAccess;
local DataAPI;
--local uiCommunication = game.ReplicatedStorage.Events.UiCommunication
--local UpdateTitleEvent = game.ReplicatedStorage.Events.UpdateTitleEvent

if game["Run Service"]:IsClient() then
	DataAccess = require(game.ReplicatedStorage.Libs.DataAccessAPIClient)
	DataAPI = DataAccess:GetAPI()
else
	local SSS = game:GetService("ServerScriptService")
	DataAccess = require(SSS.ServerLibs.DataAccessAPI)
	DataAPI = DataAccess:GetAPI()
end

local RunS = game:GetService('RunService')
--local TagsService = RunS:IsServer() and require(SSS.Services.TagsService)

return { -- Index is product id
	
	GetProductData = function(self, Player)
		local ProductData
		if Player == game.Players.LocalPlayer then
			local PlrProfileClass = DataAPI:GetLocalProfileClass()
			ProductData = PlrProfileClass:GetField("ProductsBought")
		else
			ProductData = DataAPI:GetPublicDataById(Player.UserId).ProductsBought
		end

		return ProductData
	end,
	
	-- Gamepasses
	[931258600] = {Type = 'Gamepass',BuyLimit = 1,Giftable = true,Name = 'Extra 50 Storage',
		RunOnceCallback = function(Player)
			warn('Deploying extra 50 storage')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			warn('Before',PlayerProfileClass:GetField("Inventory"))
			local Inventory = PlayerProfileClass:GetField("Inventory")
			local UnitStorage = Inventory.MaxUnitStorage
			UnitStorage +=50
			PlayerProfileClass:WriteDirectory("Inventory/MaxUnitStorage", UnitStorage, true)	
			warn('After',PlayerProfileClass:GetField("Inventory"))
		end,
		AlsoAward = 1932432112,
		GradientName = "Rare";
	},
	[931598388] = {Type = 'Gamepass',BuyLimit = 1,Giftable = true,Name = 'Shiny Hunter',
		AlsoAward = 1932432116,
		GradientName = "Mythical";
	},
	[887686872] = {Type = 'Gamepass',BuyLimit = 1,Giftable = true,Name = 'VIP',
		AlsoAward = 1932432115,
		GradientName = "Legendary";
		RunOnceCallback = function(Player)
			--TagsService:GiveTags(Player)
			
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			UpdateTitleEvent:FireAllClients(Player.Name,PlayerProfileClass:GetField('CurrentTitle'),true)
		end,
	},
	
	[931436143] = {Type = 'Gamepass',BuyLimit = 1,Giftable = true,Name = 'Display All Units',
		AlsoAward = 1932432113,
		GradientName = "Rare";
	},
	
	--// Gifting Gamepasses Devproducts
	[1932432112] = {Type = 'Product',BuyLimit = 1,Giftable = true,Name = 'Extra 50 Storage',
		Callback = function(Player)
			warn('Deploying extra 50 storage')
			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			warn('Before',PlayerProfileClass:GetField("Inventory"))
			local Inventory = PlayerProfileClass:GetField("Inventory")
			local UnitStorage = Inventory.MaxUnitStorage
			UnitStorage +=50
			PlayerProfileClass:WriteDirectory("Inventory/MaxUnitStorage", UnitStorage, true)	
			warn('After',PlayerProfileClass:GetField("Inventory"))
		end,
		AlsoAward = 931258600,
		GradientName = "Rare";
	},
	[1932432116] = {Type = 'Product',BuyLimit = 1,Giftable = true,Name = 'Shiny Hunter',
		AlsoAward = 931598388,
		GradientName = "Mythical";
	},
	[1932432115] = {Type = 'Product',BuyLimit = 1,Giftable = true,Name = 'VIP',
		AlsoAward = 887686872,
		GradientName = "Legendary";
		RunOnceCallback = function(Player)
			--TagsService:GiveTags(Player)

			local PlayerProfileClass = DataAPI:GetActivePlayerProfileClass(Player)
			UpdateTitleEvent:FireAllClients(Player.Name,PlayerProfileClass:GetField('CurrentTitle'),true)
		end,
	},
	[1932432113] = {Type = 'Product',BuyLimit = 1,Giftable = true,Name = 'Display All Units',
		AlsoAward = 931436143,
		GradientName = "Rare";
	},
	
	--// Bundles
	[1932432089] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Starter Bundle',
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

	[1932432091] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Mega Bundle',
		Callback = function(Player)
			print('Bought!')
	
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 3500)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 12500)


			local itemService = _G.serverServices.ItemManager
			-- Redstone
			itemService:GiveItems(Player, {["Redstone"]= 10})
			
			-- Potential Keys
			itemService:GiveItems(Player, {["PotentialKey"]= 15})

			-- 10 Rerolls
			itemService:GiveItems(Player, {["TraitCrystal"]= 10})
		end,
		
		GradientName = "Mythical";
	},

	[1932432090] = {Type = 'Product',BuyLimit = 2,Giftable = true,Name = 'Miracle Bundle',
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

	--// Gems
	[1932432122] = {Type = 'Product',Giftable = true,Name = '500 Gems',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 500)

		end,
		
		GradientName = "Gems";
	},

	[1932432120] = {Type = 'Product',Giftable = true,Name = '1,250 Gems',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 1250)

		end,
		
		GradientName = "Gems";
	},

	[1932432119] = {Type = 'Product',Giftable = true,Name = '2,500 Gems',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 2500)

		end,
		
		GradientName = "Gems";
	},

	[1932432118] = {Type = 'Product',Giftable = true,Name = '6,000 Gems',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 6000)

		end,
		
		GradientName = "Gems";
	},

	[1932432117] = {Type = 'Product',Giftable = true,Name = '25,000 Gems',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gems", 25000)

		end,
		
		GradientName = "Gems";
	},

	--// Potions
	[1932432131] = {Type = 'Product',Giftable = true,Name = 'Lucky',
		Callback = function(Player)
			local EffectService = _G.serverServices.EffectService
			EffectService:ApplyEffect(Player, "BasicLuck", 3600)
		end,
		
		GradientColors = {
			Color3.new(0, 0.666667, 0),
			Color3.new(0, 0.333333, 0),
		};
	},

	[1932432128] = {Type = 'Product',Giftable = true,Name = 'Super Lucky',
		Callback = function(Player)
			local EffectService = _G.serverServices.EffectService

			EffectService:ApplyEffect(Player, "SuperLuck", 3600)

		end,
		
		GradientName = "Legendary";
	},

	[1932432127] = {Type = 'Product',Giftable = true,Name = 'Mega Lucky',
		Callback = function(Player)
			local EffectService = _G.serverServices.EffectService

			EffectService:ApplyEffect(Player, "MegaLuck", 3600)

		end,

		GradientColors = {
			Color3.new(0, 0.666667, 0),
			Color3.new(1, 1, 0),
			Color3.new(0.666667, 0, 0),
		};
	},

	[1932432124] = {Type = 'Product',Giftable = true,Name = 'Ultra Lucky',
		Callback = function(Player)
			local EffectService = _G.serverServices.EffectService

			EffectService:ApplyEffect(Player, "MegaLuck", 3600)
			EffectService:ApplyEffect(Player, "SuperLuck", 3600)
			EffectService:ApplyEffect(Player, "BasicLuck", 3600)
			
		end,
		
		GradientColors = {
			Color3.new(0, 0.666667, 0),
			Color3.new(1, 1, 0),
			Color3.new(0.666667, 0, 0),
		};
	},

	--// Trait Rerolls
	[1932432108] = {Type = 'Product',Giftable = true,Name = '1 Trait Reroll',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["TraitCrystal"]= 1})
		end,
		
		GradientColors = {
			Color3.fromHex("#00ff80"),
			Color3.fromHex("#00fbff"),
			Color3.fromHex("#9742ff")
		};
	},

	[1932432107] = {Type = 'Product',Giftable = true,Name = '10 Trait Rerolls',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["TraitCrystal"]= 10})
		end,
		
		GradientColors = {
			Color3.fromHex("#00ff80"),
			Color3.fromHex("#00fbff"),
			Color3.fromHex("#9742ff")
		};
	},

	[1932432105] = {Type = 'Product',Giftable = true,Name = '50 Trait Rerolls',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["TraitCrystal"]= 50})
		end,
		
		GradientColors = {
			Color3.fromHex("#00ff80"),
			Color3.fromHex("#00fbff"),
			Color3.fromHex("#9742ff")
		};
	},

	[1932432104] = {Type = 'Product',Giftable = true,Name = '100 Trait Rerolls',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["TraitCrystal"]= 100})
		end,
		
		GradientColors = {
			Color3.fromHex("#00ff80"),
			Color3.fromHex("#00fbff"),
			Color3.fromHex("#9742ff")
		};
	},

	[1932432103] = {Type = 'Product',Giftable = true,Name = '200 Trait Rerolls',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["TraitCrystal"]= 200})
		end,
		
		GradientColors = {
			Color3.fromHex("#00ff80"),
			Color3.fromHex("#00fbff"),
			Color3.fromHex("#9742ff")
		};
	},

	--// Red Stones
	[1932432094] = {Type = 'Product',Giftable = true,Name = '1 Red Stones',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["Redstone"]= 1})
		end,
		
		GradientColors = {
			Color3.new(1, 0, 0.0156863),
			Color3.new(1, 0.34902, 0.34902)
		};
	},

	[1932432095] = {Type = 'Product',Giftable = true,Name = '3 Red Stones',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["Redstone"]= 3})
		end,
		
		GradientColors = {
			Color3.new(1, 0, 0.0156863),
			Color3.new(1, 0.34902, 0.34902)
		};
	},

	[1932432092] = {Type = 'Product',Giftable = true,Name = '10 Red Stones',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["Redstone"]= 10})
		end,
		
		GradientColors = {
			Color3.new(1, 0, 0.0156863),
			Color3.new(1, 0.34902, 0.34902)
		};
	},

	[1932432093] = {Type = 'Product',Giftable = true,Name = '35 Red Stones',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["Redstone"]= 35})
		end,
		
		GradientColors = {
			Color3.new(1, 0, 0.0156863),
			Color3.new(1, 0.34902, 0.34902)
		};
	},

	[1932432102] = {Type = 'Product',Giftable = true,Name = '75 Red Stones',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["Redstone"]= 75})
		end,
		
		GradientColors = {
			Color3.new(1, 0, 0.0156863),
			Color3.new(1, 0.34902, 0.34902)
		};
	},

	--// Potential Keys
	[1932432101] = {Type = 'Product',Giftable = true,Name = '1 Potential Keys',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["PotentialKey"]= 1})
		end,
		
		GradientColors = {
			Color3.fromRGB(20, 153, 126),
			Color3.fromRGB(227, 247, 10),
			Color3.fromRGB(255, 255, 0),
		};
	},

	[1932432100] = {Type = 'Product',Giftable = true,Name = '5 Potential Keys',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["PotentialKey"]= 5})
		end,
		
		GradientColors = {
			Color3.fromRGB(20, 153, 126),
			Color3.fromRGB(227, 247, 10),
			Color3.fromRGB(255, 255, 0),
		};
	},

	[1932432098] = {Type = 'Product',Giftable = true,Name = '15 Potential Keys',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["PotentialKey"]= 15})
		end,
		
		GradientColors = {
			Color3.fromRGB(20, 153, 126),
			Color3.fromRGB(227, 247, 10),
			Color3.fromRGB(255, 255, 0),
		};
	},

	[1932432099] = {Type = 'Product',Giftable = true,Name = '45 Potential Keys',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["PotentialKey"]= 45})
		end,
		
		GradientColors = {
			Color3.fromRGB(20, 153, 126),
			Color3.fromRGB(227, 247, 10),
			Color3.fromRGB(255, 255, 0),
		};
	},

	[1932432097] = {Type = 'Product',Giftable = true,Name = '175 Potential Keys',
		Callback = function(Player)
			print('Bought!')
			local itemService = _G.serverServices.ItemManager
			itemService:GiveItems(Player, {["PotentialKey"]= 175})
		end,
		
		GradientColors = {
			Color3.fromRGB(20, 153, 126),
			Color3.fromRGB(227, 247, 10),
			Color3.fromRGB(255, 255, 0),
		};
	},

	--// Gold
	[1904332428] = {Type = 'Product',Giftable = true,Name = '1,100 Gold',
		Callback = function(Player)
			print('Bought!')

			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 1100)

		end,
		
		GradientName = "Gold";
	},

	[1904440595] = {Type = 'Product',Giftable = true,Name = '5,500 Gold',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 5500)

		end,
		
		GradientName = "Gold";
	},

	[1904440743] = {Type = 'Product',Giftable = true,Name = '11,000 Gold',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 11_000)

		end,
		
		GradientName = "Gold";
	},

	[1904440841] = {Type = 'Product',Giftable = true,Name = '25,000 Gold',
		Callback = function(Player)
			print('Bought!')
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 25_000)

		end,
		
		GradientName = "Gold";
	},

	[1942503199] = {Type = 'Product',Giftable = true,Name = '105,000 Gold',
		Callback = function(Player)
			_G.serverServices.PlayerService:GiveCurrency(Player, "Gold", 105_000)

		end,
		
		GradientName = "Gold";
	}
	
	--// Passes
	--[] = {Type = 'Product',Giftable = true,Name = '',
	--	function()
	--		print('Bought!')
	--	end,
	--	function()
	--		print('Bought Once')
	--	end,

	--},

	--[] = {Type = 'Product',Giftable = true,Name = '',
	--	function()
	--		print('Bought!')
	--	end,
	--	function()
	--		print('Bought Once')
	--	end,

	--},

	--[] = {Type = 'Product',Giftable = true,Name = '',
	--	function()
	--		print('Bought!')
	--	end,
	--	function()
	--		print('Bought Once')
	--	end,

	--},

	--[] = {Type = 'Product',Giftable = true,Name = '',
	--	function()
	--		print('Bought!')
	--	end,
	--	function()
	--		print('Bought Once')
	--	end,

	--},


	
}:: {[number]: ProductDataType}