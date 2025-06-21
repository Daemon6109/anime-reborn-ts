local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.TitlesBaseMethods)})

module.config = {
	Name = "Contributor", -- the name of the title that will show in inventory
	GUI = script.TitleOverhead,
	Description = 'Thank you for your contribution'
}

function module:Animation(Title)
	--while Title.Parent do
		--if not Title:FindFirstChild('TextLabel') then break end
		Title.TextLabel.UIGradient.Offset = Vector2.new(-1,0)
		game.TweenService:Create(Title.TextLabel.UIGradient,TweenInfo.new(.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false),{Offset = Vector2.new(1,0)}):Play()
		--task.wait(3)
	--end
end

return module
