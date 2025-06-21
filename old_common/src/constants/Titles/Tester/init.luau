local module = {}

setmetatable(module,{__index = require(game.ReplicatedStorage.Registry.TitlesBaseMethods)})

module.config = {
	Name = "Tester", -- the name of the title that will show in inventory
	GUI = script.TitleOverhead,
	Custom = true,
	Description = 'Helps test upcoming releases and updates.'
}

function module:Animation(Title)
	local IMG = Title:FindFirstChildOfClass("ImageLabel")
	local xIndex = 0
	local yIndex = 0
	local maxX = Title:GetAttribute("maxXY").X
	local maxY = Title:GetAttribute("maxXY").Y

	local PixelRate = Title:GetAttribute("PixelRate")

	while task.wait(1/Title:GetAttribute("Frames")) and Title.Parent do
		local CURRENT_OFFSET = IMG.ImageRectOffset

		IMG.ImageRectOffset = Vector2.new(xIndex, yIndex)

		xIndex += PixelRate

		if xIndex == maxX then
			xIndex = 0
			yIndex += PixelRate

			if yIndex == maxY then
				yIndex = 0
			end
		end
	end
end

return module
