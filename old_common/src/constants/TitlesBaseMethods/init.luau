local module = {}


function module:InitTitle(Player:Player,HasVip)
	local Char = Player.Character or Player.CharacterAdded:Wait()
	
	local Title = self.config.GUI:Clone()
	if self.config.Custom ~= true then
		Title.StudsOffset = script.TitleOverhead.StudsOffset
		Title.ExtentsOffset = script.TitleOverhead.ExtentsOffset
		Title.Size = script.TitleOverhead.Size
	end
	Title.Parent = Char.Head
	task.spawn(function()
		self:Animation(Title)
	end)
	--warn('HasVip',HasVip)
	if HasVip then
		Title.StudsOffset += Vector3.new(0,.75,0)
		

		
	end
end

function module:Animation(Title)
end

return module
