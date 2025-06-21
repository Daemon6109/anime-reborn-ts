local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.TitlesBaseMethods)})

module.config = {
	Name = "Baller", -- the name of the title that will show in inventory
	GUI = script.TitleOverhead,
	Description = 'Spend a total of 1,000,000 Gems.'
}

function module:Animation(Title)
	Title.TextLabel.UIGradient.Offset = Vector2.new(-.6,0)
	game.TweenService:Create(Title.TextLabel.UIGradient,TweenInfo.new(1.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false),{Offset = Vector2.new(.6,0)}):Play()

end
return module
