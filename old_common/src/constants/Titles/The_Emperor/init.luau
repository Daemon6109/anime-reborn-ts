local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.TitlesBaseMethods)})

module.config = {
	Name = "The Emperor", -- the name of the title that will show in inventory
	GUI = script.TitleOverhead,
	Description = 'Has obtained Secret Dragon Emperor.'
}

function module:Animation(Title)
	Title.TextLabel.UIGradient.Offset = Vector2.new(-1,0)
	game.TweenService:Create(Title.TextLabel.UIGradient,TweenInfo.new(1.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1,false),{Offset = Vector2.new(1,0)}):Play()

end

return module
