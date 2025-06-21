local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.TitlesBaseMethods)})

module.config = {
	Name = "Defender!", -- the name of the title that will show in inventory
	GUI = script.TitleOverhead,
	--Description = '???'
}

function module:Animation(Title)
	local TweenI = TweenInfo.new(1.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
	while Title.Parent do
		if not Title:FindFirstChild('TextLabel') then break end
		game.TweenService:Create(Title.TextLabel,TweenI,{Position = UDim2.fromScale(.5,.55)}):Play()
		task.wait(1)
		if not Title:FindFirstChild('TextLabel') then break end
		game.TweenService:Create(Title.TextLabel,TweenI,{Position = UDim2.fromScale(.5,.45)}):Play()
		task.wait(1)
	end
end

return module
