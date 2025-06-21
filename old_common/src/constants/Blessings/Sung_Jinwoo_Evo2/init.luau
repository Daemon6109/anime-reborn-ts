--// @bravobravo909
local module = {}
local replicatedStorage = game.ReplicatedStorage
local defaultIdle = replicatedStorage.Animations.Idle.Value
local AnimModule = require(game.ReplicatedStorage.AnimModule) 


-- use this please
--//IF YOU ARE USING ANY EXTERNAL MODULES, PLEASE LET ME (bravo) KNOW BEFOREHAND

local destroyOnStop = {}
local localPlayer = game.Players.LocalPlayer

function module:Equip(_player : Player)
	local char = _player.Character or _player.CharacterAdded:Wait()
	if not destroyOnStop[_player.UserId] then destroyOnStop[_player.UserId] = {} end
	for _,v in script:GetChildren() do
		local partClone = v:Clone()
		local motor6D = partClone:FindFirstChildOfClass("Motor6D")
		motor6D.Part1 = char:FindFirstChild(motor6D.Name)
		partClone.Parent = char
		
		table.insert(destroyOnStop[_player.UserId], partClone)
	end
	
	
	if _player ~= localPlayer then return end

	_player.IdleAnimationValue.Value = 91498798762585
end

function module:Unequip(_player: Player)
	if not destroyOnStop[_player.UserId] then return end

	local char = _player.Character or _player.CharacterAdded:Wait()
	for _,v in destroyOnStop[_player.UserId] do
		v:Destroy()
	end
	destroyOnStop[_player.UserId] = {}

	if _player ~= localPlayer then return end
	_player.IdleAnimationValue.Value = defaultIdle

end

return module
