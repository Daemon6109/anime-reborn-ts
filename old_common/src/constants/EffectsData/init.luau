local function createEffectData(effect: Effect): Effect
	return effect
end

return {
	["BasicLuck"] = createEffectData({
		Icon = "rbxassetid://114034975822906",
		-- Gradient = script.Gradients:FindFirstChild("Epic"),
		Description = "Grants the player a 20% banner luck boost",
		DisplayName = "Basic Luck",
		Multiplier = { ["BannerLuck"] = 1.2 },
	}),
	["50%Exp"] = createEffectData({
		Icon = "rbxassetid://100748281662589",
		-- Gradient = script.Gradients:FindFirstChild("Epic"),
		Description = "Grants the player a 50% (PLAYER EXP BOOST)",
		DisplayName = "50% Experience Boost",
		Multiplier = { ["ExpBoost"] = 1.5 },
	}),
	["ShinyBoost"] = createEffectData({
		Icon = "rbxassetid://139517965516468",
		-- Gradient = script.Gradients:FindFirstChild("Legendary"),
		Description = "Grants the player a 10% banner shiny luck boost",
		DisplayName = "Shiny Chance Boost",
		Multiplier = { ["ShinyBoost"] = 1.1 },
	}),
	["LegendsBoost"] = createEffectData({
		Icon = "rbxassetid://132445499585525",
		-- Gradient = script.Gradients:FindFirstChild("Legendary"),
		Description = "Grants the player a 2x drop chance boost for (unit) in Legend Stages",
		DisplayName = "Legend's Boost",
		Multiplier = { ["DropChanceBoost"] = 2 },
	}),
	["MegaLuck"] = createEffectData({
		Icon = "rbxassetid://94606088984849",
		-- Gradient = script.Gradients:FindFirstChild("Mythical"),
		Description = "Grants the player a 100% banner luck boost and a 10% banner shiny luck boost",
		DisplayName = "Mega Luck",
		Multiplier = {
			["ShinyBoost"] = 1.1,
			["BannerLuck"] = 2,
		},
	}),

	["SuperLuck"] = createEffectData({
		Icon = "rbxassetid://106919223451712",
		-- Gradient = script.Gradients:FindFirstChild("Mythical"),
		Description = "Grants the player a 50% banner luck boost",
		DisplayName = "Super Luck",
		Multiplier = {
			["BannerLuck"] = 1.5,
		},
	}),
} :: Effects
