local data ={
	Damage = {
		["C-"] = .9,
		["C"] = .935,
		["C+"] = .97,
		["B-"] = 1,
		["B"] = 1.03,
		["B+"] = 1.065,
		["A-"] = 1.1,
		["A"] = 1.125,
		["A+"] = 1.148,
		["S-"] = 1.17,
		["S"] = 1.178,
		["S+"] = 1.185,
		["SS"] = 1.192,
		["SSS"] = 1.2,
	},

	AttackSpeed = {
		["C-"] = .9,
		["C"] = .95,
		["C+"] = .98,
		["B-"] = 1,
		["B"] = 1.017,
		["B+"] = 1.034,
		["A-"] = 1.05,
		["A"] = 1.063,
		["A+"] = 1.073,
		["S-"] = 1.085,
		["S"] = 1.089,
		["S+"] = 1.093,
		["SS"] = 1.096,
		["SSS"] = 1.1,
	},

	Range = {
		["C-"] = .9,
		["C"] = .95,
		["C+"] = .98,
		["B-"] = 1,
		["B"] = 1.017,
		["B+"] = 1.034,
		["A-"] = 1.05,
		["A"] = 1.063,
		["A+"] = 1.073,
		["S-"] = 1.085,
		["S"] = 1.089,
		["S+"] = 1.093,
		["SS"] = 1.096,
		["SSS"] = 1.1,
	},

	Weights = {
		["C-"] = 125,
		["C"] = 150,
		["C+"] = 150,
		["B-"] = 200,
		["B"] = 117,
		["B+"] = 100,
		["A-"] = 50,
		["A"] = 40,
		["A+"] = 30,
		["S-"] = 15,
		["S"] = 10,
		["S+"] = 8,
		["SS"] = 4,
		["SSS"] = 1,
	},
	
	Weights50Worth = {
		--["C-"] = 125,
		--["C"] = 150,
		--["C+"] = 150,
		--["B-"] = 200,
		["B"] = 742,
		["B+"] = 100,
		["A-"] = 50,
		["A"] = 40,
		["A+"] = 30,
		["S-"] = 15,
		["S"] = 10,
		["S+"] = 8,
		["SS"] = 4,
		["SSS"] = 1,
	},
	
	Weights100Worth = {
		--["C-"] = 125,
		--["C"] = 150,
		--["C+"] = 150,
		--["B-"] = 200,
		--["B"] = 117,
		--["B+"] = 100,
		--["A-"] = 892,
		--["A"] = 40,
		--["A+"] = 300,
		["S-"] = 250,
		["S"] = 200,
		["S+"] = 8,
		["SS"] = 4,
		["SSS"] = 1,
	},

	Order = {
		"C-",
		"C",
		"C+",
		"B-",
		"B",
		"B+",
		"A-",
		"A",
		"A+",
		"S-",
		"S",
		"S+",
		"SS",
		"SSS",
	},

	OrderNums = {
		["???"] = 1,
		["C-"] = 1,
		["C"] = 2,
		["C+"] = 3,
		["B-"] = 4,
		["B"] = 5,
		["B+"] = 6,
		["A-"] = 7,
		["A"] = 8,
		["A+"] = 9,
		["S-"] = 10,
		["S"] = 11,
		["S+"] = 12,
		["SS"] = 13,
		["SSS"] = 14,
	},
}

function data:GetSymbol(Number, Type)
	local SymbolType = data[Type]
	local TrueNumber = tonumber(Number)

	if SymbolType and TrueNumber ~= nil then
		local symbol = {"C-", 0}

		for i,v in pairs(SymbolType) do
			if TrueNumber >= v and symbol[2] < v then
				symbol = {i, v}
			end
		end

		return symbol[1]
	end

	return "???"
end

data.SymbolsColorSequence = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.new(.6,0,0)),
	ColorSequenceKeypoint.new(.2, Color3.new(1,.8,0)),
	ColorSequenceKeypoint.new(.4, Color3.new(.5,1,0)),
	ColorSequenceKeypoint.new(.8,Color3.new(0,1,.7)),
	ColorSequenceKeypoint.new(1,Color3.new(0,1,1))
}

--this is a copy paste from roblox documentation lmao
function data:evalColorSequence(sequence: ColorSequence, time: number)
	-- If time is 0 or 1, return the first or last value respectively
	if time == 0 then
		return sequence.Keypoints[1].Value
	elseif time == 1 then
		return sequence.Keypoints[#sequence.Keypoints].Value
	end

	-- Otherwise, step through each sequential pair of keypoints
	for i = 1, #sequence.Keypoints - 1 do
		local thisKeypoint = sequence.Keypoints[i]
		local nextKeypoint = sequence.Keypoints[i + 1]
		if time >= thisKeypoint.Time and time < nextKeypoint.Time then
			-- Calculate how far alpha lies between the points
			local alpha = (time - thisKeypoint.Time) / (nextKeypoint.Time - thisKeypoint.Time)
			-- Evaluate the real value between the points using alpha
			return Color3.new(
				(nextKeypoint.Value.R - thisKeypoint.Value.R) * alpha + thisKeypoint.Value.R,
				(nextKeypoint.Value.G - thisKeypoint.Value.G) * alpha + thisKeypoint.Value.G,
				(nextKeypoint.Value.B - thisKeypoint.Value.B) * alpha + thisKeypoint.Value.B
			)
		end
	end
end

return data