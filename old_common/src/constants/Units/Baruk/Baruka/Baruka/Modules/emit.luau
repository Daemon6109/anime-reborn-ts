local emit = {}

function emit.emitvfx(part)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("ParticleEmitter") then
				local emitCount = v:GetAttribute("EmitCount")
				v:Emit(emitCount)
			end
		end)	
	end	
end

function emit.enablevfx(part,yes)
	for i, v in pairs(part:GetDescendants()) do
		task.spawn(function()
			if v:IsA("ParticleEmitter") then
				v.Enabled = yes
			elseif v:IsA("Beam") then
				v.Enabled = yes
			elseif v:IsA("Trail") then
				v.Enabled = yes
			elseif v:IsA("PointLight") then
				v.Enabled = yes
			end
		end)	
	end	
end


return emit
