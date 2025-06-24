-- Extract remaining L-units configuration and status
local unitsToExtract = {"Law", "Leopold", "Levi", "Licht", "Luck [Evo]", "Luffy [DR]", "Luffy [DR] [Evo]", "Luffy [PTS]"}

for _, unitName in ipairs(unitsToExtract) do
    print("=== " .. unitName .. " ===")
    
    local unitModule = game.ReplicatedStorage.Registry.Units:FindFirstChild(unitName)
    if unitModule then
        local released = unitModule:FindFirstChild("Released")
        local summonable = unitModule:FindFirstChild("Summonable")
        
        if released and summonable then
            print("Released:", tostring(released.Value))
            print("Summonable:", tostring(summonable.Value))
        else
            print("Missing Released/Summonable data")
        end
    else
        print("Module not found")
    end
    print()
end
