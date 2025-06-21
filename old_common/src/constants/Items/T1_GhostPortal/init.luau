local Item = {}

Item.NotStackable = true
Item.configuration = {
	TrueName = script.Name :: string,
	DisplayName = "T1 Ghost Portal" :: string,
	Description = "Use to open" :: string,
	ViewportCFrame = CFrame.new(-0.3, 1, -18) * CFrame.Angles(math.rad(0), math.rad(-180), 0) :: CFrame,
	PreviewViewport = CFrame.new(-0.5, -0.3, -21) * CFrame.Angles(math.rad(0), math.rad(-180), 0) :: CFrame,
	Rarity = "Mythical" :: string,
	Usable = true :: boolean,
	Sort = { "Portal" },
}

function Item.GetCustomData()
	local AllChallenges = {}
	for i, v in pairs(_G.Registry.registry.Challenges) do
		if i ~= "Traits Disabled" then
			table.insert(AllChallenges, i)
		end
	end

	local AllElements = {}
	for i, v in pairs(_G.Registry.registry.ElementalModifiers) do
		table.insert(AllElements, i)
	end

	local Challenge = AllChallenges[math.random(1, #AllChallenges)]

	local Buff = AllElements[math.random(1, #AllElements)]
	table.remove(AllElements, table.find(AllElements, Buff))
	local Debuff = AllElements[math.random(1, #AllElements)]

	return {
		Map = "Ghost Tunnel",
		Act = math.random(1, 6),
		Challenge = Challenge,
		Buff = Buff,
		Debuff = Debuff,
		ForcedElements = {
			[Buff] = {
				Min = 0,
				Max = 25,
			},
			[Debuff] = {
				Min = -50,
				Max = 0,
			},
		},
	}
end

local Tree = require("@pkgs/tree")
Item.misc = {
	Model = Tree.Find(game:GetService("ReplicatedStorage").Assets.items, script.Name, "Model") :: Model,
}

return Item
